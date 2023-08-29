module tb_time_counter;

  reg clk_1khz;
  reg clk_high_speed;
  reg rst_n;
  reg up_down;
  reg en;
  reg inc_sec;
  reg inc_min;
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

    // Test: Increment milliseconds
    #2000;
    
    // Test: Decrement milliseconds
    up_down = 0;
    #2000;
    
    // Test: Increment seconds
    up_down = 1;
    inc_sec = 1;
    #10 inc_sec = 0;
    #10 inc_sec = 1;
    
    // Test: Decrement seconds
    up_down = 0;
    #10 inc_sec = 0;
    #10 inc_sec = 1;

    // Test: Increment minutes
    up_down = 1;
    inc_min = 1;
    #10 inc_min = 0;
    #10 inc_min = 1;

    // Test: Decrement minutes
    up_down = 0;
    #10 inc_min = 0;
    #10 inc_min = 1;
    
    // Finish the simulation
    $finish;
  end

endmodule
