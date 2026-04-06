# type: ignore
from termios import PARODD
import tensorflow as tf
import numpy as np
import cv2
import uuid
import os

GRADCAM_LAYER = "conv5_block3_out"

# get the most spatial layer of the CNN for feature extraction
def _get_gradcam(model):
    gradcam_layer = model.get_layer(GRADCAM_LAYER)
    return tf.keras.Model(inputs = model.input, outputs = [gradcam_layer.output, model.output])

def generate_heatmap(model, preprocessed_tensor, original_image, label_index):
    gradcam_model = _get_gradcam(model)
    
    # GradientTape identifies model results
    with tf.GradientTape() as tape:
        tape.watch(preprocessed_tensor)
        conv_outputs, predictions = gradcam_model(preprocessed_tensor)
        
        # if no index label exists, just use the largest probability prediction
        if label_index is None:
            label_index = int(tf.argmax(predictions[0]))
        
        # the full column of predictions is the score
        score = predictions[:, label_index]

    gradients = tape.gradient(score, conv_outputs)

    # pool all the gradients together
    pooled_gradients = tf.reduce_mean(gradients, axis = (0, 1, 2))

    # build the heatmap
    conv_outputs = conv_outputs[0]
    heatmap = conv_outputs @ pooled_gradients[..., tf.newaxis]
    heatmap = tf.squeeze(heatmap)

    # cleaning the values
    heatmap = tf.nn.relu(heatmap)
    heatmap = heatmap.numpy()
    heatmap = (heatmap - heatmap.min()) / (heatmap.max() - heatmap.min() + 1e-8)

    # convert the heatmap to a colored image
    heatmap = cv2.resize(heatmap, (224, 224), interpolation = cv2.INTER_LINEAR)
    heatmap_colored = cv2.applyColorMap(np.uint8(255 * heatmap), cv2.COLORMAP_JET)

    # bleng the created colored image with the original
    original_image = cv2.resize(original_image, (224, 224))
    blended = cv2.addWeighted(heatmap_colored, 0.4, original_image, 0.6, 0)

    # save the predicted class label with the image and saves it to disks
    cv2.putText(blended, f"Class: {label_index}", (10, 25), cv2.FONT_HERSHEY_SIMPLEX, 0.8, (255, 255, 255), 2, cv2.LINE_AA)
    os.makedirs(HEATMAP_DIR, exist_ok = True)
    path = os.path.join(HEATMAP_DIR, f"{uuid.uuid4()}.jpg")
    cv2.imwrite(path, blended)
    return path