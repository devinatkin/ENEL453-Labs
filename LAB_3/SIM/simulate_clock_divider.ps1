xvlog --sv ..\SRC\for_students\tb_clock_divider.sv ..\SRC\for_students\clock_divider.sv
xelab -debug typical -top tb_clock_divider -snapshot onesecond_tb_snapshot
xsim onesecond_tb_snapshot -R