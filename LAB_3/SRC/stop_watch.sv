`timescale 1ns / 1ps

module stopwatch (
  input logic clk,      // Clock input 100Mhz
  input logic clk1k,  // Clock input 1Khz
  input logic rst_n,    // Active low asynchronous reset
  input logic en,       // Enable the stopwatch
  input logic start,    // Start the stopwatch
  input logic stop,     // Stop the stopwatch
  input logic reset,    // Reset the stopwatch
  output logic [5:0] minutes, // Minutes
  output logic [5:0] seconds // Seconds
);

  logic running; // Flag to indicate if the stopwatch is running
  logic [9:0] time_ms;
  logic [5:0] time_sec;
  logic [5:0] time_min;
  assign minutes = time_min;
  assign seconds = time_sec;
    time_counter timer (
    .clk_1khz(clk1k),
    .clk_high_speed(clk),
    .rst_n(rst_n && !reset),
    .up_down(1'b1),
    .en(en && running),
    .inc_sec(1'b0),
    .inc_min(1'b0),
    .time_ms(time_ms),
    .time_sec(time_sec),
    .time_min(time_min)
  );

  always @(posedge clk) begin
    if (~rst_n) begin
      // Asynchronous reset
      running <= 1'b0;
    end else if (reset) begin
      // Soft Reset the stopwatch
      running <= 1'b0;
    end else if (start) begin
      // Start the stopwatch
      running <= 1'b1;
    end else if (stop) begin
      // Stop the stopwatch
      running <= 1'b0;
    end
  end

endmodule
