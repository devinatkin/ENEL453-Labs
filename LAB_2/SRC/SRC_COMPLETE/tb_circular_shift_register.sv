module tb_circular_shift_register;

    // Parameters
    parameter WIDTH = 8;
    parameter SIZE = 16;

    // Clock and reset signals
    logic clk;
    logic rst_n;

    // Output array for observing the register state
    logic [WIDTH-1:0] reg_out[SIZE-1:0];

    // Instantiate the circular shift register
    circular_shift_register #(
        .WIDTH(WIDTH),
        .SIZE(SIZE)
    ) u_circular_shift_register (
        .clk(clk),
        .rst_n(rst_n),
        .reg_out(reg_out)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // 10 time unit period
    end

    // Testbench stimulus
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        
        // Apply reset
        #10 rst_n = 1;
        #10 rst_n = 0;
        #10 rst_n = 1;

        // Loop through 16 cycles and print the register state
        repeat (SIZE) begin
            #10; // Wait for one clock cycle
            $display("Register State:");
            foreach (reg_out[i]) $display("  reg_out[%0d] = %h", i, reg_out[i]);
        end

        // Finish the simulation
        $finish;
    end

endmodule
