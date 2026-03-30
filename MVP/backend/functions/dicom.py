# type: ignore
import numpy as np
import pydicom
from functions.windowing import build_channel
from tensorflow.keras.applications.resnet50 import preprocess_input

# define a custom Exception class to use during data parsing
class DicomLoadError(Exception):
    pass

def convert_hu(ds):
    extracted_array = ds.pixel_array.astype(np.float32)

    # use DICOM metadata to convert pixels to Hounsfield units
    slope = float(getattr(ds, "RescaleSlope", 1))
    intercept = float(getattr(ds, "RescaleIntercept", 0))
    
    return extracted_array * slope + intercept

def load_dicom(path):
    try:
        ds = pydicom.dcmread(path)
        ds_hu = convert_hu(ds)
        ds_channel = build_channel(ds_hu)
        return ds_channel
    except DicomLoadError:
        raise
    except Exception:
        raise DicomLoadError(f"Cannot read DICOM file: {path}")
    
def preprocess(image):
    image_f32 = image.astype(np.float32)
    image_f32 = np.expand_dims(image_f32, axis = 0)
    image_f32 = preprocess_input(image_f32)
    return image_f32