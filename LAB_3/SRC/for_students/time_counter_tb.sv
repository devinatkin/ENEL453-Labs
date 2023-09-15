`timescale 1ns / 1ps

module tb_time_counter;

  logic clk_1khz;
  logic clk_high_speed;
  logic rst_n;
  logic up_down;
  logic en;
  logic inc_sec;
  logic inc_min;
  wire [9:0] time_ms;
  wire [5:0] time_sec;
  wire [5:0] time_min;

  // Instantiate the time_counter module
  time_counter uut (
    .clk_1khz(clk_1khz),
    .clk_high_speed(clk_high_speed),
    .rst_n(rst_n),
    .up_down(up_down),
    .en(en),
    .inc_sec(inc_sec),
    .inc_min(inc_min),
    .time_ms(time_ms),
    .time_sec(time_sec),
    .time_min(time_min)
  );

  // Clock generation for clk_high_speed
  always begin
    #5 clk_high_speed = ~clk_high_speed;
  end

  // Clock generation for clk_1khz
  always begin
    #500 clk_1khz = ~clk_1khz;
  end

  // Testbench logic
  initial begin
    // Initialize
    clk_high_speed = 0;
    clk_1khz = 0;
    rst_n = 0;
    up_down = 1;
    en = 0;
    inc_sec = 0;
    inc_min = 0;

    #10 rst_n = 1;  // De-assert reset
    #10 en = 1;    // Enable counting

    // DUT is counting (Run for 5 minutes printing the time every second)
    do begin
      #1000000 
      $display("Time: %d:%d:%d", time_min, time_sec, time_ms);
    end while (time_min < 5);
    if (time_min != 5) $error("Time counter did not count for 5 minutes");
    if (time_sec != 0) $error("Time counter did not count for 5 minutes");
    if (time_ms != 0) $error("Time counter did not count for 5 minutes");

    up_down = 0;  // Count down
    // DUT is counting down (Run for 3 minutes printing the time every second)
    do begin
      #1000000 
      $display("Time: %d:%d:%d", time_min, time_sec, time_ms);
    end while (time_min > 1);
    if (time_min != 1) $error("Time counter did not count for 3 minutes and 1 second");
    if (time_sec != 59) $error("Time counter did not count for 3 minutes and 1 second");
    if (time_ms != 0) $error("Time counter did not count for 3 minutes and 1 second");
    
    // Stop counting
    en = 0;
    #1000000 $display("Time: %d:%d:%d", time_min, time_sec, time_ms);
    if (time_min != 1) $error("Time counter did not stop counting");
    if (time_sec != 59) $error("Time counter did not stop counting");
    if (time_ms != 0) $error("Time counter did not stop counting");

    // Decrement seconds
    inc_sec = 1;
    #1000000 $display("Time: %d:%d:%d", time_min, time_sec, time_ms);
    if (time_min != 1) $error("Time counter did not decrement seconds");
    if (time_sec != 58) $error("Time counter did not decrement seconds");
    if (time_ms != 0) $error("Time counter did not decrement seconds");

    inc_sec = 0;
    
    // Decrement minutes
    inc_min = 1;
    #1000000 $display("Time: %d:%d:%d", time_min, time_sec, time_ms);
    if (time_min != 0) $error("Time counter did not decrement minutes");
    if (time_sec != 58) $error("Time counter did not decrement minutes");
    if (time_ms != 0) $error("Time counter did not decrement minutes");

    inc_min = 0;

    // Increment seconds
    up_down = 1;
    inc_sec = 1;
    #1000000 $display("Time: %d:%d:%d", time_min, time_sec, time_ms);
    if (time_min != 0) $error("Time counter did not increment seconds");
    if (time_sec != 59) $error("Time counter did not increment seconds");
    if (time_ms != 0) $error("Time counter did not increment seconds");

    inc_sec = 0;

    // Increment minutes
    inc_min = 1;
    #1000000 $display("Time: %d:%d:%d", time_min, time_sec, time_ms);
    if (time_min != 1) $error("Time counter did not increment minutes");
    if (time_sec != 59) $error("Time counter did not increment minutes");
    if (time_ms != 0) $error("Time counter did not increment minutes");

    inc_min = 0;

    // Reset
    rst_n = 0;
    #10 rst_n = 1;  // De-assert reset
    #1000000 $display("Time: %d:%d:%d", time_min, time_sec, time_ms);
    if (time_min != 0) $error("Time counter did not reset");
    if (time_sec != 0) $error("Time counter did not reset");
    if (time_ms != 0) $error("Time counter did not reset");

    // Finish the simulation
    $finish;
  end

endmodule
