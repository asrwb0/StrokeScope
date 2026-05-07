# type: ignore
from __future__ import annotations

import io
import torch
import numpy as np
from PIL import Image
import albumentations as A
from albumentations.pytorch import ToTensorV2

from config import (
    IMAGE_SIZE, NORM_MEAN, NORM_STD,
    CONFIDENCE_THRESHOLD, CONFIDENCE_TIERS,
    CLASS_NAMES, DISCLAIMER,
)
from .model import StrokeModel

_val_transform = A.Compose([
    A.Resize(IMAGE_SIZE, IMAGE_SIZE),
    A.Normalize(mean = NORM_MEAN, std = NORM_STD),
    ToTensorV2(),
])


def _confidence_tier(score: float) -> str:
    for threshold, label in CONFIDENCE_TIERS:
        if score >= threshold:
            return label
    return "Low"


def preprocess_image(image_bytes: bytes) -> torch.Tensor:
    pil_img = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    img_np  = np.array(pil_img, dtype = np.uint8)
    transformed = _val_transform(image = img_np)
    tensor = transformed["image"]
    return tensor.unsqueeze(0)

def predict(model: StrokeModel,
            image_bytes: bytes,
            device: torch.device | None = None) -> dict:
    if device is None:
        device = next(model.parameters()).device

    tensor = preprocess_image(image_bytes).to(device)

    with torch.no_grad():
        logit       = model(tensor)
        stroke_prob = torch.sigmoid(logit).item()

    normal_prob     = 1.0 - stroke_prob
    is_stroke       = stroke_prob >= CONFIDENCE_THRESHOLD
    predicted_class = CLASS_NAMES[int(is_stroke)]
    confidence      = stroke_prob if is_stroke else normal_prob

    return {
        "predicted_class":    predicted_class,
        "confidence":         round(confidence, 4),
        "confidence_tier":    _confidence_tier(confidence),
        "stroke_probability": round(stroke_prob, 4),
        "low_confidence":     confidence < 0.60,
        "all_class_scores": {
            "Normal": round(normal_prob, 4),
            "Stroke": round(stroke_prob, 4),
        },
        "disclaimer": DISCLAIMER,
    }