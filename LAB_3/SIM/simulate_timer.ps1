xvlog --sv ..\SRC\time_counter.sv ..\SRC\timer.sv ..\SRC\timer_tb.sv
xelab -debug typical -top tb_timer -snapshot timer_tb_snapshot
xsim timer_tb_snapshot -R