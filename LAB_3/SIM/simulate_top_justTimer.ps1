xvlog --sv ..\SRC\for_students\top_level.sv ..\SRC\for_students\debounce_wrapper.sv ..\SRC\for_students\top_level_tb.sv ..\SRC\for_students\double_dabble.sv ..\SRC\for_students\debounce.sv ..\SRC\for_students\bcd_binary.sv ..\SRC\for_students\display_driver.sv ..\SRC\for_students\clock_divider.sv ..\SRC\for_students\segment_mux.sv ..\SRC\for_students\time_counter.sv ..\SRC\for_students\timer.sv ..\SRC\for_students\blinking_display.sv
xelab -debug typical -top tb_top -snapshot top_tb_snapshot
xsim top_tb_snapshot -gui