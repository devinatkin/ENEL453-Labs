from segment_image import generate_and_save_image
import cv2
import matplotlib.pyplot as plt
import numpy as np
import tempfile
import os
import uuid
def generate_and_combine_images(bits_list, image):
    if len(bits_list) != 4:
        raise ValueError("Expected a list of 4 7-bit sequences.")

    for bits in bits_list:
        if len(bits) != 7:
            raise ValueError("Each 7-bit sequence must contain exactly 7 integers (0 or 1).")

    individual_images = []
    for bits in bits_list:
        generated_image, _ = generate_and_save_image(bits, image)
        individual_images.append(generated_image)
        
    # Combine the individual images horizontally
    combined_image = cv2.hconcat(individual_images)

    # Save the combined image to a temporary file
    temp_dir = tempfile.gettempdir()
    unique_filename = str(uuid.uuid4()) + "_combined_seven_segment.png"
    temp_file_path = os.path.join(temp_dir, unique_filename)

    cv2.imwrite(temp_file_path, combined_image)
    
    return combined_image, temp_file_path

if __name__ == '__main__':
    # Your main code
    image_path = "SevenSegment.png"
    image_np = cv2.imread(image_path)
    
    # For demonstration, let's assume the bits for the numbers 1, 2, 3, and 4
    bits_for_1 = [0, 1, 1, 0, 0, 0, 0]
    bits_for_2 = [1, 1, 0, 1, 1, 0, 1]
    bits_for_3 = [1, 1, 1, 1, 0, 0, 1]
    bits_for_4 = [0, 1, 1, 0, 0, 1, 1]

    # Generate the combined image
    combined_image, temp_file_path = generate_and_combine_images([bits_for_1, bits_for_2, bits_for_3, bits_for_4], image_np)

    # Display the combined image (Optional)
    plt.imshow(cv2.cvtColor(combined_image, cv2.COLOR_BGR2RGB))
    plt.axis('off')
    plt.show()

    # Print the temporary file path
    print(f"Temporary file saved at: {temp_file_path}")
