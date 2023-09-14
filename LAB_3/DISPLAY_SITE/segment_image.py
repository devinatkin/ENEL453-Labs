import cv2
import numpy as np
import matplotlib.pyplot as plt
import tempfile
import os
import uuid

def recolor_segments(image, contours, colors):
    colored_image = image.copy()
    for cnt, color in zip(contours, colors):
        if color == 'green':
            cv2.drawContours(colored_image, [cnt], 0, (0, 255, 0), -1)
        elif color == 'white':
            cv2.drawContours(colored_image, [cnt], 0, (255, 255, 255), -1)
    return colored_image

def find_contours(image):
    gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    _, thresholded = cv2.threshold(gray_image, 200, 255, cv2.THRESH_BINARY_INV)
    contours, _ = cv2.findContours(thresholded, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    filtered_contours = [cnt for cnt in contours if 500 < cv2.contourArea(cnt) < 5000]
    filtered_contours.sort(key=lambda cnt: cv2.boundingRect(cnt)[0] + cv2.boundingRect(cnt)[1]*image.shape[1])
    return filtered_contours

def generate_and_save_image(bits, image):
    if len(bits) != 7:
        raise ValueError("The bits input must be a list of 7 integers (0 or 1).")
    
    contours = find_contours(image)
    
    corrected_bits = [bits[i] for i in [0, 1, 5, 6, 4, 2, 3]]
    color_mapping = {0: 'white', 1: 'green'}
    segment_colors = [color_mapping[bit] for bit in corrected_bits]
    
    generated_image = recolor_segments(image, contours, segment_colors)
    
    temp_dir = tempfile.gettempdir()
    unique_filename = str(uuid.uuid4()) + "_seven_segment.png"
    temp_file_path = os.path.join(temp_dir, unique_filename)
    
    cv2.imwrite(temp_file_path, generated_image)
    
    return generated_image, temp_file_path

if __name__ == '__main__':
    # Initialize your image here (you may use the existing code)
    image_path = "SevenSegment.png"
    image_np = cv2.imread(image_path)

    # Example usage with bits corresponding to the number 1
    bits = [0, 1, 1, 0, 0, 0, 0]
    generated_image, temp_file_path = generate_and_save_image(bits, image_np)

    # Display the image (Optional)
    plt.imshow(cv2.cvtColor(generated_image, cv2.COLOR_BGR2RGB))
    plt.axis('off')
    plt.show()

    # Print the temporary file path
    print(f"Temporary file saved at: {temp_file_path}")
