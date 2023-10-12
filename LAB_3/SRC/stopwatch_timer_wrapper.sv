`timescale 1ns / 1ps

module stopwatch_timer_wrapper (
    input logic clk,
    input logic clk_1kHz,
    input logic rst_n,
    input logic mode_sw,                // mode switch for stopwatch or timer
    input logic start,
    input logic stop,
    input logic reset,
    input logic inc_min,
    input logic inc_sec,
    input logic inc_sw,
    output logic [5:0] minutes,
    output logic [5:0] seconds,
    output logic blink
);

    logic [5:0] minutes_sw;
    logic [5:0] seconds_sw;
    logic [5:0] minutes_tm;
    logic [5:0] seconds_tm;

    logic blnk;
    assign blink = blnk && !mode_sw;
    // Instantiate the stopwatch module
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

    timer timer_module (                // Timer module instance (Counts the minutes and seconds)
        .clk(clk),                      // 100 MHz clock
        .clk1k(clk_1kHz),               // 1 kHz clock (Used to count ms)
        .rst_n(rst_n),                  // Inverted reset signal
        .en(!mode_sw),                  // Enable signal (This is enabled when stopwatch isn't)
        .start(start),                  // Start signal
        .stop(stop),                    // Stop signal
        .reset(reset),                  // Reset signal
        .inc_min(inc_min),              // Increment minutes signal
        .inc_sec(inc_sec),              // Increment seconds signal
        .inc(inc_sw),                   // Increment switch (Determines if buttons increment or decrement the timer)
        .minutes(minutes_tm),           // Minutes counter
        .seconds(seconds_tm),              // Seconds counter
        .blink(blink)                   // Blink signal
    );

    // Instantiate the 2-to-1 multiplexer
    mux_2to1 #(12) mux_2to1_inst (
        .a({minutes_sw, seconds_sw}),
        .b({minutes_tm, seconds_tm}),
        .sel(!mode_sw),
        .y({minutes, seconds})
    );

endmodule
