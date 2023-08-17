# Steps for Simulation
# xvlog --sv ..\SRC\CRC_CALC.sv ..\SRC\tb_CRC_CALC.sv
# xelab -debug typical -top tb_CRC_CALC -snapshot crc_tb_snapshot
# xsim crc_tb_snapshot -R

# This is a simple script to automate the process of compiling and running Verilog file simulatons
# It is designed to be used with Icarus Verilog (http://iverilog.icarus.com/) and GTKWave (http://gtkwave.sourceforge.net/)
# It will be changed to use Vivado in the future

import subprocess
import os

def compile_and_run(verilog_files, output_file):
    # Compile Verilog files using iverilog
    compile_command = ["iverilog", "-o", "temp.out"] + verilog_files
    result = subprocess.run(compile_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if result.returncode != 0:
        print("Compilation Error:", result.stderr.decode())
        return False

    # Run the compiled output using vvp
    run_command = ["vvp", "temp.out"]
    with open(output_file, 'w') as out_file:
        result = subprocess.run(run_command, stdout=out_file, stderr=subprocess.PIPE)
        if result.returncode != 0:
            print("Runtime Error:", result.stderr.decode())
            return False

    os.remove("temp.out")
    return True

def compare_results(file1, file2):
    with open(file1, 'r') as f1, open(file2, 'r') as f2:
        content1 = f1.readlines()
        content2 = f2.readlines()
        
        differences = [line for line in content1 if line not in content2]

        if differences:
            print("Differences found:")
            for diff in differences:
                print(diff)
        else:
            print("No differences found.")

# Define the Verilog files for the first and second sets
set1_files = ["file1.v", "file2.v"]
set2_files = ["file3.v", "file4.v"]

# Output files for both sets
output_file1 = "output1.txt"
output_file2 = "output2.txt"

# Compile and run the first set of files
if not compile_and_run(set1_files, output_file1):
    print("Failed to run set 1")
else:
    # Compile and run the second set of files
    if not compile_and_run(set2_files, output_file2):
        print("Failed to run set 2")
    else:
        # Compare the results
        compare_results(output_file1, output_file2)
