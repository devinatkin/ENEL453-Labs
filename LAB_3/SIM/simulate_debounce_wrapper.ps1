xvlog --sv ..\SRC\for_students\debounce.sv ..\SRC\for_students\debounce_wrapper_tb.sv ..\SRC\for_students\debounce_wrapper.sv
xelab -debug typical -top tb_debounce_wrapper -snapshot debounce_tb_snapshot
xsim debounce_tb_snapshot -R