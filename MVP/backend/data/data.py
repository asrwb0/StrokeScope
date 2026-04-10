# type: ignore
import pandas as pd
from sklearn.model_selection import train_test_split
from config import CSV_LABELS_PATH, LABEL_COLS

# load labels from .csv files
df = pd.read_csv(CSV_LABELS_PATH)
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

# convert the dictionary to a dataframe for use with TensorFlow
rows = []
for image_id, labels_dict in data_map.items():
    row = {'ImageId': image_id}
    for key, value in labels_dict.items():
        row[key] = value
    rows.append(row)

df_full = pd.DataFrame(rows)[['ImageId'] + LABEL_COLS]

# split into training and test data
df_train, df_val = train_test_split(df_full, test_size = 0.2, random_state = 42, stratify = df_full['any'])