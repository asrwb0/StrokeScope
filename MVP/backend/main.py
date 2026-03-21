# ============================================================
# app.py — Stroke Detection Web Application Backend
# ============================================================


# ------------------------------------------------------------
# 1. IMPORTS & CONFIGURATION
# ------------------------------------------------------------
# - Import Flask and necessary extensions (CORS, file handling)
# - Import image processing libraries (PIL, OpenCV, NumPy)
# - Import ML framework (PyTorch or TensorFlow)
# - Define allowed file extensions (jpg, png, dcm, tiff)
# - Set upload folder path and max file size limit
# - Set model weights file path
# - Set class labels: ["ischemic_stroke", "hemorrhagic_stroke", "no_stroke"]
# - Set target image dimensions to match model training input size
# - Configure logging


# ------------------------------------------------------------
# 2. MODEL DEFINITION
# ------------------------------------------------------------
# - Define the CNN architecture class
#   - Use a pretrained backbone (e.g. ResNet-50) for transfer learning
#   - Freeze early layers, unfreeze later layers for fine-tuning
#   - Replace final classification head with a 3-class output layer
#   - Add dropout layer for regularization
# - Define the forward pass method


# ------------------------------------------------------------
# 3. MODEL LOADING
# ------------------------------------------------------------
# - Detect available device (GPU vs CPU)
# - Instantiate the model class
# - Load saved weights from the model file path
# - Set the model to evaluation mode (disables dropout/batchnorm training behavior)
# - Store model and device as module-level globals so they load once at startup


# ------------------------------------------------------------
# 4. IMAGE PREPROCESSING
# ------------------------------------------------------------
# - Define a preprocessing pipeline/transform:
#   - Resize image to model's expected input dimensions
#   - Convert to tensor
#   - Normalize pixel values using ImageNet mean and std
# - Write a function that:
#   - Opens the image file using Pillow
#   - Converts to RGB (handles grayscale MRI/CT scans)
#   - Applies the preprocessing pipeline
#   - Adds a batch dimension
#   - Returns both the tensor (for inference) and raw numpy array (for Grad-CAM)


# ------------------------------------------------------------
# 5. STROKE CLASSIFICATION
# ------------------------------------------------------------
# - Write an inference function that:
#   - Accepts the preprocessed image tensor
#   - Runs a forward pass through the model with no gradient tracking
#   - Applies softmax to convert raw logits to probabilities
#   - Identifies the predicted class index and label
#   - Returns the predicted class label and confidence score (0.0 – 1.0)
#   - Flags result if confidence falls below a defined threshold


# ------------------------------------------------------------
# 6. GRAD-CAM (VISUAL EXPLAINABILITY)
# ------------------------------------------------------------
# - Register a forward hook on the last convolutional layer to capture activations
# - Register a backward hook on the same layer to capture gradients
# - Write a Grad-CAM function that:
#   - Runs a forward pass to get the predicted class score
#   - Runs a backward pass to compute gradients for that class
#   - Pools the gradients and weights the activation maps accordingly
#   - Applies ReLU to keep only positive activations
#   - Resizes the resulting heatmap to match the original image dimensions
#   - Normalizes heatmap values to the 0–255 range
#   - Overlays the heatmap onto the original scan image using a color map
#   - Saves the overlaid image to the heatmaps folder
#   - Returns the file path of the saved heatmap image


# ------------------------------------------------------------
# 7. HELPER UTILITIES
# ------------------------------------------------------------
# - Write a function to validate uploaded file extensions
# - Write a function to generate a unique filename (e.g. using UUID)
#   to avoid collisions between concurrent uploads
# - Write a function to clean up temporary uploaded files after processing


# ------------------------------------------------------------
# 8. API ROUTES
# ------------------------------------------------------------

# POST /api/analyze
# -----------------
# - Validate that a file was included in the request
# - Validate the file extension
# - Save the file to the upload folder with a unique filename
# - Call the preprocessing function on the saved file
# - Call the classification function to get label and confidence
# - Call the Grad-CAM function to generate the heatmap overlay
# - Clean up the uploaded file
# - Return JSON response containing:
#   - predicted_class (e.g. "ischemic_stroke")
#   - confidence (float between 0 and 1)
#   - low_confidence flag (bool)
#   - heatmap_url (path or URL to the heatmap image)
#   - recommended_next_steps (plain-language guidance string)
#   - disclaimer (reminder that this is not medical advice)

# GET /api/heatmap/<filename>
# ---------------------------
# - Serve the generated heatmap image file from the heatmaps folder
# - Return 404 if the file does not exist

# POST /api/feedback
# ------------------
# - Parse the JSON body for fields: ease_of_use (int), comments (str), timestamp
# - Validate that required fields are present
# - Save the feedback entry to a JSON file or database record
# - Return a confirmation response

# GET /api/health
# ---------------
# - Return a simple status response confirming the server is running
# - Useful for uptime monitoring and deployment checks


# ------------------------------------------------------------
# 9. APP ENTRY POINT
# ------------------------------------------------------------
# - Run the Flask development server when the script is executed directly
# - Set host to 0.0.0.0 to allow external connections (e.g. from the frontend)
# - Set debug=False for any production or demo deployment