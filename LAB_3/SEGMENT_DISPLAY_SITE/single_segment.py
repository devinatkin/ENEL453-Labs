
import cv2
import numpy as np
import matplotlib.pyplot as plt

def sort_contours_x(contours):
    centroids = [np.mean(contour.reshape(-1, 2), axis=0) for contour in contours]
    sorted_indices = np.argsort([centroid[0] for centroid in centroids])
    return [contours[i] for i in sorted_indices]

def sort_contours_y(contours):
    centroids = [np.mean(contour.reshape(-1, 2), axis=0) for contour in contours]
    sorted_indices = np.argsort([centroid[1] for centroid in centroids])
    return [contours[i] for i in sorted_indices]

def display_seven_segment(input_bits, image, sorted_contours):
    modified_image = image.copy()
    for i, bit in enumerate(input_bits):
        if bit == 1:
            cv2.drawContours(modified_image, [sorted_contours[i]], 0, (0, 255, 0), -1)
    return modified_image

if __name__ == "__main__":
    image_path = 'SevenSegment.png'
    image = cv2.imread(image_path, cv2.IMREAD_COLOR)
    image_rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    
    image_gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    _, thresh = cv2.threshold(image_gray, 1, 255, cv2.THRESH_BINARY_INV)
    contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    
    filtered_contours = [contour for contour in contours if cv2.contourArea(contour) > 0]
    sorted_contours_y = sort_contours_y(filtered_contours)
    top_contours = sorted_contours_y[:3]
    bottom_contours = sorted_contours_y[3:]
    sorted_top_contours = sort_contours_x(top_contours)
    sorted_bottom_contours = sort_contours_x(bottom_contours)
    final_sorted_contours = sorted_top_contours + sorted_bottom_contours
    
    sample_input = [1, 1, 1, 1, 1, 1, 0]
    image_sample_output = display_seven_segment(sample_input, image_rgb, final_sorted_contours)
    
    plt.figure(figsize=(6, 6))
    plt.imshow(image_sample_output)
    plt.title('Sample Output for 7-bit input [1, 1, 1, 1, 1, 1, 0]')
    plt.axis('off')
    plt.savefig('SevenSegment_Output.png')