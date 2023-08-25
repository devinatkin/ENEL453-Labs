xvlog --sv ..\SRC\mode_mux.sv ..\SRC\mode_mux_tb.sv
xelab -debug typical -top tb_mux_2to1 -snapshot mux_tb_snapshot
xsim mux_tb_snapshot -R