import os
import subprocess

def execute_ps1_scripts():
    # Get the current directory
    current_directory = os.getcwd()
    
    # List all files in the directory
    all_files = os.listdir(current_directory)
    
    # Filter out the files that are not .ps1
    ps1_files = [f for f in all_files if f.endswith('.ps1')]
    
    output_files = []
    if not ps1_files:
        print("No PS1 files found in the current directory.")
        return
    
    # Loop over each .ps1 file and execute it
    for ps1_file in ps1_files:
        print(f"Executing {ps1_file}...")
        # Construct the command to execute the PowerShell script
        cmd = ["powershell", "-File", os.path.join(current_directory, ps1_file)]
        
        # Execute the script and capture the output
        result = subprocess.run(cmd, capture_output=True, text=True)
        
        # Generate a text file name based on the script name
        output_file_name = f"{ps1_file.split('.')[0]}_output.txt"
        
        # Write the output to a text file
        with open(output_file_name, 'w') as output_file:
            output_file.write("=== Standard Output ===\n")
            output_file.write(result.stdout)
            output_file.write("\n=== Standard Error ===\n")
            output_file.write(result.stderr)
            output_files.append(output_file_name)
    return output_files

if __name__ == "__main__":
    output_files = execute_ps1_scripts()
    print("=== Output Files ===")
    for output_file in output_files:
        print(output_file)
