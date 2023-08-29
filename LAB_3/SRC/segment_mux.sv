module segment_mux (
    input logic clk,            // Clock signal
    input logic rst_n,           // Active low reset signal
    input logic [6:0] in0,       // First 7-bit input
    input logic [6:0] in1,       // Second 7-bit input
    input logic [6:0] in2,       // Third 7-bit input
    input logic [6:0] in3,       // Fourth 7-bit input
    output logic [6:0] out_val   // 7-bit output
);

    // Internal 2-bit counter for selecting the input values
    logic [1:0] counter;

    // Behavior under active low reset or positive clock edge
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 2'b00;   // Reset counter
        else
            counter <= counter + 1; // Increment counter on clock edge
    end

    // Multiplexing the input values based on the counter
    always_comb begin
        case (counter)
            2'b00: out_val = in0; // First input
            2'b01: out_val = in1; // Second input
            2'b10: out_val = in2; // Third input
            2'b11: out_val = in3; // Fourth input
            default: out_val = 7'b0000000; // Shouldn't get here, but it's good to have a default case
        endcase
    end

endmodule
