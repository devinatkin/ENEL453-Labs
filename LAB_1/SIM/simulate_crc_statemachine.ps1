xvlog --sv ..\SRC\CRC_Statemachine.sv ..\SRC\tb_crc_statemachine.sv ..\SRC\crc_calc.sv
xelab -debug typical -top tb_CRC_Statemachine -snapshot crc_sm_tb_snapshot
xsim crc_sm_tb_snapshot -R