# type: ignore

from __future__ import annotations
import sys
import os
from pathlib import Path

_backend_dir = str(Path(__file__).resolve().parent.parent)
if _backend_dir not in sys.path:
    sys.path.insert(0, _backend_dir)

from fastapi import APIRouter, File, HTTPException, Request, UploadFile, status

from config import ALLOWED_EXTENSIONS, MAX_FILE_SIZE_MB
from functions.predictor import predict
from health.schemas import AnalyzeResponse, FeedbackRequest, FeedbackResponse, HealthResponse

router = APIRouter(prefix="/api")

def _validate_upload(file: UploadFile, data: bytes) -> None:
    ext = Path(file.filename or "").suffix.lower()
    if ext not in ALLOWED_EXTENSIONS:
        raise HTTPException(
            status_code=status.HTTP_415_UNSUPPORTED_MEDIA_TYPE,
            detail=f"Unsupported file type '{ext}'. Accepted: {', '.join(sorted(ALLOWED_EXTENSIONS))}",
        )
    size_mb = len(data) / (1024 * 1024)
    if size_mb > MAX_FILE_SIZE_MB:
        raise HTTPException(
            status_code=status.HTTP_413_REQUEST_ENTITY_TOO_LARGE,
            detail=f"File size {size_mb:.1f} MB exceeds the {MAX_FILE_SIZE_MB} MB limit.",
        )


def _get_llm_explanation(result: dict) -> str | None:
    try:
        from functions.wrapper import GPTWrapper
        wrapper = GPTWrapper()
        return wrapper.explain(result)
    except RuntimeError as e:
        print(f"[llm] Skipping explanation — {e}")
        return None
    except Exception as e:
        print(f"[llm] Explanation failed — {type(e).__name__}: {e}")
        return None


@router.post("/analyze", response_model=AnalyzeResponse, summary="Analyse a brain CT scan")
async def analyze(request: Request, file: UploadFile = File(...)):
    data = await file.read()
    _validate_upload(file, data)

    model = getattr(request.app.state, "model", None)
    if model is None:
        raise HTTPException(status_code=503, detail="Model not loaded.")

    try:
        result = predict(model, data)
    except Exception as exc:
        raise HTTPException(status_code=500, detail=f"Inference failed: {exc}")

    result["llm_explanation"] = _get_llm_explanation(result)
    return AnalyzeResponse(**result)


@router.post("/feedback", response_model=FeedbackResponse)
async def feedback(payload: FeedbackRequest):
    print(f"[feedback] role={payload.role} rating={payload.rating} area={payload.area} consent={payload.consentGiven} comment={payload.comments!r}")
    return FeedbackResponse(status="ok", message="Feedback received. Thank you!")


@router.get("/health", response_model=HealthResponse)
async def health(request: Request):
    import torch
    model = getattr(request.app.state, "model", None)
    device = str(next(model.parameters()).device) if model else "unknown"
    return HealthResponse(status="ok", model_loaded=model is not None, device=device)