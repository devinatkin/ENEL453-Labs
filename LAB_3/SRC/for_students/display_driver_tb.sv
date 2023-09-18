`timescale 1ns / 1ns

module tb_display_driver();

    // Declare signals to connect to the display_driver module
    logic clk;
    logic rst_n;
    logic [5:0] minutes;
    logic [5:0] seconds;
    wire [6:0] seg;
    wire [3:0] an;

    logic [31:0] displayHold;
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
        $display("an = %b , seg = %b, time = %2d:%2d", an, seg, minutes, seconds);
        #1; // Short Delay to move transitions away from clock edges
        if(an == 4'b0111) begin //Increment after the anodes have been cycled through
            displayHold = displayHold + 1;
            if(displayHold == 32'd3) begin //Increment after 100 anode cycles
                displayHold = 32'd0;
                seconds = seconds + 1;
                if(seconds == 6'd60) begin
                    seconds = 6'd0;
                    minutes = minutes + 1;
                end
            end
        end
    end

    // Testbench logic
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        minutes = 6'b0;
        seconds = 6'b0;
        displayHold = 32'd0;

        #2; // Short Delay to move transitions away from clock edges

        // Apply reset
        rst_n = 0;
        #10;
        rst_n = 1;
        #100;

        while (minutes < 6'd60) begin // wait for minutes to be 60
            #100;
        end
        $finish;
    end

endmodule
