# type: ignore
from __future__ import annotations

import sys
from contextlib import asynccontextmanager
from pathlib import Path

import torch
import uvicorn
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

sys.path.insert(0, str(Path(__file__).parent))

from config import API_HOST, API_PORT, CORS_ORIGINS, MODEL_WEIGHTS_PATH
from functions.model import load_model
from api.routes import router

@asynccontextmanager
async def lifespan(app: FastAPI):
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    print(f"[startup] Device: {device}")

    if not MODEL_WEIGHTS_PATH.exists():
        app.state.model = None
    else:
        app.state.model = load_model(MODEL_WEIGHTS_PATH, device = device)

    yield

    app.state.model = None
    print("[shutdown] Model released.")

app = FastAPI(
    title = "StrokeScope API",
    version = "2.0.0",
    description = (
        "Brain stroke CT classification API. "
        "Binary model: Normal vs Stroke (EfficientNet-B0, PyTorch). "
        "Dataset: Brain Stroke CT Dataset (ozguraslank/brain-stroke-ct-dataset)."
    ),
    lifespan = lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins = CORS_ORIGINS,
    allow_credentials = True,
    allow_methods = ["*"],
    allow_headers = ["*"],
)

app.include_router(router)

if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host = API_HOST,
        port = API_PORT,
        reload = True,
    )