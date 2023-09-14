xvlog --sv ..\SRC\segment_mux.sv ..\SRC\for_students\sevenseg4ddriver.sv ..\SRC\sevenseg4ddrive_tb.sv ..\SRC\pwm_module.sv
xelab -debug typical -top sevenseg4ddrive_tb -snapshot ssdddd_tb_snapshot
xsim ssdddd_tb_snapshot -R