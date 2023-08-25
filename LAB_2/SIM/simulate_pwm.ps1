xvlog --sv ..\SRC\pwm_module.sv ..\SRC\tb_pwm_module.sv
xelab -debug typical -top tb_pwm_module -snapshot pwm_tb_snapshot
xsim pwm_tb_snapshot -R