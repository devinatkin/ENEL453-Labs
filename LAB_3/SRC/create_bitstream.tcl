
# Create a new temporary project
create_project temp_project ./temp_project -part xc7a35tcpg236-1 -in_memory -force

# Add source files (adjust paths and types as needed)
read_verilog -sv ..\\SRC\\top_level.sv
read_verilog -sv ..\\SRC\\timer.sv
read_verilog -sv ..\\SRC\\time_counter.sv
read_verilog -sv ..\\SRC\\stop_watch.sv
read_verilog -sv ..\\SRC\\segment_mux.sv
read_verilog -sv ..\\SRC\\one_second.sv
read_verilog -sv ..\\SRC\\mode_mux.sv
read_verilog -sv ..\\SRC\\display_driver.sv
read_verilog -sv ..\\SRC\\sevenseg4ddriver.sv
read_verilog -sv ..\\SRC\\for_students\\pwm_module.sv
read_verilog -sv ..\\SRC\\bcd_binary.sv
read_verilog -sv ..\\SRC\\debounce_wrapper.sv
read_verilog -sv ..\\SRC\\stopwatch_timer_wrapper.sv
read_verilog -sv ..\\SRC\\for_students\\debounce.sv
read_verilog -sv ..\\SRC\\for_students\\double_dabble.sv

read_xdc ..\\SRC\\Basys3_Lab3_Provided_Constraints.xdc

set_property top top [current_fileset]
# Launch synthesis
synth_design

#Link Design
#link_design -part xc7a35tcpg236-1


write_checkpoint -force post_synth

opt_design

write_checkpoint -force post_opt

place_design

write_checkpoint -force post_place

route_design

write_checkpoint -force post_route

report_utilization -hierarchical -file utilization_hierarchical.rpt

write_bitstream bitstream.bit -force

open_hw_manager
connect_hw_server -url 10.13.89.50:3121
refresh_hw_server
open_hw_target


create_hw_bitstream -hw_device [lindex [get_hw_devices xc7a35t_0] 0] bitstream.bit
program_hw_devices