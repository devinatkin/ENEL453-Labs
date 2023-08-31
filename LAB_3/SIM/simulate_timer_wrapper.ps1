xvlog --sv ..\SRC\stopwatch_timer_wrapper.sv ..\SRC\stopwatch_timer_wrapper_tb.sv ..\SRC\stop_watch.sv ..\SRC\time_counter.sv ..\SRC\time_counter.sv
xelab -debug typical -top tb_stopwatch_timer_wrapper -snapshot sw_tm_wr_tb_snapshot
xsim sw_tm_wr_tb_snapshot -R