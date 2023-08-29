module tb_segment_mux;

    // Signal declarations
    logic clk;
    logic rst_n;
    logic [6:0] in0, in1, in2, in3;
    logic [6:0] out_val;

    // Instantiate the segment_mux module
    segment_mux uut (
        .clk(clk),
        .rst_n(rst_n),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .out_val(out_val)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Toggle clock every 5 time units
    end

    // Testbench logic
    initial begin

        // Test 1: Active low reset
        rst_n = 0;
        in0 = 7'b0000000;
        in1 = 7'b0000000;
        in2 = 7'b0000000;
        in3 = 7'b0000000;
        #10;
        rst_n = 1;
        
        // Test 2: Sequential value switching
        in0 = 7'b0000001;
        in1 = 7'b0000010;
        in2 = 7'b0000100;
        in3 = 7'b0001000;
        #50; // Waiting for 5 clock cycles (should loop back to in0)

        // Test 3: Change of input values while running
        in0 = 7'b0010000;
        in1 = 7'b0100000;
        in2 = 7'b1000000;
        in3 = 7'b0000001;
        #40; // Waiting for 4 clock cycles (should be back at in0)

        $finish; // End of simulation
    end

endmodule
