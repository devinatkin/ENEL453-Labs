xvlog --sv ..\SRC\top_level.sv ..\SRC\top_level_tb.sv ..\SRC\for_students\double_dabble.sv ..\SRC\for_students\debounce.sv ..\SRC\bcd_binary.sv ..\SRC\display_driver.sv ..\SRC\mode_mux.sv ..\SRC\one_second.sv ..\SRC\segment_mux.sv ..\SRC\stop_watch.sv ..\SRC\time_counter.sv ..\SRC\timer.sv
xelab -debug typical -top tb_top -snapshot top_tb_snapshot
xsim top_tb_snapshot -gui