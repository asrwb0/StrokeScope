# type: ignore
from __future__ import annotations

from pathlib import Path

import pandas as pd
from sklearn.model_selection import train_test_split

SEED = 42
VAL_FRAC = 0.20

# Folder → binary label mapping (matches the training notebook)
CLASS_MAP: dict[str, int] = {
    "Normal":   0,
    "Bleeding": 1,
    "Ischemia": 1,
}

ALLOWED_SUFFIXES = {".jpg", ".jpeg", ".png", ".bmp"}


def build_dataframe(data_dir: str | Path) -> pd.DataFrame:
    """
    Scan *data_dir* for all labelled images and return a flat DataFrame.

    Columns:
        path       (str)  absolute path to the image file
        label      (int)  0 = Normal, 1 = Stroke
        class_name (str)  original folder name (Normal / Bleeding / Ischemia)

    Args:
        data_dir: Root directory containing Normal/, Bleeding/, Ischemia/ folders
                  (each with a PNG/ sub-folder).

    Returns:
        DataFrame sorted by path with columns [path, label, class_name].
    """
    data_dir = Path(data_dir)
    records: list[dict] = []

    for class_name, label in CLASS_MAP.items():
        class_dir = data_dir / class_name / "PNG"
        if not class_dir.exists():
            print(f"[data] WARNING: expected directory not found: {class_dir}")
            continue

        for img_path in sorted(class_dir.glob("*")):
            if img_path.suffix.lower() in ALLOWED_SUFFIXES:
                records.append({
                    "path":       str(img_path),
                    "label":      label,
                    "class_name": class_name,
                })

    df = pd.DataFrame(records)
    print(f"[data] Total images found : {len(df):,}")
    if not df.empty:
        print(df["class_name"].value_counts().to_string())
    return df


def split_dataframe(df: pd.DataFrame,
                    val_frac: float = VAL_FRAC,
                    seed: int = SEED) -> tuple[pd.DataFrame, pd.DataFrame]:
    """
    Stratified 80/20 split on the binary label column.

    Returns:
        (df_train, df_val) — both reset-indexed.
    """
    df_train, df_val = train_test_split(
        df,
        test_size=val_frac,
        stratify=df["label"],
        random_state=seed,
    )
    df_train = df_train.reset_index(drop=True)
    df_val   = df_val.reset_index(drop=True)

    print(f"\n[data] Train: {len(df_train):,}  |  Val: {len(df_val):,}")
    return df_train, df_val


def compute_pos_weight(df: pd.DataFrame) -> float:
    """
    Compute the positive-class weight for BCEWithLogitsLoss.

    Returns:
        n_normal / n_stroke  (used as pos_weight in training)
    """
    n_neg = (df["label"] == 0).sum()
    n_pos = (df["label"] == 1).sum()
    w = n_neg / max(n_pos, 1)
    print(f"[data] pos_weight (Normal/Stroke) = {w:.2f}")
    return w


# ── Quick sanity check ─────────────────────────────────────────────────────────
if __name__ == "__main__":
    import sys
    if len(sys.argv) < 2:
        print("Usage: python data.py <path-to-Brain_Stroke_CT_Dataset>")
        sys.exit(1)

    df = build_dataframe(sys.argv[1])
    df_train, df_val = split_dataframe(df)
    pos_w = compute_pos_weight(df_train)
    print(f"\nReady. pos_weight={pos_w:.3f}")