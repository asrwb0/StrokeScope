# these functions are not written yet
# type: ignore
from functions.dicom import load_dicom, preprocess
from config import TRAINING_IMAGES_PATH, LABEL_COLS
import numpy as np, os

def generate(df, images_folder, IMAGES_PER_BATCH):
    # loop through DataFrame indefinitely for epoch training
    while True:
        df_copy = df.copy()
        for start in range(0, len(df_copy), IMAGES_PER_BATCH):
            current_batch = df_copy.iloc[start:start + IMAGES_PER_BATCH]
            batch_images = []
            batch_labels = []

        # get each DICOM from each batch
        for _, row in current_batch.iterrows():
            try:
                current_image = load_dicom(os.path.join(TRAINING_IMAGES_PATH, str(row['ImageId']) + ".dcm"))
                processed_image = preprocess(current_image)
                labels = row[LABEL_COLS].values.astype(np.float32)
                batch_images.append(processed_image)
                batch_labels.append(labels)

            # if any image throws an error, just log it and move on
            except Exception as e:
                print(e)
                continue
        
        # yield the images and labels of the current batch
        yield np.stack(batch_images), np.stack(batch_labels)