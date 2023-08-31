xvlog --sv ..\SRC\crc_calc.sv ..\SRC\tb_crc_calc.sv
xelab -debug typical -top tb_CRC_CALC -snapshot crc_tb_snapshot
xsim crc_tb_snapshot -R