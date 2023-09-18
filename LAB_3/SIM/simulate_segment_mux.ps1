xvlog --sv ..\SRC\for_students\segment_mux.sv ..\SRC\for_students\tb_segment_mux.sv
xelab -debug typical -top tb_segment_mux -snapshot smux_tb_snapshot
xsim smux_tb_snapshot -R