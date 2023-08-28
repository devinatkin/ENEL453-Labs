xvlog --sv ..\SRC\for_students\debounce.sv ..\SRC\for_students\tb_debounce.sv
xelab -debug typical -top tb_debounce -snapshot debounce_tb_snapshot
xsim debounce_tb_snapshot -R