module top_level (
    input CLK,
    input RESET,
    input [15:0] SWITCHES,
    output [15:0] LEDS
);

    // CRC Output Signal
    wire CRC_OUT;

    // Data Input Signal for CRC Calculation
    reg DATA_IN;
    
    // Read Mode Signal
    reg READ_MODE;

    // CRC Module Instance
    CRC_CALC crc_calc (
        .CLK(CLK),
        .RESET_N(RESET),
        .DATA_IN(DATA_IN),
        .READ_MODE(READ_MODE),
        .CRC_OUT(CRC_OUT)
    );

    // State Machine Instance
    CRC_Statemachine state_machine (
        .CLK(CLK),
        .RESET_N(RESET),
        .INPUT_CRC(SWITCHES),
        .OUTPUT_CRC(LEDS),
        .DATA_IN(DATA_IN),
        .READ_MODE(READ_MODE),
        .CRC_OUT(CRC_OUT)
    );

endmodule
