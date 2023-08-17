# Create a new temporary project
create_project temp_project ./temp_project -part xc7a35tcpg236-1 -force

# Add source files (adjust paths and types as needed)
add_files ..\\SRC\\CRC_CALC.sv
add_files ..\\SRC\\TOP.sv
add_files ..\\SRC\\Basys3_Lab1_Constraints.xdc

# Read in any additional settings if needed
# ...

# Launch synthesis
launch_runs synth_1 -jobs 4

# Wait for synthesis to complete
wait_on_run synth_1

# Launch implementation
launch_runs impl_1 -jobs 4

# Wait for implementation to complete
wait_on_run impl_1

# Write the bitstream
write_bitstream -force Lab1.bit

# Optionally, close the project if you don't need it anymore
close_project
