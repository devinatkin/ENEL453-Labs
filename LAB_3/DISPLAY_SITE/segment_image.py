
import cv2
import numpy as np
import matplotlib.pyplot as plt

def recolor_segments(image, contours, colors):
    colored_image = image.copy()
    for cnt, color in zip(contours, colors):
        if color == 'green':
            cv2.drawContours(colored_image, [cnt], 0, (0, 255, 0), -1)
        elif color == 'white':
            cv2.drawContours(colored_image, [cnt], 0, (255, 255, 255), -1)
    return colored_image

def generate_seven_segment_image_final(image, contours, bits):
    if len(bits) != 7:
        raise ValueError("The bits input must be a list of 7 integers (0 or 1).")
    print("Bits: ", bits)
    corrected_bits = [bits[i] for i in [0,1,5,6,4,2,3]]
    print("Corrected bits: ", corrected_bits)
    color_mapping = {0: 'white', 1: 'green'}
    segment_colors = [color_mapping[bit] for bit in corrected_bits]
    generated_image = recolor_segments(image, contours, segment_colors)
    return generated_image

# Standard 7-segment encoding for numbers 0-9
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

# Example usage
# Load your image here
image_path = "SevenSegment.png"
image_np = cv2.imread(image_path)

# Your contours should be determined here based on the image
# Convert the image to grayscale
gray_image = cv2.cvtColor(image_np, cv2.COLOR_BGR2GRAY)

# Threshold the image
_, thresholded = cv2.threshold(gray_image, 200, 255, cv2.THRESH_BINARY_INV)

# Find contours
contours, _ = cv2.findContours(thresholded, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

# Filter contours based on area to isolate the seven segments
filtered_contours = [cnt for cnt in contours if 500 < cv2.contourArea(cnt) < 5000]  # Adjust these values as needed

# Sort the contours from left-to-right, top-to-bottom
filtered_contours.sort(key=lambda cnt: cv2.boundingRect(cnt)[0] + cv2.boundingRect(cnt)[1]*image_np.shape[1])

contours = filtered_contours

# Generate and display images for numbers 0-9
fig, axes = plt.subplots(1, 10, figsize=(20, 2))
for num, ax in zip(range(10), axes):
    encoded_bits = seven_segment_encoding[num]
    generated_image = generate_seven_segment_image_final(image_np, contours, encoded_bits)
    ax.imshow(cv2.cvtColor(generated_image, cv2.COLOR_BGR2RGB))
    ax.set_title(f"Number {num}")
    ax.axis('off')

plt.show()
