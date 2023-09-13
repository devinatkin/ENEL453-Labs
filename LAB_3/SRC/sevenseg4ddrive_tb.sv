`timescale 1ns / 1ps

module sevenseg4ddrive_tb;

    logic clk;
    logic rst_n;
    logic [6:0] d0;
    logic [6:0] d1;
    logic [6:0] d2;
    logic [6:0] d3;
    
    logic [6:0] seg;
    logic [3:0] an;

    sevenseg4ddriver DUT(
    .clk(clk),
    .rst_n(rst_n),
    .digit0_segments(d0),
    .digit1_segments(d1),
    .digit2_segments(d2),
    .digit3_segments(d3),
    .segments(seg),
    .anodes(an)
    );

    // Clock generation for 100 MHz clock
    always begin
        #5 clk = ~clk;
    end

    //  Print Output whenever it changes
    always@(seg) begin
        $display("Anode State %4b, Cathode State %0h", an, seg);
                
    end

    initial begin
        // Initialize all inputs
        $display("Starting simulation...");
        clk = 0;
        rst_n=0;
        d0 = 7'b0011000;
        d1 = 7'b0011001;
        d2 = 7'b0011010;
        d3 = 7'b0011011;
        
        #10; rst_n=1;

        #10000000;

        #10000000;

        #10000000;

        #10000000;
        
        #10000000;
        
        #10000000;
        
        $display("Finishing simulation...");
        $finish;
    end
endmodule