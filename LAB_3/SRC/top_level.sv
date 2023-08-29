`timescale 1ns / 1ps

module top(
        input wire clk,
        input wire rst,
        input wire start_btn,
        input wire stop_btn,
        input wire softrst_btn,
        input wire inc_min_btn,
        input wire inc_sec_btn,
        input wire mode_sw,
        output wire [6:0] seg,
        output wire [3:0] an
    );

    wire clk_1Hz;
    wire clk_1kHz;
    
    wire [5:0] minutes_sw;
    wire [5:0] seconds_sw;
    wire blink;

    wire [5:0] minutes_tm;
    wire [5:0] seconds_tm;

    wire [5:0] minutes;
    wire [5:0] seconds;

    wire start;
    wire stop;
    wire softrst;
    wire inc_min;
    wire inc_sec;

    // Instantiate the clock divider
    clock_divider clock_divider_inst(
        .clk_100MHz(clk),
        .rst_n(!rst),
        .clk_1Hz(clk_1Hz),
        .clk_1kHz(clk_1kHz)
    );

    display_driver display_driver_inst(
        .clk(clk),
        .clk100k(clk_1kHz),
        .clk1s(clk_1Hz),
        .rst_n(!rst),
        .minutes(minutes),
        .seconds(seconds),
        .blink(blink && !mode_sw),
        .seg(seg),
        .an(an)
    );

    stopwatch my_stopwatch (
        .clk(clk),
        .clk1k(clk_1kHz),
        .rst_n(rst_n),
        .en(mode_sw),
        .start(start),
        .stop(stop),
        .reset(reset),
        .minutes(minutes_sw),
        .seconds(seconds_sw)
    );

    timer my_timer (
        .clk(clk),
        .clk1k(clk_1kHz),
        .rst_n(rst_n),
        .en(!mode_sw),
        .start(start),
        .stop(stop),
        .reset(reset),
        .inc_min(inc_min),
        .inc_sec(inc_sec),
        .minutes(minutes_tm),
        .seconds(seconds_tm),
        .blink(blink)
    );

    mux_2to1 #(12) mux_2to1_inst(
        .a({minutes_sw, seconds_sw}),
        .b({minutes_tm, seconds_tm}),
        .sel(!mode_sw),
        .y({minutes, seconds})
    );

    debounce #(50000000,10) debounce_start_btn(
        .clk(clk), 
        .button(start_btn),
        .reset_n(rst_n), 
        .result(start)
    );

    debounce #(50000000,10) debounce_stop_btn(
        .clk(clk), 
        .button(stop_btn), 
        .reset_n(rst_n), 
        .result(stop)
    );

    debounce #(50000000,10) debounce_softrst_btn(
        .clk(clk), 
        .button(softrst_btn), 
        .reset_n(rst_n), 
        .result(softrst)
    );

    debounce #(50000000,10) debounce_inc_min_btn(
        .clk(clk), 
        .button(inc_min_btn), 
        .reset_n(rst_n), 
        .result(inc_min)
    );

    debounce #(50000000,10) debounce_inc_sec_btn(
        .clk(clk), 
        .button(inc_sec_btn), 
        .reset_n(rst_n), 
        .result(inc_sec)
    );

endmodule