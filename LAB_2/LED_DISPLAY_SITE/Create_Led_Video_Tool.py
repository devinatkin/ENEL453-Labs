import cv2
import numpy as np

def create_led_video(file_path, video_path, height=32, width=512, frame_rate=30):
    """
    Create an LED video based on a given text file containing timestamps and LED states.

    Parameters:
        file_path (str): Path to the text file containing timestamps and LED states.
        video_path (str): Path to the output video file.
        height (int): The height of the video frame.
        width (int): The width of the video frame.
        frame_rate (int): The frame rate of the video.
    """
    # Read the text file
    lines = open(file_path).read().strip().split("\n")

    # Extract the first and last timestamps to calculate the video duration
    first_timestamp = float(lines[0].split()[0])
    last_timestamp = float(lines[-1].split()[0])
    video_duration = (last_timestamp - first_timestamp) / 1000  # Duration in seconds

    # Video properties
    num_frames = int(video_duration * frame_rate)

    # Create a VideoWriter object
    fourcc = cv2.VideoWriter_fourcc(*'XVID')
    out = cv2.VideoWriter(video_path, fourcc, frame_rate, (width, height))

    # Function to calculate color based on average bit value
    def calculate_color(value):
        return (0, value * 255, 0)  # (B, G, R) format

    # Process the lines to create frames
    line_index = 0
    for frame_num in range(num_frames):
        frame_start_time = first_timestamp + (frame_num / frame_rate) * 1000
        frame_end_time = first_timestamp + ((frame_num + 1) / frame_rate) * 1000

        frame_values = [0] * 16
        total_time = 0

        # Read lines and integrate pixel value over the frame
        while line_index < len(lines):
            timestamp, bits = lines[line_index].split()
            timestamp = float(timestamp)

            if timestamp >= frame_end_time:
                break

            next_timestamp = float(lines[line_index + 1].split()[0]) if line_index + 1 < len(lines) else frame_end_time
            duration = next_timestamp - max(timestamp, frame_start_time)
            total_time += duration

            for i, bit in enumerate(bits):
                frame_values[i] += int(bit) * duration

            if timestamp < frame_start_time:
                line_index -= 1

            line_index += 1

        # Normalize and create the frame
        frame = np.zeros((height, width, 3), dtype=np.uint8)
        for i, value in enumerate(frame_values):
            value = value / total_time if total_time > 0 else 0
            color = calculate_color(value)
            start_x = i * 32
            end_x = start_x + 32
            frame[:, start_x:end_x] = color
        print(f"Frame {frame_num + 1} / {num_frames}")
        out.write(frame)

    out.release()
    print(f"Video created successfully: {video_path}")

# Check if the script is called directly
if __name__ == "__main__":
    file_path = "leds.txt"
    video_path = "led_video.avi"
    create_led_video(file_path, video_path)
