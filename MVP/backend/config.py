import os

backend_folder = os.getcwd()
images_folder = os.path.join(backend_folder + "/images/")

IMAGES_PER_BATCH = 8
IMAGE_SIZE = 224
NUM_CLASSES = 6

HYPERPARAMS = {
    "epochs": 10,
    "learning_rate": 1e-4,
    "dropout_rate": 0.5,
    "num_classes": 6,
    "shuffle_buffer": 1000
}

rsna_folder = "C:/Users/aseetharaman/Documents/rsna-intracranial-hemorrhage-detection/"
csv_labels_path = rsna_folder + "stage_1_train.csv"
training_images_path = rsna_folder + "stage_1_train_images/"
test_images_path = rsna_folder + "stage_1_test_images/"