xvlog --sv ..\SRC\CRC_CALC.sv ..\SRC\TOP.sv ..\SRC\tb_TOP.sv
xelab -debug typical -top tb_top_level -snapshot top_tb_snapshot
xsim top_tb_snapshot -R