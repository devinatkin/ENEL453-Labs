`timescale 1ns / 1ps

module tb_top();

    // Declare the signals to connect to the top module
    reg clk;
    reg rst;
    reg start_btn;
    reg stop_btn;
    reg softrst_btn;
    reg inc_min_btn;
    reg inc_sec_btn;
    reg mode_sw;

    logic [6:0] seg;
    logic [3:0] an;

    // Clock Generation
    always #5 clk = ~clk;  // 10ns clock period (for a 100MHz clock)

    // Instantiate the top module
    top uut (
        .clk(clk),
        .rst(rst),
        .start_btn(start_btn),
        .stop_btn(stop_btn),
        .softrst_btn(softrst_btn),
        .inc_min_btn(inc_min_btn),
        .inc_sec_btn(inc_sec_btn),
        .mode_sw(mode_sw),
        .seg(seg),
        .an(an)
    );

    // Testbench Logic
    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        start_btn = 0;
        stop_btn = 0;
        softrst_btn = 0;
        inc_min_btn = 0;
        inc_sec_btn = 0;
        mode_sw = 0;

        // Reset pulse
        rst = 1;
        #10000 rst = 0;

        // Start stopwatch
        start_btn = 1;
        #100 start_btn = 0;

        // Test different modes
        mode_sw = 1;
        #100 mode_sw = 0;

        // Increment minutes and seconds
        inc_min_btn = 1;
        #10 inc_min_btn = 0;
        inc_sec_btn = 1;
        #10 inc_sec_btn = 0;

        // Stop timer/stopwatch
        stop_btn = 1;
        #10 stop_btn = 0;

        // Software Reset
        softrst_btn = 1;
        #10 softrst_btn = 0;

        // Wait before ending simulation
        #500;

        $finish;
    end

endmodule
