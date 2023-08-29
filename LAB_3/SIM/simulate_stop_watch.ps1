xvlog --sv ..\SRC\stop_watch.sv ..\SRC\stop_watch_tb.sv ..\SRC\time_counter.sv
xelab -debug typical -top stop_watch_tb -snapshot stopwatch_tb_snapshot
xsim stopwatch_tb_snapshot -R