`timescale 1ns / 1ps

function void print_leds_to_file(input bit [15:0] LEDS, input integer file_descriptor);
    integer i;
    string led_values;

    // Check if the file is open
    if (file_descriptor == 0) begin
        $display("Error: File is not open!");
        return;
    end

    // Initialize the led_values string
    led_values = "";
    // Iterate through the LEDS array and append the binary values to the led_values string
    for (i = 0; i < 16; i++) begin
        led_values = {led_values, $sformatf("%b", LEDS[i])};
    end
    $timeformat(-3,10,"");
    $fwrite(file_descriptor, "%0t %s\n", $realtime, led_values);
    
endfunction

module tb_top_level;

  // Parameters
  localparam CLK_PERIOD = 10; // 100 MHz clock
  localparam SWITCHES_INCREMENT_INTERVAL = 50000000; // delay 
  localparam NUM_RANDOM_SWITCHES = 1000; // Number of random switch values

  // Signals
  logic clk;
  logic reset;
  logic [15:0] switches;
  logic [15:0] led; // Change to 16 bits to match the top_level module
  integer i;
  integer file_descriptor;

  // Instantiate the top_level module
  top_level dut (
    .clk(clk),
    .reset(reset),
    .switches(switches),
    .led(led) // Change to 16 bits to match the top_level module
  );

  // Clock Generation
  always # (CLK_PERIOD / 2) clk = ~clk;

  // Generate the test output data
  always@(led) begin
      //$display("led = %b", led);
      print_leds_to_file(led, file_descriptor); // 16-bit LED value
  end

  // Test Procedure
  initial begin
    // Initialize signals
    file_descriptor = $fopen("leds.txt", "w");
    clk = 0;
    reset = 0;
    switches = 16'h0000;

    #2; // Small delay to move transitions away from clk edges

    // Apply reset
    #CLK_PERIOD reset = 1;
    #CLK_PERIOD;
    #CLK_PERIOD;
    
    #CLK_PERIOD reset = 0;

    // Wait for 10 seconds
    #10000000000;

    // Close the output file
    $fclose(file_descriptor);
    // Finish the simulation
    $finish;
  end

endmodule
