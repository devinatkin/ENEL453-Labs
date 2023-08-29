module time_counter (
  input wire clk_1khz,       // 1 kHz Clock for millisecond counting
  input wire clk_high_speed, // High-speed clock for general operation
  input wire rst_n,          // Asynchronous reset (active low)
  input wire up_down,        // Up/Down control: 1 for counting up, 0 for counting down
  input wire en,             // Enable signal
  input wire inc_sec,        // Increment/Decrement 1 second
  input wire inc_min,        // Increment/Decrement 1 minute
  output reg [9:0] time_ms, // Time in milliseconds (Max 1 second, will rollover to 0 after 1 second)
  output reg [5:0] time_sec, // Time in seconds (Max 63 seconds, will rollover to 0 after 60 seconds)
  output reg [5:0] time_min  // Time in minutes (Max 63 minutes, will rollover to 0 after 60 minutes)
);

reg clk_1khz_prev = 0;   // Store previous value of clk_1khz for edge detection
reg inc_sec_prev = 0;    // Store previous value of inc_sec for edge detection
reg inc_min_prev = 0;    // Store previous value of inc_min for edge detection

always @(posedge clk_high_speed) begin
    if (~rst_n) begin
      // Asynchronously reset the time counters and previous value registers
      time_ms <= 32'h0;
      time_sec <= 6'h0;
      time_min <= 6'h0;
      clk_1khz_prev <= 0;
      inc_sec_prev <= 0;
      inc_min_prev <= 0;
    end else begin

        // Sample the 1kHz clock at the rising edge of the high-speed clock
        if (clk_1khz && ~clk_1khz_prev && en) begin
            // Count milliseconds on a positive edge of the 1kHz clock
            if (up_down) begin
                time_ms <= time_ms + 1;
                if (time_ms >= 10'h3E8) begin
                    time_ms <= 0;
                    time_sec <= time_sec + 1;
                end
                            // Check for 1 minute boundary and act accordingly
                if (time_sec >= 6'h3C) begin
                    time_sec <= 0;
                    time_min <= time_min + 1;
                end

                // Increment or decrement by 1 second if inc_sec is toggled
                if (inc_sec && ~inc_sec_prev) begin
                    time_sec <= time_sec + 1;
                end

                // Increment or decrement by 1 minute if inc_min is toggled
                if (inc_min && ~inc_min_prev) begin
                    time_min <= time_min + 1;
                end
            end else begin
                time_ms <= time_ms - 1;
                if (time_ms <= 10'h0) begin
                    time_ms <= 10'h3E8;
                    time_sec <= time_sec - 1;
                end
                if (time_sec <= 6'h0) begin
                    time_sec <= 6'h3C;
                    time_min <= time_min - 1;
                end

                // Increment or decrement by 1 second if inc_sec is toggled
                if (inc_sec && ~inc_sec_prev) begin
                    time_sec <= time_sec - 1;
                end

                // Increment or decrement by 1 minute if inc_min is toggled
                if (inc_min && ~inc_min_prev) begin
                    time_min <= time_min - 1;
                end
            end
        end
        // Update previous value for edge detection
        clk_1khz_prev <= clk_1khz;

        // Update previous value for edge detection
        inc_sec_prev <= inc_sec;

        // Update previous value for edge detection
        inc_min_prev <= inc_min;
    end
end
endmodule
