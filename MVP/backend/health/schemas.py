# type: ignore
from pydantic import BaseModel, Field
from typing import Dict

DISCLAIMER = ("This output is for research and educational purposes only and does not constitute a clinical diagnosis. It is not intended to replace professional medical advice, diagnosis, or treatment. Patients should consult a licensed healthcare provider, and healthcare professionals should exercise clinical judgment when interpreting results.")

class AnalyzeResponse(BaseModel):
    probabilities: Dict[str, float]
    predictions: Dict[str, bool]
    any_hemorrhage: bool
    low_confidence: bool
    heatmap_url: str
    disclaimer: str = DISCLAIMER

class HealthResponse(BaseModel):
    status: str
    model_loaded: bool