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
  localparam SWITCHES_INCREMENT_INTERVAL = 5000; // delay 
  localparam NUM_RANDOM_SWITCHES = 100; // Number of random switch values

  // Signals
  logic clk;
  logic rst;
  logic [15:0] switches;
  logic led;
  integer i;
  integer file_descriptor;
  // Instantiate the top_level module
  top_level dut (
    .clk(clk),
    .rst(rst),
    .switches(switches),
    .led(led)
  );



  // Clock Generation
 always # (CLK_PERIOD / 2) clk = ~clk;

    // Generate the test output data
    always@(led) begin
        
        $display("led state = %b, at time: %0d", led, $time);
        print_leds_to_file({led,15'b000000000000000}, file_descriptor);    // 1 bit LED + 15 bits of padding   (Hint: use the print_leds_to_file function)
       

    end

  // Test Procedure
  initial begin
    
    // Initialize signals
    file_descriptor = $fopen("leds.txt", "w");
    clk = 0;
    rst = 0;
    switches = 16'h0000;

    #2; // Small delay to move transitions away from clock edges

    // Apply reset
    #CLK_PERIOD rst = 1;
    #CLK_PERIOD rst = 0;

    // Generate 100 random switch values
    
    for (i = 0; i < NUM_RANDOM_SWITCHES; i = i + 1) begin
      #SWITCHES_INCREMENT_INTERVAL;
      switches = $random & 16'hFFFF; // Take 16 least significant bits of the random value
    end

    // Close the output file
     $fclose(file_descriptor);
    // Finish the simulation
    $finish;
  end

endmodule
