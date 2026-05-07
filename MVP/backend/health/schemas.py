# type: ignore
from pydantic import BaseModel, Field
from typing import Literal
class BinaryClassScores(BaseModel):
    Normal: float = Field(..., ge = 0.0, le = 1.0, description = "Probability of no stroke")
    Stroke: float = Field(..., ge = 0.0, le = 1.0, description = "Probability of stroke")
class AnalyzeResponse(BaseModel):
    predicted_class: Literal["Normal", "Stroke"] = Field(
        ..., description = "Predicted class at 0.5 decision threshold"
    )
    confidence: float = Field(
        ..., ge = 0.0, le = 1.0,
        description = "Sigmoid probability of the predicted class"
    )
    confidence_tier: Literal["Low", "Moderate", "High"] = Field(
        ..., description = "Human-readable confidence tier"
    )
    stroke_probability: float = Field(
        ..., ge = 0.0, le = 1.0,
        description = "Raw sigmoid probability that the scan shows stroke"
    )
    low_confidence: bool = Field(
        ..., description = "True when confidence < 0.60 — result may be unreliable"
    )
    all_class_scores: BinaryClassScores = Field(
        ..., description = "Probabilities for both classes"
    )
    llm_explanation: str | None = Field(
        default = None,
        description = "AI-generated plain-language summary (populated by LLM layer)"
    )
    disclaimer: str = Field(
        ..., description = "Mandatory medical disclaimer"
    )
class FeedbackRequest(BaseModel):
    ease_of_use: int = Field(..., ge = 1, le = 5, description = "Star rating 1–5")
    comments: str | None = Field(default = None, max_length = 2000)
    timestamp: str | None = Field(default = None, description = "ISO 8601 UTC timestamp")
class FeedbackResponse(BaseModel):
    status: Literal["ok", "error"]
    message: str
class HealthResponse(BaseModel):
    status: Literal["ok"]
    model_loaded: bool
    device: str