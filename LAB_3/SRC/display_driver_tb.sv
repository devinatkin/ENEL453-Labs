`timescale 1ns / 1ps

module tb_display_driver();

    // Declare signals to connect to the display_driver module
    reg clk;
    reg clk100k;
    reg clk1s;
    reg rst_n;
    reg [5:0] minutes;
    reg [5:0] seconds;
    reg blink;
    wire [6:0] seg;
    wire [3:0] an;

    // Instantiate the display_driver module
    display_driver uut (
        .clk(clk),
        .clk100k(clk100k),
        .clk1s(clk1s),
        .rst_n(rst_n),
        .minutes(minutes),
        .seconds(seconds),
        .blink(blink),
        .seg(seg),
        .an(an)
    );

    // Clock generation blocks for 100MHz, 100KHz and 1Hz
    always #5 clk = ~clk;
    always #5000 clk100k = ~clk100k;
    always #500000000 clk1s = ~clk1s;

    // Testbench logic
    initial begin
        // Initialize signals
        clk = 0;
        clk100k = 0;
        clk1s = 0;
        rst_n = 0;
        minutes = 6'b0;
        seconds = 6'b0;
        blink = 0;
        
        // Apply reset
        rst_n = 0;
        #10;
        rst_n = 1;
        #(5000*16*2)
        #160; // Wait for 16 clock cycles

        // Self-Check 1: Check if seg and an are correctly initialized after reset
        if(seg !== 7'b0 || an !== 4'b0111) $display("Self-Check 1 Failed!");

        // Test Case 1: Display 12:34
        minutes = 6'd12; // 12 minutes
        seconds = 6'd34; // 34 seconds
        #160; // Wait for 16 clock cycles

        // Self-Check 2: Confirm if the expected values have propagated (manual inspection might be needed)
        // For now, you'll need to manually confirm if seg and an have the correct values
        
        // Test Case 2: Enable blinking
        blink = 1;
        #160; // Wait for 16 clock cycles

        // Self-Check 3: Confirm if anodes are turned off during blinking
        if(an == 4'b1111) begin
            $display("Self-Check 3 Failed!");
        end
        do begin
            #160; // Wait for 16 clock cycles
        end while(clk1s === 0)
        if(an !== 4'b1111) $display("Self-Check 4 Failed!");
        $finish;
    end

endmodule
