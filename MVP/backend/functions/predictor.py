from model import load_model
from dataclasses import dataclass
from dicom import load_dicom, preprocess

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

def predict(image):
    loaded_image = load_dicom(image)
    processed_image = preprocess(loaded_image)
    get_model.predict()
    # more to be done