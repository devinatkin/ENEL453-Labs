module debounce_wrapper(
    input wire clk,
    input wire rst_n,
    input wire [4:0] buttons, // A 5-bit wide wire to hold the states of 5 buttons
    output wire [4:0] results // A 5-bit wide wire to hold the debounced results
);


    generate
        genvar i;
        for (i = 0; i < 5; i = i + 1) begin: debounce_instances
            // Instantiate the debounce module
            debounce #(50000000,10) generic_debounce (
                .clk(clk),
                .button(buttons[i]),
                .reset_n(rst_n),
                .result(results[i])
            );
        end
    endgenerate

endmodule
