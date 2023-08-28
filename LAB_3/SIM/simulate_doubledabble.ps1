xvlog --sv ..\SRC\for_students\double_dabble.sv ..\SRC\for_students\double_dabble_tb.sv
xelab -debug typical -top double_dabble_tb -snapshot doubledabble_tb_snapshot
xsim doubledabble_tb_snapshot -R