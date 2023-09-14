from digit_image import generate_and_combine_images
import cv2
import matplotlib.pyplot as plt
import numpy as np
import tempfile
import os
import uuid

seven_segment_encoding = {
    0: [1, 1, 1, 1, 1, 1, 0],
    1: [0, 1, 1, 0, 0, 0, 0],
    2: [1, 1, 0, 1, 1, 0, 1],
    3: [1, 1, 1, 1, 0, 0, 1],
    4: [0, 1, 1, 0, 0, 1, 1],
    5: [1, 0, 1, 1, 0, 1, 1],
    6: [1, 0, 1, 1, 1, 1, 1],
    7: [1, 1, 1, 0, 0, 0, 0],
    8: [1, 1, 1, 1, 1, 1, 1],
    9: [1, 1, 1, 1, 0, 1, 1]
}

# Function to convert a 4-digit number to its corresponding 7-bit encodings
def number_to_7bit_encoding(number):
    str_num = str(number).zfill(4)  # Zero-fill to make it a 4-digit number
    return [seven_segment_encoding[int(digit)] for digit in str_num]

# Function to create a video from the images
def create_video(images, output_path, frame_size, fps=30):
    fourcc = cv2.VideoWriter_fourcc(*'mp4v')
    out = cv2.VideoWriter(output_path, fourcc, fps, frame_size)
    for image in images:
        out.write(image)
    out.release()

if __name__ == '__main__':
    # Initialize some parameters
    image_path = "SevenSegment.png"
    base_image = cv2.imread(image_path)
    frame_size = (base_image.shape[1]*4, base_image.shape[0])
    fps = 30

    # Create a list to hold the generated images
    images = []

    # Generate images for numbers from 0000 to 9999
    for number in range(10000):
        print(f"Generating image for number {number}")
        bits_list = number_to_7bit_encoding(number)
        combined_image = generate_and_combine_images(bits_list, base_image)
        images.append(combined_image)

    # Create the video
    video_path = "combined_video.mp4"
    create_video(images, video_path, frame_size, fps)
    print(f"Video saved at {video_path}")
