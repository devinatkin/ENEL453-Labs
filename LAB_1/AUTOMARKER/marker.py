import zipfile
import os
from datetime import datetime
from collections import defaultdict
import csv
import hashlib

def hash_file(file_path):
    """
    Generate a SHA-256 hash for a given file.
    :param file_path: Path to the file
    :return: SHA-256 Hash
    """
    sha256_hash = hashlib.sha256()
    with open(file_path, "rb") as f:
        while chunk := f.read(4096):
            sha256_hash.update(chunk)
    return sha256_hash.hexdigest()

def check_for_identical_files(complete_file_list):
    """
    Check for identical files in the complete_file_list.
    :param complete_file_list: List of file paths
    :return: None (prints warnings)
    """
    unique_file_list = list(set(complete_file_list))  # Remove duplicate paths
    
    file_hash_dict = {}
    for file_path in unique_file_list:
        file_hash = hash_file(file_path)
        if file_hash in file_hash_dict:
            file_hash_dict[file_hash].append(file_path)
        else:
            file_hash_dict[file_hash] = [file_path]
    
    # Raise warnings for identical files
    for file_hash, file_paths in file_hash_dict.items():
        if len(file_paths) > 1:
            print(f"Warning: Identical files detected: {file_paths}")
            append_row_to_csv(marking_csv, "Warning", "Identical files detected", file_paths, 0, 0, 0, 0, 0, 0, 0)

def append_row_to_csv(file_path, first_name, last_name, crc_calc, crc_statemachine, tb_crc_calc, tb_crc_statemachine, tb_top_level, top_level, report, score):
    """
    Appends a row to a CSV file with the following fields:
    - first_name
    - last_name
    - crc_calc
    - crc_statemachine
    - tb_crc_calc
    - tb_crc_statemachine
    - tb_top_level
    - top_level
    - score

    Parameters:
    file_path (str): Path to the CSV file.
    first_name (str): First name of the individual.
    last_name (str): Last name of the individual.
    crc_calc (float/int): Value related to CRC calculation.
    crc_statemachine (float/int): Value related to the CRC state machine.
    tb_crc_calc (float/int): Testbench value for CRC calculation.
    tb_crc_statemachine (float/int): Testbench value for the CRC state machine.
    tb_top_level (float/int): Testbench value for the top-level design.
    top_level (float/int): Value related to the top-level design.
    score (float/int): Overall score.
    """

    # Check if the file already exists to write the headers accordingly
    try:
        with open(file_path, 'r') as csvfile:
            pass
    except FileNotFoundError:
        # File does not exist, write headers
        with open(file_path, 'w', newline='') as csvfile:
            csvwriter = csv.writer(csvfile)
            csvwriter.writerow(['first_name', 'last_name', 'crc_calc', 'crc_statemachine', 'tb_crc_calc', 'tb_crc_statemachine', 'tb_top_level', 'top_level', 'report', 'score'])
    
    # Append the new row
    with open(file_path, 'a', newline='') as csvfile:
        csvwriter = csv.writer(csvfile)
        csvwriter.writerow([first_name, last_name, crc_calc, crc_statemachine, tb_crc_calc, tb_crc_statemachine, tb_top_level, top_level, report, score])

def clear_csv(file_path):
    """
    Clears the contents of a CSV file, leaving only the header row intact.

    Parameters:
    file_path (str): Path to the CSV file.
    """
    with open(file_path, 'w', newline='') as csvfile:
        csvwriter = csv.writer(csvfile)
        csvwriter.writerow(['first_name', 'last_name', 'crc_calc', 'crc_statemachine', 'tb_crc_calc', 'tb_crc_statemachine', 'tb_top_level', 'top_level', 'score'])

def extract_student_info(file_name: str):
    """
    This function takes a file name in the format "223523-219174 - firstname lastname - Sep 21, 2023 510 PM/ENEL 453 LAB 1.docx",
    and returns a dictionary containing the first name, last name.

    :param file_name: The name of the file.
    :return: A dictionary containing 'first_name', 'last_name'.
    """
    try:
        # Split by ' - '
        parts = file_name.split(' - ')
        if len(parts) < 3:
            return None
        
        # Extract the names and date string
        names = parts[1].split()
        if len(names) < 2:
            return None

        first_name = names[0]
        last_name = ' '.join(map(str, names[1:]))
        


        return {
            first_name,
            last_name
        }

    except Exception as e:
        print(f"An exception occurred: {e}")
        return None

def extract_and_list_files(zip_file_name: str, extract_to: str) -> list:
    """
    This function extracts files from a ZIP archive and returns the list of extracted file names.

    Parameters:
    - zip_file_name: str, the name of the ZIP file to extract
    - extract_to: str, the directory to which the files will be extracted
    
    Returns:
    - list: filenames that were extracted
    """
    # Initialize an empty list to hold the names of extracted files
    extracted_files = []
    
    # Open the ZIP file in read mode
    with zipfile.ZipFile(zip_file_name, 'r') as zip_ref:
        # Loop over each file in the ZIP archive
        for file_name in zip_ref.namelist():
            # Extract the file to the specified directory
            zip_ref.extract(file_name, extract_to)
            
            # Append the full path of the extracted file to the list
            extracted_files.append(os.path.join(extract_to, file_name))
    
    return extracted_files

def flatten_files(files):
    flattened_files = []
    for f in files:
        if os.path.isdir(f):
            # List all files in the directory and add them to flattened_files
            directory_files = [os.path.join(f, x) for x in os.listdir(f)]
            flattened_files.extend(flatten_files(directory_files))
        elif zipfile.is_zipfile(f):
            # Unzip the file and add its contents to flattened_files
            with zipfile.ZipFile(f, 'r') as zip_ref:
                # Create a temporary directory to unzip files
                temp_dir = os.path.join("temp", os.path.basename(f))
                os.makedirs(temp_dir, exist_ok=True)
                
                zip_ref.extractall(temp_dir)
                # Recursively flatten the contents of the ZIP file
                flattened_files.extend(flatten_files([os.path.join(temp_dir, x) for x in os.listdir(temp_dir)]))
        else:
            # If it's a regular file, add it to flattened_files
            flattened_files.append(f)
    return flattened_files
 
def check_crc_calc_file(files):
    for f in files:
        # Check if the file is a directory
        if os.path.isdir(f):
            # List all files in the directory and recursively check for crc_calc.sv
            directory_files = [os.path.join(f, x) for x in os.listdir(f)]
            exists, file_name = check_crc_calc_file(directory_files)

            if exists == 1:
                return exists, file_name
        else:
            # Check if the file is named crc_calc.sv
            if os.path.basename(f) == "crc_calc.sv":
                return 1, f
    return 0, "File not found"

def check_tb_crc_calc_file(files):
    for f in files:
        # Check if the file is a directory
        if os.path.isdir(f):
            # List all files in the directory and recursively check for crc_calc.sv
            directory_files = [os.path.join(f, x) for x in os.listdir(f)]
            exists, file_name = check_crc_calc_file(directory_files) 
            if exists == 1:
                return exists, file_name
        else:
            # Check if the file is named crc_calc.sv
            if os.path.basename(f) == "tb_crc_calc.sv":
                return 1,f
    return 0, "File not found"

def check_tb_crc_statemachine(files):
    for f in files:
        # Check if the file is a directory
        if os.path.isdir(f):
            # List all files in the directory and recursively check for crc_calc.sv
            directory_files = [os.path.join(f, x) for x in os.listdir(f)]
            exists, file_name = check_crc_calc_file(directory_files)
            if exists == 1:
                return exists, file_name
        else:
            # Check if the file is named crc_calc.sv
            if os.path.basename(f) == "tb_crc_statemachine.sv":
                return 1,f
    return 0, "File not found"

def check_crc_statemachine(files):
    for f in files:
        # Check if the file is a directory
        if os.path.isdir(f):
            # List all files in the directory and recursively check for crc_statemachine.sv
            directory_files = [os.path.join(f, x) for x in os.listdir(f)]
            exists, file_name = check_crc_calc_file(directory_files)
            if exists == 1:
                return exists, file_name
        else:
            # Check if the file is named crc_statemachine.sv
            if os.path.basename(f) == "crc_statemachine.sv":
                return 1,f
    return 0, "File not found"

def check_tb_top_level(files):
    for f in files:
        # Check if the file is a directory
        if os.path.isdir(f):
            # List all files in the directory and recursively check for crc_statemachine.sv
            directory_files = [os.path.join(f, x) for x in os.listdir(f)]
            exists, file_name = check_crc_calc_file(directory_files)
            if exists == 1:
                return exists, file_name
        else:
            # Check if the file is named crc_statemachine.sv
            if os.path.basename(f) == "tb_top_level.sv":
                return 1, f
    return 0, "File not found"

def check_top_level(files):
    for f in files:
        # Check if the file is a directory
        if os.path.isdir(f):
            # List all files in the directory and recursively check for crc_statemachine.sv
            directory_files = [os.path.join(f, x) for x in os.listdir(f)]
            exists, file_name = check_crc_calc_file(directory_files)
            if exists == 1:
                return exists, file_name
        else:
            # Check if the file is named crc_statemachine.sv
            if os.path.basename(f) == "tb_top_level.sv":
                return 1,f
    return 0, "File not found"

def check_for_doc_video_files(files):
    # Define standard extensions for documents and videos
    doc_extensions = ['.doc', '.docx', '.pdf', '.txt', '.odt', '.xls', '.xlsx']
    video_extensions = ['.mp4', '.avi', '.flv', '.mkv', '.mov']
    
    for f in files:
        # Check if the file is a directory
        if os.path.isdir(f):
            # List all files in the directory and recursively check for document and video files
            directory_files = [os.path.join(f, x) for x in os.listdir(f)]
            if check_for_doc_video_files(directory_files) == 1:
                return 1
        else:
            # Extract the file extension and check if it matches any of the standard extensions
            file_extension = os.path.splitext(f)[1]
            if file_extension.lower() in doc_extensions or file_extension.lower() in video_extensions:
                return 1
                
    return 0

lab_name = "C:\\Users\\devin\\Downloads\\Lab 1 Download Oct 16, 2023 733 AM.zip"
extract_files_to = "C:\\Users\\devin\\Downloads"
marking_csv = "marking.csv"
file_list = extract_and_list_files(lab_name, extract_files_to)
# Dictionary to hold students and their submitted files
students = defaultdict(list)

# Print out the list of folders
for file_name in file_list:
    info = extract_student_info(file_name)
    
    if info:
        first_name, last_name = info
        key = (first_name, last_name)

        # Append the file_name and submission_time as a tuple to the list associated with each student
        students[key].append((file_name))


clear_csv(marking_csv)

complete_file_list = []

# Output the results
for key in students.keys():
    first_name, last_name = key

    files = students[key]
    files = flatten_files(files)
    
    crc_calc, crc_calc_filename = check_crc_calc_file(files)

    crc_statemachine, crc_statemachine_filename = check_crc_statemachine(files)
    tb_crc_calc, tb_crc_calc_filename = check_tb_crc_calc_file(files)
    tb_crc_statemachine, tb_crc_statemachine_filename = check_tb_crc_statemachine(files)
    tb_top_level, tb_top_level_filename = check_tb_top_level(files)
    top_level, top_level_filename = check_top_level(files)
    report = check_for_doc_video_files(files)

    # If all the files are found, add them to the complete_file_list
    if crc_calc == 1 and crc_statemachine == 1 and tb_crc_calc == 1 and tb_crc_statemachine == 1 and tb_top_level == 1 and top_level == 1:
        complete_file_list.extend([crc_calc_filename, crc_statemachine_filename, tb_crc_calc_filename, tb_crc_statemachine_filename, tb_top_level_filename, top_level_filename])

    system_verilog_filenames = (crc_calc_filename, crc_statemachine_filename, tb_crc_calc_filename, tb_crc_statemachine_filename, tb_top_level_filename, top_level_filename)

    score = (crc_calc + crc_statemachine + tb_crc_calc + tb_crc_statemachine + tb_top_level + top_level + report) / 7.0
    append_row_to_csv(marking_csv, first_name, last_name, crc_calc, crc_statemachine, tb_crc_calc, tb_crc_statemachine, tb_top_level, top_level, report, score)

check_for_identical_files(complete_file_list)
