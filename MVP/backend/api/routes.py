# type: ignore
from flask import Blueprint, request, jsonify, send_file
from predictor import predict, PredictionResult
from gradcam import generate_heatmap, HEATMAP_DIR
from dicom import load_dicom, preprocess, DicomLoadError, convert_hu
from model import load_model
from windowing import window
import os
import io
import tempfile
import numpy as np
import cv2
import tensorflow as tf

api = Blueprint("api", __name__, url_prefix = "/api")

# model singleton
_model = None

def get_model():
    global _model
    if _model is None:
        _model = load_model()
    return _model

@api.route("/health", methods = ["GET"])
def health():
    return jsonify({"status": "ok"})


@api.route("/model/status", methods = ["GET"])
def model_status():
    try:
        model = get_model()
        return jsonify({
            "status": "ready",
            "num_classes": model.output_shape[-1],
        })
    except FileNotFoundError as e:
        return jsonify({"status": "unavailable", "message": str(e)}), 503
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

@api.route("/predict", methods = ["POST"])
def predict_route():
    if "file" not in request.files:
        return jsonify({"error": "missing_file", "message": "No file supplied."}), 400

    file = request.files["file"]

    with tempfile.NamedTemporaryFile(suffix = ".dcm", delete = False) as tmp:
        tmp_path = tmp.name
        file.save(tmp_path)

    try:
        result = predict(tmp_path)
        return jsonify({
            "probabilities":  result.probabilities,
            "predictions":    result.predictions,
            "any_hemorrhage": result.any_hemorrhage,
            "low_confidence": result.low_confidence,
        })
    except DicomLoadError as e:
        return jsonify({"error": "invalid_dicom", "message": str(e)}), 400
    except Exception as e:
        return jsonify({"error": "server_error", "message": str(e)}), 500
    finally:
        os.unlink(tmp_path)


@api.route("/predict/batch", methods = ["POST"])
def predict_batch():
    files = request.files.getlist("files[]")
    if not files:
        return jsonify({"error": "missing_files", "message": "No files supplied."}), 400

    results = []
    tmp_paths = []

    try:
        for file in files:
            with tempfile.NamedTemporaryFile(suffix = ".dcm", delete = False) as tmp:
                tmp_path = tmp.name
                file.save(tmp_path)
                tmp_paths.append((file.filename, tmp_path))

        for filename, tmp_path in tmp_paths:
            try:
                result = predict(tmp_path)
                results.append({
                    "filename":       filename,
                    "probabilities":  result.probabilities,
                    "predictions":    result.predictions,
                    "any_hemorrhage": result.any_hemorrhage,
                    "low_confidence": result.low_confidence,
                })
            except DicomLoadError as e:
                results.append({
                    "filename": filename,
                    "error":    "invalid_dicom",
                    "message":  str(e),
                })

        return jsonify({"results": results})

    except Exception as e:
        return jsonify({"error": "server_error", "message": str(e)}), 500
    finally:
        for _, tmp_path in tmp_paths:
            if os.path.exists(tmp_path):
                os.unlink(tmp_path)

@api.route("/gradcam", methods = ["POST"])
def gradcam():
    if "file" not in request.files:
        return jsonify({"error": "missing_file", "message": "No file supplied."}), 400

    file = request.files["file"]

    label_index = request.form.get("label_index", None)
    if label_index is not None:
        try:
            label_index = int(label_index)
        except ValueError:
            return jsonify({"error": "invalid_label_index", "message": "label_index must be an integer."}), 400

    with tempfile.NamedTemporaryFile(suffix = ".dcm", delete = False) as tmp:
        tmp_path = tmp.name
        file.save(tmp_path)

    try:
        model = get_model()
        original_image = load_dicom(tmp_path)
        preprocessed = preprocess(original_image)
        preprocessed_tensor = tf.constant(preprocessed, dtype = tf.float32)

        heatmap_path = generate_heatmap(model, preprocessed_tensor, original_image, label_index)
        return send_file(heatmap_path, mimetype = "image/jpeg", as_attachment = False)

    except DicomLoadError as e:
        return jsonify({"error": "invalid_dicom", "message": str(e)}), 400
    except Exception as e:
        return jsonify({"error": "server_error", "message": str(e)}), 500
    finally:
        os.unlink(tmp_path)


@api.route("/gradcam/save", methods = ["POST"])
def gradcam_save():
    body = request.get_json(silent = True) or {}

    file_path = body.get("file_path")
    if not file_path:
        return jsonify({"error": "missing_param", "message": "'file_path' is required."}), 400
    if not os.path.exists(file_path):
        return jsonify({"error": "not_found", "message": f"File not found: {file_path}"}), 404

    label_index = body.get("label_index", None)
    if label_index is not None and not isinstance(label_index, int):
        return jsonify({"error": "invalid_label_index", "message": "label_index must be an integer."}), 400

    try:
        model = get_model()
        original_image = load_dicom(file_path)
        preprocessed = preprocess(original_image)
        preprocessed_tensor = tf.constant(preprocessed, dtype = tf.float32)

        heatmap_path = generate_heatmap(model, preprocessed_tensor, original_image, label_index)
        return jsonify({"heatmap_path": heatmap_path})

    except DicomLoadError as e:
        return jsonify({"error": "invalid_dicom", "message": str(e)}), 400
    except Exception as e:
        return jsonify({"error": "server_error", "message": str(e)}), 500

@api.route("/preprocess/preview", methods = ["POST"])
def preprocess_preview():
    if "file" not in request.files:
        return jsonify({"error": "missing_file", "message": "No file supplied."}), 400

    file = request.files["file"]

    with tempfile.NamedTemporaryFile(suffix = ".dcm", delete = False) as tmp:
        tmp_path = tmp.name
        file.save(tmp_path)

    try:
        import pydicom
        from config import WINDOW_BRAIN, WINDOW_SUBDURAL, WINDOW_BONE

        ds = pydicom.dcmread(tmp_path)
        hu = convert_hu(ds)

        brain    = window(hu, *WINDOW_BRAIN)
        subdural = window(hu, *WINDOW_SUBDURAL)
        bone     = window(hu, *WINDOW_BONE)

        def to_display(arr):
            img = (arr * 255).astype(np.uint8)
            return cv2.resize(img, (224, 224), interpolation = cv2.INTER_AREA)

        def label(img, text):
            colored = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR)
            cv2.putText(colored, text, (8, 20), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 1, cv2.LINE_AA)
            return colored

        composite = np.hstack([
            label(to_display(brain),    "Brain"),
            label(to_display(subdural), "Subdural"),
            label(to_display(bone),     "Bone"),
        ])

        _, buf = cv2.imencode(".png", composite)
        return send_file(io.BytesIO(buf.tobytes()), mimetype = "image/png")

    except DicomLoadError as e:
        return jsonify({"error": "invalid_dicom", "message": str(e)}), 400
    except Exception as e:
        return jsonify({"error": "server_error", "message": str(e)}), 500
    finally:
        os.unlink(tmp_path)

@api.errorhandler(DicomLoadError)
def handle_dicom_error(e):
    return jsonify({"error": "invalid_dicom", "message": str(e)}), 400


@api.errorhandler(404)
def handle_not_found(e):
    return jsonify({"error": "not_found", "message": str(e)}), 404


@api.errorhandler(500)
def handle_server_error(e):
    return jsonify({"error": "server_error", "message": "An unexpected error occurred."}), 500