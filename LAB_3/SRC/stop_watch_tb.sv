`timescale 1ns / 1ps

module stop_watch_tb;

  logic clk;
  logic clk1k;
  logic rst_n;
  logic en;
  logic start;
  logic stop;
  logic reset;
  wire [5:0] minutes;
  wire [5:0] seconds;

  // Instantiate the DUT (Device Under Test)
  stopwatch my_stopwatch (
    .clk(clk),
    .clk1k(clk1k),
    .rst_n(rst_n),
    .en(en),
    .start(start),
    .stop(stop),
    .reset(reset),
    .minutes(minutes),
    .seconds(seconds)
  );

  // Clock generation for 100 MHz clock
  always begin
    #5 clk = ~clk;
  end

  // Clock generation for 1 kHz clock
  always begin
    #500000 clk1k = ~clk1k;
  end

  initial begin
    // Initialize all inputs
    $display("Starting simulation...");
    clk = 0;
    clk1k = 0;
    rst_n = 0;
    en = 0;
    start = 0;
    stop = 0;
    reset = 0;

    // Monitor statements for observing changes
    $monitor("At time %t, Minutes: %d, Seconds: %d", $time, minutes, seconds);

    // Apply synchronous reset
    #10 rst_n = 1;
    #10 rst_n = 0;
    #500 rst_n = 1;

    // Test case 1: Reset the stopwatch
    reset = 1;
    #20 reset = 0;
    // Assertion to check if reset worked
    if (minutes !== 6'b0 || seconds !== 6'b0) $error("Reset failed!");

    // Test case 2: Start the stopwatch
    en = 1;
    start = 1;
    #20 start = 0;

    $display("Starting stopwatch...");
    // Let it run for a minute of simulated time
    do begin
      #1000000;
    end while (seconds !== 6'd2);

    // Test case 3: Stop the stopwatch
    stop = 1;
    #20 stop = 0;

    $display("Stopping stopwatch...");


    // Finish the simulation
    $finish;
  end
endmodule
