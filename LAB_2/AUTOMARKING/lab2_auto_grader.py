import os
import zipfile
import csv

def find_files_and_unpack_zip(directory_path):
    """
    This function takes a directory path as input and recursively searches for all files in the directory and its subdirectories.
    If it finds a zip file, it unpacks it in place.
    """
    for root, dirs, files in os.walk(directory_path):
        for file in files:
            file_path = os.path.join(root, file)
            if file_path.endswith('.zip'):
                with zipfile.ZipFile(file_path, 'r') as zip_ref:
                    zip_ref.extractall(root)

def list_files(directory_path):
    """
    This function takes a directory path as input and recursively searches for all files in the directory and its subdirectories.
    It returns a list of all files found.
    """
    files_list = []
    for root, dirs, files in os.walk(directory_path):
        for file in files:
            file_path = os.path.join(root, file)
            files_list.append(file_path)
    return files_list

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
        

        return first_name + " "+ last_name
        

    except Exception as e:
        print(f"An exception occurred: {e}")
        return None

    
def generate_csv(student_marks):
    """
    This function takes a dictionary of student names and their corresponding marks, and writes them to a CSV file with the specified fields.

    :param student_marks: A dictionary containing student names as keys and their corresponding marks as values.
    """
    with open('student_marks.csv', mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['First Name', 'Last Name', 'Mark'])
        for first_name,last_name, mark in student_marks:
            writer.writerow([first_name, last_name, mark])

def run_sv_files(sv_files):
    """
    This function takes a list of sv files and runs them through the Vivado simulator.
    """
    pass

if __name__ == '__main__':
    find_files_and_unpack_zip("C:\\Users\\devin\\Desktop\\LAB2_DOCUMENTS")
    files = list_files("C:\\Users\\devin\\Desktop\\LAB2_DOCUMENTS")
    student_files = {}
    for file in files:
        student_name = extract_student_info(file)
        if student_name not in student_files:
            student_files[student_name] = []
        student_files[student_name].append(file)

    if os.path.exists("student_marks.csv"):
        os.remove("student_marks.csv")
    student_marks = []
    for student in student_files:
        if student is None:
            continue   
        print(student)
        student_files[student] = sorted(student_files[student])

        #Grab Just the SV files
        sv_files = []
        for file in student_files[student]:
            if file.endswith('.sv'):
                sv_files.append(file)

        #Run the SV files
        run_sv_files(sv_files)

        name_parts = student.split(" ")
        firstname = name_parts[0]
        lastname = name_parts[1]
        mark = 0
        student_marks.append([firstname, lastname, mark])
    generate_csv(student_marks)

        