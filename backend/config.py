# type: ignore
from pathlib import Path

MODEL_NAME   = "efficientnet_b0"
NUM_CLASSES  = 1
IMAGE_SIZE   = 224
MODEL_WEIGHTS_PATH = Path(__file__).parent / "best_model.pth"
NORM_MEAN = (0.485, 0.456, 0.406)
NORM_STD  = (0.229, 0.224, 0.225)
ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".bmp"}
MAX_FILE_SIZE_MB   = 10
CONFIDENCE_THRESHOLD = 0.5

CONFIDENCE_TIERS = [
    (0.80, "High"),
    (0.60, "Moderate"),
    (0.00, "Low"),
]
CLASS_NAMES = ["Normal", "Stroke"]

API_HOST    = "0.0.0.0"
API_PORT    = 8000
CORS_ORIGINS = ["*"]

DISCLAIMER = (
    "This result is not a medical diagnosis. "
    "StrokeScope is an educational and decision-support tool only. "
    "Always consult a licensed medical professional for any clinical decisions."
)