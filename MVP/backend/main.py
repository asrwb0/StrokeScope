# general modules
import os
import glob
import numpy as np
import pandas as pd
import pydicom
import cv2
from PIL import Image

# ML modules
from sklearn.model_selection import train_test_split
from sklearn.metrics import roc_auc_score, accuracy_score, confusion_matrix
import tensorflow as tf
from tensorflow.keras.models import Model #type: ignore
from tensorflow.keras.layers import Dense, Dropout, GlobalAveragePooling2D #type: ignore
from tensorflow.keras.applications import ResNet50 #type: ignore
from tensorflow.keras.optimizers import Adam #type: ignore
from tensorflow.keras.losses import BinaryCrossentropy #type: ignore
from tensorflow.keras.metrics import AUC #type: ignore
from tensorflow.keras.applications.resnet50 import preprocess_input #type: ignore

# path to images folder for batching --> on Mac
backend_folder = os.getcwd()
images_folder = os.path.join(backend_folder + "/images/")

# defining image constants
IMAGES_PER_BATCH = 8
IMAGE_SIZE = 224
NUM_CLASSES = 6

# hyperparameters
HYPERPARAMS = {
    # add more hyperparameters later
    "epochs": 10,
    "learning_rate": 1e-4,
    "dropout_rate": 0.5,
    "num_classes": 6,
    "shuffle_buffer": 1000
}

# path to labeled csv files in the dataset --> on STEM remote desktop 
rsna_folder = "C:/Users/aseetharaman/Documents/rsna-intracranial-hemorrhage-detection/"
csv_labels_path = rsna_folder + "stage_1_train.csv"
training_images_path = rsna_folder + "stage_1_train_images/"
test_images_path = rsna_folder + "stage_1_test_images/"

# load labels from .csv files
df = pd.read_csv(csv_labels_path)
image_ids = []
types = []

# split the csv labels by RSNA naming convention (ID_type)
for index, row in df.iterrows():
    full_id = row['Id']
    parts = full_id.split('_')
    image_id = parts[0]
    type_name = "_".join(parts[1:])
    image_ids.append(image_id)
    types.append(type_name)

df['ImageId'] = image_ids
df['Type'] = types

# create a dictionary to map image IDs to the hemorrhage labels
data_map = {}

for index, row in df.iterrows():
    image_id = row['ImageId']
    type_name = row['Type']
    label = row['Label']

    if image_id not in data_map:
        data_map[image_id] = {}
    
    data_map[image_id][type_name] = label

# to use with TensorFlow, convert the dictionary to a dataframe
df_full = pd.DataFrame()

for image_id, labels_dict in data_map.items():
    row = {'ImageId': image_id}
    for key, value in labels_dict.items():
        row[key] = value

    df_full = df_full.append(row, ignore_index = True)

# ---------------------------
# 4. CT WINDOWING FUNCTION
# ---------------------------
# Function that:
# - Takes DICOM pixel array
# - Applies CT windowing
#
# Windows to implement:
# - Brain window
# - Subdural window
# - Bone window
#
# Then stack them into 3 channels:
#   R = brain
#   G = subdural
#   B = bone
#
# Resize to model input size
# Normalize pixel values


# ---------------------------
# 5. DICOM LOADER FUNCTION
# ---------------------------
# Function that:
# - Reads a DICOM file
# - Extracts pixel array
# - Calls windowing function
# - Returns processed image


# ---------------------------
# 6. BATCH GENERATOR
# ---------------------------
# Generator function that:
# - Loops through DICOM folder
# - Loads images in batches
# - Looks up labels using label dictionary
# - Returns:
#       batch_images, batch_labels
#
# This is required because dataset is too big to load all at once.


# ---------------------------
# 7. BUILD MODEL (TRANSFER LEARNING)
# ---------------------------
# Steps:
# - Load pretrained ResNet50 WITHOUT top layer
# - Freeze base model layers (at first)
# - Add new layers:
#     GlobalAveragePooling
#     Dense
#     Dropout
#     Dense (6 outputs)
#     Sigmoid activation
#
# Output = 6 probabilities (one for each hemorrhage type)


# ---------------------------
# 8. COMPILE MODEL
# ---------------------------
# Use:
# - Optimizer: Adam
# - Loss: Binary Cross Entropy
# - Metrics: Accuracy and AUC


# ---------------------------
# 9. TRAIN MODEL
# ---------------------------
# Use:
# - model.fit()
# - training generator
# - validation generator
# - multiple epochs
#
# Save best model to file.


# ---------------------------
# 10. EVALUATE MODEL
# ---------------------------
# Calculate:
# - AUC
# - Accuracy
# - Recall (very important for medical)
# - Confusion matrix


# ---------------------------
# 11. PREDICT ON NEW DICOM SCANS
# ---------------------------
# Load saved model
# Load new DICOM
# Preprocess using same windowing
# Predict
# Output probabilities for:
#   any
#   epidural
#   intraparenchymal
#   intraventricular
#   subarachnoid
#   subdural


# ---------------------------
# 12. MAIN FUNCTION
# ---------------------------
# This should:
# - Load labels
# - Create generators
# - Build model
# - Train model
# - Evaluate model
# - Run predictions


# ---------------------------
# END OF FILE
# ---------------------------