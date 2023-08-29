xvlog --sv ..\SRC\segment_mux.sv ..\SRC\tb_segment_mux.sv
xelab -debug typical -top tb_segment_mux -snapshot smux_tb_snapshot
xsim smux_tb_snapshot -R