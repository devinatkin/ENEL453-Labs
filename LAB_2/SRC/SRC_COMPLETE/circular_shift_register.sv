module circular_shift_register #(
    parameter WIDTH = 8,        // Width of each register
    parameter SIZE = 16         // Number of registers
) (
    input logic clk,            // Clock input
    input logic rst_n,          // Active low reset input
    output logic [WIDTH-1:0] reg_out[SIZE-1:0] // Output array of registers
);

    logic [WIDTH-1:0] circ_reg [SIZE-1:0]; // Register array definition


    // Always block triggered by a positive edge of the clock
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset the register array to the initial state
            circ_reg <= {8'h00,8'h00,8'h00,8'h00,8'h10,8'h20,8'h40,8'hFF,8'hFF,8'h40,8'h20,8'h10,8'h00,8'h00,8'h00,8'h00};
        end else begin
            // Circularly shift the register array
            circ_reg <= {circ_reg[SIZE-2:0], circ_reg[SIZE-1]};
        end
    end

    // Assign the output
    assign reg_out = circ_reg;

endmodule
