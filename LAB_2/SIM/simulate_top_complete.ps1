xvlog --sv ..\SRC\SRC_COMPLETE\tb_top_complete.sv ..\SRC\SRC_COMPLETE\circular_shift_register.sv ..\SRC\SRC_COMPLETE\top_complete.sv ..\SRC\pwm_module.sv
xelab -debug typical -top tb_top_level -snapshot top_complete_tb_snapshot
xsim top_complete_tb_snapshot -R