# type: ignore

from __future__ import annotations

import io
import time
from pathlib import Path

from fastapi import APIRouter, File, HTTPException, Request, UploadFile, status
from fastapi.responses import JSONResponse

from config import ALLOWED_EXTENSIONS, MAX_FILE_SIZE_MB, DISCLAIMER
from functions.predictor import predict
from health.schemas import AnalyzeResponse, FeedbackRequest, FeedbackResponse, HealthResponse

router = APIRouter(prefix = "/api")

def _validate_upload(file: UploadFile, data: bytes) -> None:
    ext = Path(file.filename or "").suffix.lower()
    if ext not in ALLOWED_EXTENSIONS:
        raise HTTPException(
            status_code = status.HTTP_415_UNSUPPORTED_MEDIA_TYPE,
            detail = (
                f"Unsupported file type '{ext}'. "
                f"Accepted formats: {', '.join(sorted(ALLOWED_EXTENSIONS))}"
            ),
        )
    size_mb = len(data) / (1024 * 1024)
    if size_mb > MAX_FILE_SIZE_MB:
        raise HTTPException(
            status_code = status.HTTP_413_REQUEST_ENTITY_TOO_LARGE,
            detail = f"File size {size_mb:.1f} MB exceeds the {MAX_FILE_SIZE_MB} MB limit.",
        )

@router.post(
    "/analyze",
    response_model = AnalyzeResponse,
    summary = "Analyse a brain CT scan",
    description = (
        "Upload a JPEG or PNG brain CT scan. "
        "Returns binary classification (Normal / Stroke) with confidence scores "
        "and an optional AI-generated plain-language explanation."
    ),
)
async def analyze(request: Request, file: UploadFile = File(...)):
    # Read upload
    data = await file.read()
    _validate_upload(file, data)

    # Retrieve model from app state (set in main.py lifespan)
    model = getattr(request.app.state, "model", None)
    if model is None:
        raise HTTPException(
            status_code = status.HTTP_503_SERVICE_UNAVAILABLE,
            detail = "Model is not loaded. Check server startup logs.",
        )

    # Run inference
    try:
        result = predict(model, data)
    except Exception as exc:
        raise HTTPException(
            status_code = status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail = f"Inference failed: {exc}",
        )

    result["llm_explanation"] = None

    return AnalyzeResponse(**result)

@router.post(
    "/feedback",
    response_model = FeedbackResponse,
    summary = "Submit user feedback",
)
async def feedback(payload: FeedbackRequest):
    print(
        f"[feedback] rating={payload.ease_of_use} "
        f"comment={payload.comments!r} ts={payload.timestamp}"
    )
    return FeedbackResponse(status ="ok", message = "Feedback received. Thank you!")

@router.get(
    "/health",
    response_model = HealthResponse,
    summary = "Health check",
)
async def health(request: Request):
    import torch
    model = getattr(request.app.state, "model", None)
    device = str(next(model.parameters()).device) if model else "unknown"
    return HealthResponse(
        status = "ok",
        model_loaded = model is not None,
        device = device,
    )