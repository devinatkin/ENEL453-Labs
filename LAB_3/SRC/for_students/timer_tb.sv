`timescale 1ns / 1ps

module tb_timer;

  logic clk;
  logic clk1k;
  logic rst_n;
  logic en;
  logic start;
  logic stop;
  logic reset;
  logic inc_min;
  logic inc_sec;
  wire [5:0] minutes;
  wire [5:0] seconds;
  wire blink;

  // Instantiate the device under test (DUT)
  timer uut (
    .clk(clk),
    .clk1k(clk1k),
    .rst_n(rst_n),
    .en(en),
    .start(start),
    .stop(stop),
    .reset(reset),
    .inc_min(inc_min),
    .inc_sec(inc_sec),
    .minutes(minutes),
    .seconds(seconds),
    .blink(blink)
  );

    // Clock generation for 100MHz
    always begin
        #5 clk = 1;
        #5 clk = 0;
    end

    // Clock generation for 1KHz
    always begin
        #500000 clk1k = 1;
        #500000 clk1k = 0;
    end


  // Test procedure
  initial begin
    // Initialize signals
    clk = 0;
    clk1k = 0;
    rst_n = 0;
    en = 0;
    start = 0;
    stop = 0;
    reset = 0;
    inc_min = 0;
    inc_sec = 0;

    // Apply reset
    rst_n = 0;
    #10 rst_n = 1;

    // Check if module is properly reset
    if (minutes !== 0 || seconds !== 0 || blink !== 0) begin
      $display("Error: Module not properly reset!");
      $finish;
    end

    // Set 3-second timer
    inc_sec = 1;
    #10 inc_sec = 0;
    inc_sec = 1;
    #10 inc_sec = 0;
    inc_sec = 1;
    #10 inc_sec = 0;
    en = 1;
    #10 start = 1;
    #10 start = 0;

    // Wait for 3 seconds + some margin
    #3050000;

    // Check if timer counted down to zero and blink is toggled
    if (minutes !== 0 || seconds !== 0 || blink !== 1) begin
      $display("Error: Timer did not count down properly!");
      $finish;
    end else begin
      $display("Success: Timer counted down to zero and blink is toggled!");
    end

    $finish;
  end

endmodule
