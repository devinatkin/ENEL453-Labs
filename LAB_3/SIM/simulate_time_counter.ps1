xvlog --sv ..\SRC\for_students\time_counter.sv ..\SRC\for_students\time_counter_tb.sv
xelab -debug typical -top tb_time_counter -snapshot time_tb_snapshot
xsim time_tb_snapshot -R