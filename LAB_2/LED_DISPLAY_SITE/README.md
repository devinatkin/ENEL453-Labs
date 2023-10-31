LED Video Generator
Overview
This project provides a web-based interface for generating AVI videos based on LED status data from text files. Built using Flask for the backend and OpenCV for video generation, the application allows users to upload a text file containing LED statuses with timestamps and then receive a generated AVI video file.

Requirements
Python 3.x
Flask
OpenCV
Installation
Clone the repository to your local machine.

bash
Copy code
git clone 
Navigate into the project directory.

bash
Copy code
cd LED_Video_Generator
Install the required Python packages.

bash
Copy code
pip install -r requirements.txt
Usage
Run the Flask application.

bash
Copy code
python app.py
Open your web browser and navigate to http://127.0.0.1:5000/.

Upload a text file containing LED status data with timestamps through the web interface.

The application will generate an AVI video file based on the uploaded text file and make it available for download.

File Format
The input text file should contain lines in the following format:

css
Copy code
[timestamp] [LED statuses]
For example:

yaml
Copy code
0 10011001
1000 11001100
Contributing
Contributions are welcome. Please submit a pull request or open an issue to discuss any changes or improvements.

