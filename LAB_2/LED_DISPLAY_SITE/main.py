from flask import Flask, request, send_from_directory
import os
from werkzeug.utils import secure_filename
from create_led_video import create_led_video  # Importing the create_led_video function
import tempfile
app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = tempfile.gettempdir()
app.config['ALLOWED_EXTENSIONS'] = {'txt'}
PORT = os.environ.get("PORT", 8080)

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in app.config['ALLOWED_EXTENSIONS']

@app.route('/', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        # Check if the post request has the file part
        if 'file' not in request.files:
            return 'No file part', 400
        file = request.files['file']
        # If user does not select file, browser also
        # submits an empty part without filename
        if file.filename == '':
            return 'No selected file', 400 # Bad request
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            file.save(file_path)

            # Generate video
            video_filename = filename.split('.')[0] + '.avi'
            video_path = os.path.join(app.config['UPLOAD_FOLDER'], video_filename)
            create_led_video(file_path, video_path)

            return send_from_directory(app.config['UPLOAD_FOLDER'], video_filename, as_attachment=True) # Send the video file as an attachment

    return '''
    <!doctype html>
    <title>Upload LED Text File</title>
    <h1>Upload LED Text File</h1>
    <form method=post enctype=multipart/form-data>
      <input type=file name=file>
      <input type=submit value=Upload>
    </form>
    '''

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))