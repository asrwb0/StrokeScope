from model import load_model
from dataclasses import dataclass
from dicom import load_dicom, preprocess
from config import LABEL_COLS, PREDICTION_THRESHOLD

# this stores the result of get_model into _model
_model = None

def get_model():
    global _model
    if _model is None:
        _model = load_model()
    return _model

# create a dataclass to store all relevant information about a model
@dataclass
class PredictionResult:
    probabilities: dict
    predictions: dict
    any_hemorrhage: bool
    low_confidence: bool

def predict(image_path):
    loaded_image = load_dicom(image_path)
    processed_image = preprocess(loaded_image)
    raw = get_model().predict(processed_image)[0]

    probabilities = {}
    for label, prob in zip(LABEL_COLS, raw):
        probabilities[label] = float(prob)

    predictions = {}
    for label, prob in probabilities.items():
        predictions[label] = prob >= PREDICTION_THRESHOLD

    any_hemorrhage = predictions["any"]

    subtype_probs = []
    for l in LABEL_COLS:
        if l != "any":
            subtype_probs.append(probabilities[l])

    low_confidence = max(subtype_probs) < (PREDICTION_THRESHOLD + 0.1)

    return PredictionResult(
        probabilities = probabilities,
        predictions = predictions,
        any_hemorrhage = any_hemorrhage,
        low_confidence = low_confidence
    )