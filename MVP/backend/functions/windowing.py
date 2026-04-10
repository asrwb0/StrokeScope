# type: ignore
import numpy as np
import cv2
from config import IMAGE_SIZE, WINDOW_BRAIN, WINDOW_SUBDURAL, WINDOW_BONE

def window(pixel_array, center, width):
    min_width = center - width / 2
    max_width = center + width / 2
    clipped = np.clip(pixel_array, min_width, max_width)
    
    # normalize the data between 0 and 1
    normalized_array = ((clipped - min_width) / (max_width - min_width))
    normalized = normalized_array.astype(np.float32) # float32 is usable by other functions

    return normalized

def build_channel(pixel_array):
    # collects tissue slices by part
    brain = window(pixel_array, *WINDOW_BRAIN)
    subdural = window(pixel_array, *WINDOW_SUBDURAL)
    bone = window(pixel_array, *WINDOW_BONE)

    # build a 3D array of all of the individual tissue slices
    initial_stack = np.stack([brain, subdural, bone], axis = -1)
    integer_stack = initial_stack.astype(np.uint8)

    # returns the array in a usable format for other functions
    resized_integer_stack = cv2.resize(integer_stack, (IMAGE_SIZE, IMAGE_SIZE), interpolation = cv2.INTER_AREA)
    return resized_integer_stack