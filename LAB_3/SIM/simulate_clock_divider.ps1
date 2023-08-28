xvlog --sv ..\SRC\one_second.sv ..\SRC\one_second_tb.sv
xelab -debug typical -top tb_clock_divider -snapshot onesecond_tb_snapshot
xsim onesecond_tb_snapshot -R