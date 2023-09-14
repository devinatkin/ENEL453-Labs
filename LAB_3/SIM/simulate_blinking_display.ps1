xvlog --sv ..\SRC\blinking_display.sv ..\SRC\tb_blinking_display.sv
xelab -debug typical -top tb_blinking_display -snapshot blink_tb_snapshot
xsim blink_tb_snapshot -R