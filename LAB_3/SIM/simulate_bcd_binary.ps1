xvlog --sv ..\SRC\bcd_binary.sv ..\SRC\bcd_binary_tb.sv
xelab -debug typical -top tb_bcd_to_binary -snapshot bcd_tb_snapshot
xsim bcd_tb_snapshot -R