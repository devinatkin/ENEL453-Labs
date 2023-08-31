module tb_top_level;

  // Define the clock signal
  reg CLK = 0;

  // Clock Generation
  always begin
    #5 CLK = ~CLK;
  end

  // Define the reset signal
  reg RESET = 0;

  // Define the switches signal
  reg [15:0] SWITCHES;

  // Define the LEDs wire
  wire [15:0] LEDS;

  // Instantiate the top_level module
  top_level top_level (
    .CLK(CLK),
    .RESET(RESET),
    .SWITCHES(SWITCHES),
    .LEDS(LEDS)
  );

  initial begin
    // Declare a 16-bit number to be used for testing
    static reg [15:0] test_number = 16'h1234;

    // Initialize the signals
    RESET = 1;
    SWITCHES = 0;

    // Release the reset and load the test number into the switches
    #20 RESET = 0;
    SWITCHES = test_number;

    // Wait for enough cycles to allow the top-level module to process the input and update the LEDs
    // Assuming around 50 clock cycles to cover all states (LOAD_DATA, CALC_CRC, SHIFT_OUT_CRC, UPDATE_LEDS)
    #1000;

    // Print the input and output side by side
    $display("Input (Switches): %h\tOutput (LEDs): %h", SWITCHES, LEDS);

    // Finish the simulation
    $finish;
  end

  always@(LEDS)begin
    $display("Input (Switches): %h\tOutput (LEDs): %h", SWITCHES, LEDS);

  end

endmodule
