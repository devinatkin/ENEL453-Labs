import subprocess
import re

def extract_message_and_crc(log: str) -> tuple:
    """
    Extract the original message and the calculated CRC value from the given simulation log.
    
    Parameters:
    - log (str): The log text where the information resides.
    
    Returns:
    - tuple: A tuple containing the original message and the calculated CRC value as strings.
    """
    
    # Regular expression pattern to find the original message
    message_pattern = r"Original Message: (.+?)\n"
    
    # Regular expression pattern to find the calculated CRC in Hex
    crc_pattern = r"Calculated CRC \(Hex\): (.+?)\n"
    
    # Search for the patterns in the log
    message_match = re.search(message_pattern, log)
    crc_match = re.search(crc_pattern, log)
    
    # Extract the required information if matches are found
    if message_match and crc_match:
        original_message = message_match.group(1)
        calculated_crc = crc_match.group(1)
        return original_message, calculated_crc
    else:
        return "Message or CRC not found in the log", "Message or CRC not found in the log"


def run_verilog_sim(verilog_files, top_module):
    try:
        # Step 1: Compile the Verilog files using xvlog
        compile_command = ['xvlog', '--sv'] + verilog_files
        subprocess.run(compile_command, check=True, shell=True, stderr=subprocess.PIPE)
        
        # Step 2: Elaborate the design using xelab
        elaborate_command = ['xelab', '-debug', 'typical', '-top', top_module, '-snapshot', f'{top_module}_snapshot']
        subprocess.run(elaborate_command, check=True, shell=True,stderr=subprocess.PIPE)
        
        # Step 3: Run the simulation using xsim
        sim_command = ['xsim', f'{top_module}_snapshot', '-R', '-nolog']
        result = subprocess.run(sim_command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
        
        # Return the output from the simulation
        return result.stdout.decode('utf-8')

    except subprocess.CalledProcessError as e:
        return f"Error: {e}\n{e.stderr.decode('utf-8')}"



if __name__ == '__main__':
    # Test the function with a set of example files
    verilog_files_for_toplevel = ["C:\\Users\\devin\\Desktop\\ENEL453_Labs\\LAB_1\\SRC\\crc_calc.sv",\
                    "C:\\Users\\devin\\Desktop\\ENEL453_Labs\\LAB_1\\SRC\\crc_statemachine.sv",\
                    "C:\\Users\\devin\\Desktop\\ENEL453_Labs\\LAB_1\\SRC\\tb_top_level.sv",\
                    "C:\\Users\\devin\\Desktop\\ENEL453_Labs\\LAB_1\\SRC\\top_level.sv"]
    
    verilog_files_for_crc_calc = ["C:\\Users\\devin\\Desktop\\ENEL453_Labs\\LAB_1\\SRC\\crc_calc.sv",\
                    "C:\\Users\\devin\\Desktop\\ENEL453_Labs\\LAB_1\\SRC\\tb_crc_calc.sv"]
    #
    #iverilog -g2012 -o sim.vvp C:\Users\devin\Desktop\ENEL453_Labs\LAB_1\SRC\crc_calc.sv C:\Users\devin\Desktop\ENEL453_Labs\LAB_1\SRC\crc_statemachine.sv C:\Users\devin\Desktop\ENEL453_Labs\LAB_1\SRC\tb_top_level.sv C:\Users\devin\Desktop\ENEL453_Labs\LAB_1\SRC\top_level.sv

    output = run_verilog_sim(verilog_files_for_toplevel, 'tb_top_level')
    print()
    print(output)
    print()


    output = run_verilog_sim(verilog_files_for_crc_calc, 'tb_CRC_CALC')
    print("------------------------------------")
    print(output)
    print("------------------------------------")

    # Extract the message and CRC from the output
    message, crc = extract_message_and_crc(output)
    print(f"Message: {message}")
    print(f"CRC: {crc}")