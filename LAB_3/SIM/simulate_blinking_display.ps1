xvlog --sv ..\SRC\for_students\blinking_display.sv ..\SRC\for_students\tb_blinking_display.sv
xelab -debug typical -top tb_blinking_display -snapshot blink_tb_snapshot
xsim blink_tb_snapshot -R