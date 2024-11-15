`timescale 1ns / 1ps

// This is the top level module for implementing just the timer module. 
// You need to go in and add stop watch functionality to the design.
// Hint * Reuse as much existing code as possible. The timer module was written with the stop watch in mind.

module top(
        input logic clk,                 // 100 MHz clock
        input logic rst,                 // Reset button (Tied to Center Button)
        input logic start_btn,           // Start button (Tied to Up Button)
        input logic stop_btn,            // Stop button (Tied to left Button)
        input logic softrst_sw,          // Software reset switch (Tied to SW1)         
        input logic inc_min_btn,         // Increment minutes button (Tied to down Button)
        input logic inc_sec_btn,         // Increment seconds button (Tied to right Button)
        input logic inc_sw,              // Increment switch (Tied to SW2, Determines if buttons increment or decrement the timer)
        output logic [6:0] seg,          // 7-segment display output logic (Tied to the 7-segment display, active low)
        output logic [3:0] an            // 4-bit anode output logic (Tied to the 7-segment display, active low)
    );

    logic clk_1Hz;                       // 1 Hz clock
    logic clk_1kHz;                      // 1 kHz clock
    
    logic blink;                         // Blink signal for blinking the 7-segment display

    logic [5:0] minutes;                 // Minutes counter
    logic [5:0] seconds;                 // Seconds counter

    logic start;                         // Start signal
    logic stop;                          // Stop signal
    logic softrst;                       // Soft reset signal
    logic inc_min;                       // Increment minutes signal
    logic inc_sec;                       // Increment seconds signal

    logic [3:0] anode_raw;               // 4-bit anode output logic (anode values before the blinking logic)
    

    logic rst_n;                        // Inverted reset signal
    assign rst_n = !rst;                // Invert the reset signal

    // Instantiate the clock divider
    clock_divider clock_divider_inst(   // Clock divider instance (Generates 1 Hz and 1 kHz clocks)
        .clk_100MHz(clk),               // 100 MHz clock input
        .rst_n(rst_n),                  // Inverted reset signal
        .clk_1Hz(clk_1Hz),              // 1 Hz clock output
        .clk_1kHz(clk_1kHz)             // 1 kHz clock output
    );

    blinking_display blink_disp (       // Blinking display instance (Blinks the 7-segment display)
        .anode_in(anode_raw),           // 4-bit anode input logic (anode values before the blinking logic)
        .clk(clk),                      // 100 MHz clock
        .rst_n(rst_n),                  // Inverted reset signal
        .blink(blink),                  // Blink signal
        .clk_1hz(clk_1Hz),              // 1 Hz clock
        .anode_out(an)                  // 4-bit anode output logic (anode values after the blinking logic)
    );

    display_driver display_driver_inst( // Display driver instance (Converts the minutes and seconds to 7-segment display values)
        .clk(clk),                      // 100 MHz clock
        .rst_n(rst_n),                  // Inverted reset signal
        .minutes(minutes),              // Minutes counter
        .seconds(seconds),              // Seconds counter
        .seg(seg),                      // 7-segment display output logic (active low)
        .an(anode_raw)                  // 4-bit anode output logic (anode values before the blinking logic)
    );

    timer timer_module (                // Timer module instance (Counts the minutes and seconds)
        .clk(clk),                      // 100 MHz clock
        .clk1k(clk_1kHz),               // 1 kHz clock (Used to count ms)
        .rst_n(rst_n),                  // Inverted reset signal
        .en(1'b1),                      // Enable signal (Always enabled, but could be used to disable the timer)
        .start(start),                  // Start signal
        .stop(stop),                    // Stop signal
        .reset(softrst),                // Reset signal
        .inc_min(inc_min),              // Increment minutes signal
        .inc_sec(inc_sec),              // Increment seconds signal
        .inc(inc_sw),                   // Increment switch (Determines if buttons increment or decrement the timer)
        .minutes(minutes),              // Minutes counter
        .seconds(seconds),              // Seconds counter
        .blink(blink)                   // Blink signal
    );

    debounce_wrapper debounce_wrapper ( // Debounce wrapper instance (Debounces the buttons and software reset switch)
        .clk(clk),                      // 100 MHz clock
        .rst_n(rst_n),                  // Inverted reset signal
        .buttons({start_btn, stop_btn, softrst_sw, inc_min_btn, inc_sec_btn}),  // Button inputs
        .results({start, stop, softrst, inc_min, inc_sec})                      // Debounced button outputs
    );

endmodule