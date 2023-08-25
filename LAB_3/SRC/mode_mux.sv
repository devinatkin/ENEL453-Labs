module mux_2to1 #(
    parameter int DATA_WIDTH = 8  // Parameterized data width with a default value of 8 bits
) (
    input logic [DATA_WIDTH-1:0] a,  // Input 1
    input logic [DATA_WIDTH-1:0] b,  // Input 2
    input logic sel,                  // Selector
    output logic [DATA_WIDTH-1:0] y   // Output
);

    // Description: A 2-to-1 multiplexer with parameterized data width
    // The 'y' output will be 'a' if 'sel' is 0, and 'b' if 'sel' is 1.
    always_comb begin
        if (sel == 0) begin
            y = a;
        end else begin
            y = b;
        end
    end

endmodule
