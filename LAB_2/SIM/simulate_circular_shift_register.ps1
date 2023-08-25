xvlog --sv ..\SRC\SRC_COMPLETE\tb_circular_shift_register.sv ..\SRC\SRC_COMPLETE\circular_shift_register.sv
xelab -debug typical -top tb_circular_shift_register -snapshot circshift_tb_snapshot
xsim circshift_tb_snapshot -R