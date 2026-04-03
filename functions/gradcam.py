# type: ignore
from termios import PARODD
import tensorflow as tf

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
    tf.reduce_mean(gradients, axis = (0, 1, 2))