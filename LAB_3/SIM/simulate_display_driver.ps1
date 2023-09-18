xvlog --sv ..\SRC\for_students\double_dabble.sv ..\SRC\for_students\bcd_binary.sv ..\SRC\for_students\display_driver.sv ..\SRC\for_students\display_driver_tb.sv ..\SRC\for_students\segment_mux.sv
xelab -debug typical -top tb_display_driver -snapshot display_driver_tb_snapshot
xsim display_driver_tb_snapshot -R