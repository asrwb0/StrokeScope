# type: ignore
from pydantic import BaseModel, Field
from typing import Literal
class BinaryClassScores(BaseModel):
    Normal: float = Field(..., ge=0.0, le=1.0, description="Probability of no stroke")
    Stroke: float = Field(..., ge=0.0, le=1.0, description="Probability of stroke")
class AnalyzeResponse(BaseModel):
    predicted_class: Literal["Normal", "Stroke"] = Field(
        ..., description="Predicted class at 0.5 decision threshold"
    )
    confidence: float = Field(
        ..., ge=0.0, le=1.0,
        description="Sigmoid probability of the predicted class"
    )
    confidence_tier: Literal["Low", "Moderate", "High"] = Field(
        ..., description="Human-readable confidence tier"
    )
    stroke_probability: float = Field(
        ..., ge=0.0, le=1.0,
        description="Raw sigmoid probability that the scan shows stroke"
    )
    low_confidence: bool = Field(
        ..., description="True when confidence < 0.60 — result may be unreliable"
    )
    all_class_scores: BinaryClassScores = Field(
        ..., description="Probabilities for both classes"
    )
    llm_explanation: str | None = Field(
        default=None,
        description="AI-generated plain-language summary (populated by LLM layer)"
    )
    disclaimer: str = Field(
        ..., description="Mandatory medical disclaimer"
    )
class FeedbackRequest(BaseModel):
    role: str | None = Field(default=None, description="User's role")
    rating: float | None = Field(default=None, ge=0.0, le=5.0, description="Star rating 0–5")
    area: str | None = Field(default=None, description="Area of the app being reviewed")
    comments: str | None = Field(default=None, max_length=2000)
    permission: str | None = Field(default=None, description="Consent string")
    consentGiven: bool | None = Field(default=None, description="Whether consent was given")

class FeedbackResponse(BaseModel):
    status: Literal["ok", "error"]
    message: str
class HealthResponse(BaseModel):
    status: Literal["ok"]
    model_loaded: bool
    device: str