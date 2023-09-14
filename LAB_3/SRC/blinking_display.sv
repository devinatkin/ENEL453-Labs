module blinking_display (
    input wire [3:0] anode_in,  // 4-bit anode input
    input wire clk,             // System clock
    input wire rst_n,           // Active-low reset
    input wire blink,           // Blink control bit
    input wire clk_1hz,         // 1Hz clock
    output reg [3:0] anode_out  // 4-bit anode output
);

  reg blink_state;              // State to hold whether to blink or not
  reg clk_1hz_last = 1'b0;      // Last state of the 1Hz clock

  // Synchronous logic for blinking control and anode output
  always_ff @(posedge clk) begin
    if (!rst_n) begin
      blink_state <= 1'b0;
      anode_out <= 4'b1111; // Initialize to all digits off
    end else begin
      // Detect rising edge of 1Hz clock to toggle blink_state
      if (clk_1hz && !clk_1hz_last) 
        blink_state <= ~blink_state;
        
      clk_1hz_last <= clk_1hz;
      
      // Control anode output
      if (blink && blink_state)
        anode_out <= 4'b1111;  // All digits off if blink is 1 and blink_state is 1
      else
        anode_out <= anode_in; // Display input value or pass through depending on blink
    end
  end

endmodule
