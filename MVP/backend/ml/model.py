# type: ignore
import tensorflow as tf
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Dense, Dropout, GlobalAveragePooling2D
from tensorflow.keras.applications import ResNet50
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.losses import BinaryCrossentropy
from tensorflow.keras.metrics import AUC
from config import NUM_CLASSES, MODEL_WEIGHTS_PATH, HYPERPARAMS
import os

def build_model(dropout_rate):
    # use ResNet50 as the base model
    base = ResNet50(weights = 'imagenet', include_top = False, input_shape = (224, 224, 3))
    base.trainable = False
    x = GlobalAveragePooling2D()(base.output)
    x = Dense(256, activation = "relu")(x)
    x = Dropout(dropout_rate)(x)
    output = Dense(NUM_CLASSES, activation = "sigmoid")(x)
    # define a model object for each function call
    model = Model(inputs = base.input, outputs = output)
    _compile(model)
    return model

def _compile(model, learning_rate = HYPERPARAMS['learning_rate']):
    # define a model optimizer
    optimizer = Adam(learning_rate = learning_rate)
    loss = BinaryCrossentropy()
    metrics = ["accuracy", AUC(name = "auc", multi_label = True)]
    model.compile(optimizer = optimizer, loss = loss, metrics = metrics)

def unfreeze_base(model, learning_rate = 1e-5):
    # unfreeze the model so that fine-tuning later is possible
    model.layers[0].trainable = True
    _compile(model, learning_rate = learning_rate)

def load_model(weights_path = MODEL_WEIGHTS_PATH):
    if not os.path.exists(weights_path):
        raise FileNotFoundError(f"Model weights not found at '{weights_path}'.")
    # build a new model and load the weights into it
    model = build_model(dropout_rate = HYPERPARAMS['dropout_rate'])
    model.load_weights(weights_path)
    return model