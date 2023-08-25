module tb_mux_2to1;

    // Parameters and signals
    parameter int DATA_WIDTH = 8;
    logic [DATA_WIDTH-1:0] a;
    logic [DATA_WIDTH-1:0] b;
    logic sel;
    logic [DATA_WIDTH-1:0] y;
    
    // Instantiate the DUT (Device Under Test)
    mux_2to1 #(DATA_WIDTH) uut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );

    // Test procedure
    initial begin

        // Test 1: When sel is 0, output should be equal to input 'a'
        a = 8'hAA;  // Set a to 0xAA
        b = 8'h55;  // Set b to 0x55
        sel = 0;    // Set selector to 0
        #10;        // Wait for some time (10 time units)
        
        if (y !== a) begin
            $display("Test Failed: For sel = 0, expected y = %h, got y = %h", a, y);
            $finish;
        end

        // Test 2: When sel is 1, output should be equal to input 'b'
        sel = 1;    // Set selector to 1
        #10;        // Wait for some time (10 time units)
        
        if (y !== b) begin
            $display("Test Failed: For sel = 1, expected y = %h, got y = %h", b, y);
            $finish;
        end

        // All tests passed
        $display("Test Passed");
        $finish;
    end
endmodule
