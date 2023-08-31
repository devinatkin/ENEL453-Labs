xvlog --sv ..\SRC\crc_statemachine.sv ..\SRC\tb_top_level.sv ..\SRC\crc_calc.sv ..\SRC\top_level.sv
xelab -debug typical -top tb_top_level -snapshot top_tb_snapshot
xsim top_tb_snapshot -R