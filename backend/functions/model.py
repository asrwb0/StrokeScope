# type: ignore
from __future__ import annotations

import sys
from pathlib import Path

_backend_dir = str(Path(__file__).resolve().parent.parent)
if _backend_dir not in sys.path:
    sys.path.insert(0, _backend_dir)

import torch
import torch.nn as nn
import timm
from config import MODEL_NAME, NUM_CLASSES, MODEL_WEIGHTS_PATH
class StrokeModel(nn.Module):
    def __init__(self, model_name: str = MODEL_NAME, pretrained: bool = False):
        super().__init__()
        self.backbone = timm.create_model(
            model_name,
            pretrained = pretrained,
            num_classes = 0,
            global_pool = "avg",
        )
        n_feat = self.backbone.num_features
        self.head = nn.Sequential(
            nn.Dropout(0.3),
            nn.Linear(n_feat, 256),
            nn.SiLU(),
            nn.Dropout(0.2),
            nn.Linear(256, NUM_CLASSES),
        )

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        return self.head(self.backbone(x)).squeeze(1)


def load_model(weights_path: Path = MODEL_WEIGHTS_PATH,
               device: torch.device | None = None) -> StrokeModel:
    if device is None:
        device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

    model = StrokeModel(pretrained = False)
    state = torch.load(weights_path, map_location = device)
    state = {k.replace("_orig_mod.", "").replace("module.", ""): v
             for k, v in state.items()}
    model.load_state_dict(state, strict = True)
    model.to(device)
    model.eval()
    return model