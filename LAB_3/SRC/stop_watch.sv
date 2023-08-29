module stopwatch (
  input wire clk,      // Clock input
  input wire rst_n,    // Active low asynchronous reset
  input wire start,    // Start the stopwatch
  input wire stop,     // Stop the stopwatch
  input wire reset,    // Reset the stopwatch
  output reg [31:0] count // 32-bit stopwatch count
);

  reg running; // Flag to indicate if the stopwatch is running

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      // Asynchronous reset
      running <= 1'b0;
      count <= 32'b0;
    end else if (reset) begin
      // Reset the stopwatch
      running <= 1'b0;
      count <= 32'b0;
    end else if (start) begin
      // Start the stopwatch
      running <= 1'b1;
    end else if (stop) begin
      // Stop the stopwatch
      running <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if (running) begin
      // Increment count if running
      count <= count + 1;
    end
  end

endmodule
