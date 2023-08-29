xvlog --sv ..\SRC\for_students\double_dabble.sv ..\SRC\bcd_binary.sv ..\SRC\display_driver.sv ..\SRC\display_driver_tb.sv ..\SRC\mode_mux.sv ..\SRC\segment_mux.sv
xelab -debug typical -top tb_display_driver -snapshot display_driver_tb_snapshot
xsim display_driver_tb_snapshot -R