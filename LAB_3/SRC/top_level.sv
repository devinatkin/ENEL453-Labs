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
    
    wire blink;

    wire [5:0] minutes;
    wire [5:0] seconds;

    wire start;
    wire stop;
    wire softrst;
    wire inc_min;
    wire inc_sec;

    wire [3:0] anode_raw;
    

    wire rst_n;
    assign rst_n = !rst;
    // Instantiate the clock divider
    clock_divider clock_divider_inst(
        .clk_100MHz(clk),
        .rst_n(!rst),
        .clk_1Hz(clk_1Hz),
        .clk_1kHz(clk_1kHz)
    );

    blinking_display uut (
        .anode_in(anode_raw),
        .clk(clk),
        .rst_n(rst_n),
        .blink(blink),
        .clk_1hz(clk_1Hz),
        .anode_out(an)
    );

    display_driver display_driver_inst(
        .clk(clk),
        .rst_n(rst_n),
        .minutes(minutes),
        .seconds(seconds),
        .seg(seg),
        .an(anode_raw)
    );

    stopwatch_timer_wrapper stopwatch_timer_wrapper_inst(
        .clk(clk),
        .clk_1kHz(clk_1kHz),
        .rst_n(rst_n),
        .mode_sw(mode_sw),
        .start(start),
        .stop(stop),
        .reset(reset),
        .inc_min(inc_min),
        .inc_sec(inc_sec),
        .minutes(minutes),
        .seconds(seconds),
        .blink(blink)
    );

    debounce_wrapper debounce_wrapper (
        .clk(clk), 
        .rst_n(rst_n), 
        .buttons({start_btn, stop_btn, softrst_btn, inc_min_btn, inc_sec_btn}), 
        .results({start, stop, softrst, inc_min, inc_sec})
    );

endmodule