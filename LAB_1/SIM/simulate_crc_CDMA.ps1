xvlog --sv ..\SRC\crc_calc_cdma2000.sv ..\SRC\tb_crc_calc_CDMA2000.sv
xelab -debug typical -top tb_CRC_CALC -snapshot crc_tb_snapshot
xsim crc_tb_snapshot -R