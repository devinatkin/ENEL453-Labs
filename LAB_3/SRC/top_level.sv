`timescale 1ns / 1ps

module top(
        input logic clk,                 // 100 MHz clock
        input logic rst,                 // Reset button (Tied to Center Button)
        input logic start_btn,           // Start button (Tied to Up Button)
        input logic stop_btn,            // Stop button (Tied to left Button)
        input logic softrst_sw,          // Software reset switch (Tied to SW1)         
        input logic inc_min_btn,         // Increment minutes button (Tied to down Button)
        input logic inc_sec_btn,         // Increment seconds button (Tied to right Button)
        input logic inc_sw,              // Increment switch (Tied to SW2, Determines if buttons increment or decrement the timer)
        input logic mode_sw,             // Mode switch (Tied to SW0, Determines if the timer counts up or down)
        output logic [6:0] seg,          // 7-segment display output logic (Tied to the 7-segment display, active low)
        output logic [3:0] an            // 4-bit anode output logic (Tied to the 7-segment display, active low)
    );
    logic clk_1Hz;
    logic clk_1kHz;
    
    logic blink;

    logic [5:0] minutes;
    logic [5:0] seconds;

    logic start;
    logic stop;
    logic softrst;
    logic inc_min;
    logic inc_sec;

    logic [3:0] anode_raw;
    

    logic rst_n;
    assign rst_n = !rst;
    // Instantiate the clock divider
    clock_divider clock_divider_inst(
        .clk_100MHz(clk),
        .rst_n(rst_n ),
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
        .reset(softrst_sw),
        .inc_min(inc_min),
        .inc_sec(inc_sec),
        .inc_sw(inc_sw),
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