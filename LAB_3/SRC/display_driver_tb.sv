`timescale 1ns / 1ps

module tb_display_driver();

    // Declare signals to connect to the display_driver module
    reg clk;
    reg rst_n;
    reg [5:0] minutes;
    reg [5:0] seconds;
    wire [6:0] seg;
    wire [3:0] an;

    // Instantiate the display_driver module
    display_driver uut (
        .clk(clk),
        .rst_n(rst_n),
        .minutes(minutes),
        .seconds(seconds),
        .seg(seg),
        .an(an)
    );

    // Clock generation blocks for 100MHz
    always #5 clk = ~clk;

    always @(an) begin
        $display("an = %b , seg = %b, time = %d:%d", an, seg, minutes, seconds);
    end

    // Testbench logic
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        minutes = 6'b0;
        seconds = 6'b0;
        
        // Apply reset
        rst_n = 0;
        #10;
        rst_n = 1;
        while(an == 4'b1000) begin // wait for an to be 01000
            #100;
        end
        while (minutes < 6'd60) begin
            while (seconds < 6'd60) begin
                while(an != 4'b1000) begin
                    #100;
                end
                seconds = seconds + 1;
            end
            seconds = 6'd0;
            minutes = minutes + 1;
        end
        $finish;
    end

endmodule
