module top_level (
    input CLK,
    input RESET_N,
    input [15:0] SWITCHES,
    output reg [15:0] LEDS
);

    // State Machine States
    typedef enum {LOAD_DATA, CALC_CRC, SHIFT_IN_ZEROS, SHIFT_OUT_CRC, UPDATE_LEDS} state_t;
    
    // State Machine State Register
    reg [2:0] state, next_state;
    
    // Data Buffer
    reg [15:0] data_buffer;
    
    // Read Mode Signal
    reg READ_MODE;

    // Data Input Signal for CRC Calculation
    reg DATA_IN;
    
    // CRC Output Signal
    wire CRC_OUT;

    // CRC Module Instance
    CRC_CALC crc_calc (
        .CLK(CLK),
        .RESET_N(RESET_N),
        .DATA_IN(DATA_IN),
        .READ_MODE(READ_MODE),
        .CRC_OUT(CRC_OUT)
    );

    // Counter for Bit Processing
    reg [4:0] bit_counter;

    // Calculated CRC Register
    reg [15:0] calculated_crc;

    // State Machine Logic
    always @(posedge CLK or negedge RESET_N) begin
        if (!RESET_N) begin
            state <= LOAD_DATA;
            next_state <= LOAD_DATA;
            data_buffer <= 16'h0000;
            bit_counter <= 0;
            LEDS <= 16'h0000;
            DATA_IN <= 1'b0;
            READ_MODE <= 1'b0;
            bit_counter <= 5'b00000;
            calculated_crc <= 16'h0000;
        end else begin
            state <= next_state;
            case (state)
                LOAD_DATA: begin                                // Load Data from Switches 
                    READ_MODE <= 1'b0;
                    data_buffer <= SWITCHES;
                    next_state <= CALC_CRC;
                    calculated_crc <= 16'h0000;
                    bit_counter <= 5'd0;
                end

                CALC_CRC: begin                                             // Push the data into the CRC Calculator (16-bits of data)
                    READ_MODE <= 1'b0;
                    DATA_IN <= data_buffer[15];
                    data_buffer <= {data_buffer[14:0], 1'b0};
                    
                    if (bit_counter == 16) begin
                        next_state <= SHIFT_IN_ZEROS;
                        bit_counter <= 0;
                    end else begin
                        bit_counter <= bit_counter + 1;
                    end
                end

                SHIFT_IN_ZEROS: begin                                       //Append Zeros being Shifted into the Cell (16-bits of data)
                    READ_MODE <= 1'b0;
                    DATA_IN <= 1'b0;
                    bit_counter <= bit_counter + 1;
                    if  (bit_counter == 15) begin
                        next_state <= SHIFT_OUT_CRC;
                        bit_counter <= 0;
                    end
                end

                SHIFT_OUT_CRC: begin                                        //Shift out the CRC Value from the module
                    READ_MODE <= 1'b1;
                    calculated_crc <= {calculated_crc[14:0], CRC_OUT};
                    bit_counter = bit_counter + 1;
                    if (bit_counter == 16) begin
                        next_state <= UPDATE_LEDS;
                        bit_counter <= 0;
                    end
                end

                UPDATE_LEDS: begin                                          //Update the output LEDs to reflect the new CRC value. 
                    READ_MODE <= 1'b0;
                    LEDS <= calculated_crc;
                    
                    next_state <= LOAD_DATA;
                end

                default: next_state <= LOAD_DATA;
            endcase
    
        end
    end

endmodule
