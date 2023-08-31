module CRC_Statemachine (
    input CLK,
    input RESET,
    input [15:0] INPUT_CRC,
    output reg [15:0] OUTPUT_CRC,
    output reg DATA_IN,
    output reg READ_MODE,
    input CRC_OUT
);

    // State Machine States
    typedef enum {LOAD_DATA, CALC_CRC, SHIFT_IN_ZEROS, SHIFT_OUT_CRC, UPDATE_OUTPUT_CRC} state_t;

    // State Machine State Register
    reg [2:0] state, next_state;

    // Data Buffer
    reg [15:0] data_buffer;

    // Counter for Bit Processing
    reg [4:0] bit_counter;

    // Calculated CRC Register
    reg [15:0] calculated_crc;

    // State Machine Logic
    always @(posedge CLK) begin
        if (RESET) begin
            state <= LOAD_DATA;
            next_state <= LOAD_DATA;
            data_buffer <= 16'h0000;
            bit_counter <= 0;
            OUTPUT_CRC <= 16'h0000;
            DATA_IN <= 1'b0;
            READ_MODE <= 1'b0;
            bit_counter <= 5'b00000;
            calculated_crc <= 16'h0000;
        end else begin
            state <= next_state;
            case (state)
                LOAD_DATA: begin
                    READ_MODE <= 1'b0;
                    data_buffer <= INPUT_CRC;
                    next_state <= CALC_CRC;
                    calculated_crc <= 16'h0000;
                    bit_counter <= 5'd0;
                end

                CALC_CRC: begin
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

                SHIFT_IN_ZEROS: begin
                    READ_MODE <= 1'b0;
                    DATA_IN <= 1'b0;
                    bit_counter <= bit_counter + 1;
                    if  (bit_counter == 15) begin
                        next_state <= SHIFT_OUT_CRC;
                        bit_counter <= 0;
                    end
                end

                SHIFT_OUT_CRC: begin
                    READ_MODE <= 1'b1;
                    calculated_crc <= {calculated_crc[14:0], CRC_OUT};
                    bit_counter = bit_counter + 1;
                    if (bit_counter == 16) begin
                        next_state <= UPDATE_OUTPUT_CRC;
                        bit_counter <= 0;
                    end
                end

                UPDATE_OUTPUT_CRC: begin
                    READ_MODE <= 1'b0;
                    OUTPUT_CRC <= calculated_crc;
                    next_state <= LOAD_DATA;
                end

                default: next_state <= LOAD_DATA;
            endcase
        end
    end

endmodule
