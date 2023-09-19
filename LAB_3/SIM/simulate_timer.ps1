xvlog --sv ..\SRC\for_students\time_counter.sv ..\SRC\for_students\timer.sv ..\SRC\for_students\timer_tb.sv
xelab -debug typical -top tb_timer -snapshot timer_tb_snapshot
xsim timer_tb_snapshot -R