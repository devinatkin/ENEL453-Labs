module tb_CRC_CALC;

  // Define the clock signal
  logic CLK = 0;

  // Clock Generation
  always begin
    #5 CLK = ~CLK;
  end

  // Define the reset signal
  logic RESET_N = 0;

  // Define the data input signal
  logic DATA_IN = 0;

  // Define the read mode signal
  logic READ_MODE = 0;

  // Define the CRC output wire
  logic CRC_OUT;

  // Instantiate the CRC_CALC module
  CRC_CALC uut (
    .CLK(CLK),
    .RESET_N(RESET_N),
    .DATA_IN(DATA_IN),
    .READ_MODE(READ_MODE),
    .CRC_OUT(CRC_OUT)
  );

  initial begin
    // Declare a string to be used for CRC calculation
    static string message = "aa";

    // Declare a variable to hold the calculated CRC
    logic [15:0] calculated_crc;

    // Initialize the signals
    
    #12.5 RESET_N = 1;

    // Shift in the string one bit at a time
    for (int i = 0; i < message.len(); i++) begin
      automatic byte b = message[i];
      for (int j = 7; j >= 0; j--) begin
        DATA_IN = b[j];
        #10; // Wait for one clock cycle
      end
    end

    // Shift in 16 zeros to complete the CRC calculation
    for (int i = 0; i < 16; i++) begin
      DATA_IN = 0;
      #10; // Wait for one clock cycle
    end

    // Shift out the calculated CRC
    READ_MODE = 1;
    for (int i = 15; i >= 0; i--) begin
        #10; // Wait for one clock cycle
        calculated_crc[i] = CRC_OUT;
      
    end

    // Print the original message and the calculated CRC value in hex
    $display("Original Message: %s", message);
    $display("Calculated CRC (Hex): %h", calculated_crc);

    // Finish the simulation
    $finish;
  end

endmodule
