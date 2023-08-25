xvlog --sv ..\SRC\pwm_module.sv ..\SRC\top.sv ..\SRC\tb_top.sv
xelab -debug typical -top tb_top_level -snapshot top_tb_snapshot
xsim top_tb_snapshot -R