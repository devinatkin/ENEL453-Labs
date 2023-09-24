//System Verilog Module for Calculating a 16-bit CRC
//Author: Devin Atkin
//Date: 17/8/2023

// CRC Based on the CRC videos by Ben Eater on YouTube
// https://www.youtube.com/watch?v=sNkERQlK8j8 (Explanation of the CRC Hardware Design)
// https://www.youtube.com/watch?v=izG7qT0EpBw (Explanation of the CRC Algorithm)

// Output Verified using https://crccalc.com/
// Implementing CRC-16 CDMA2000

// Inputs 
// CLK
// RESET_N
// DATA_IN
// READ_MODE

// Outputs
// CRC_OUT

module CRC_CALC(
    input CLK,
    input RESET_N,
    input DATA_IN,
    input READ_MODE,
    output reg CRC_OUT
    );
    
    // CRC Register
    logic [15:0] CRC_REG;
    
    // CRC Polynomial (XMODEM) 16'h1021
    
    // CRC Calculation
    always_ff @(posedge CLK) begin
        if (!RESET_N) begin                                         // Active Low Synchronous Reset
            CRC_REG <= 16'hFFFF;                                    // Reset the CRC Register to 0
            CRC_OUT <= 1'b0;                                        // Reset the CRC Output to 0
        end else if (READ_MODE) begin                               // If the CRC is in Read Mode, Output the CRC Register, One Bit at a Time

            CRC_OUT <= CRC_REG[15];                                 // Output the MSB of the CRC Register
            CRC_REG <= {CRC_REG[14:0], 1'b1};                       // Shift the CRC Register Left by One Bit
            

        end else begin                                              // If the CRC is in Write Mode, Calculate the CRC Register while Shifting in the Data

            // It is important to note that this code can be made more compact by using a for loop,
            // however, you have to remember this generates the same hardware. The for loop is just
            // a more compact way of writing the code. This is why I have chosen to write it out
            // in full, so that it is easier to understand what is going on and illustrate that
            // HDL is just a way of describing hardware.

            // CDMA2000 CRC-16 Polynomial 16'hC867 as opposed to the XMODEM CRC-16 Polynomial 16'h1021

            CRC_REG[15] <= CRC_REG[14] ^ CRC_REG[15];
            CRC_REG[14] <= CRC_REG[13] ^ CRC_REG[15];
            CRC_REG[13] <= CRC_REG[12];
            CRC_REG[12] <= CRC_REG[11];               // XOR the MSB of the CRC Register with the LSB of the CRC Register and Shift it into the CRC Register
            CRC_REG[11] <= CRC_REG[10] ^ CRC_REG[15];
            CRC_REG[10] <= CRC_REG[9];
            CRC_REG[9] <= CRC_REG[8];
            CRC_REG[8] <= CRC_REG[7];
            CRC_REG[7] <= CRC_REG[6];
            CRC_REG[6] <= CRC_REG[5] ^ CRC_REG[15];
            CRC_REG[5] <= CRC_REG[4] ^ CRC_REG[15];                 // XOR the MSB of the CRC Register with the 4th Bit of the CRC Register and Shift it into the CRC Register
            CRC_REG[4] <= CRC_REG[3];
            CRC_REG[3] <= CRC_REG[2];
            CRC_REG[2] <= CRC_REG[1] ^ CRC_REG[15];
            CRC_REG[1] <= CRC_REG[0] ^ CRC_REG[15];
            CRC_REG[0] <= CRC_REG[15] ^ DATA_IN;                     // XOR the MSB of the CRC Register with the Data In and Shift it into the CRC Register
        end
    end
    


    
endmodule
