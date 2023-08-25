xvlog --sv ..\SRC\CRC_CALC.sv ..\SRC\tb_CRC_CALC.sv
xelab -debug typical -top tb_CRC_CALC -snapshot crc_tb_snapshot
xsim crc_tb_snapshot -R