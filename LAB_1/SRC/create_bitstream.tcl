# Create a new temporary project
create_project temp_project ./temp_project -part xc7a35tcpg236-1 -in_memory -force

# Add source files (adjust paths and types as needed)
read_verilog -sv ..\\SRC\\CRC_CALC.sv
read_verilog -sv 
read_xdc ..\\SRC\\Basys3_Lab1_Constraints.xdc

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

