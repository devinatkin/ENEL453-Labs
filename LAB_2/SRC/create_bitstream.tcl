# Create a new temporary project
create_project temp_project ./temp_project -part xc7a35tcpg236-1 -in_memory -force

# Add source files (adjust paths and types as needed)
read_verilog -sv ..\\SRC\\SRC_COMPLETE\\top_complete.sv
read_verilog -sv ..\\SRC\\SRC_COMPLETE\\circular_shift_register.sv
read_verilog -sv ..\\SRC\\pwm_module.sv
read_xdc ..\\SRC\\Basys3_Lab2Constraints.xdc

set_property top top_level [current_fileset]

# Launch synthesis
synth_design

#Link Design
link_design -part xc7a35tcpg236-1


write_checkpoint -force post_synth

opt_design

write_checkpoint -force post_opt

place_design

write_checkpoint -force post_place

route_design

write_checkpoint -force post_route

report_utilization -hierarchical -file utilization_hierarchical.rpt

write_bitstream bitstream.bit

open_hw_manager
connect_hw_server -url 10.13.113.125:3121
refresh_hw_server
open_hw_target


create_hw_bitstream -hw_device [lindex [get_hw_devices xc7a35t_0] 0] bitstream.bit
program_hw_devices