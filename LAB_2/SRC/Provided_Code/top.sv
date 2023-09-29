module top_level (                      // The top level module for the PWM example
    input clk,                          // The clock input
    input rst,                          // The reset input
    input [15:0] switches,              // The switches input
    output logic led                    // The LED output
);

localparam bit_width = 16;              // The width of the PWM counter
localparam max_value = 2**bit_width-1;  // The maximum value of the PWM counter   
logic rst_n;                            // The inverted reset signal
logic [bit_width-1:0] duty;             // The duty cycle of the PWM
logic pwm_out;                          // The PWM output

// Instantiate the PWM module
  pwm_module #(
    .bit_width(bit_width)
  ) dut (
    .clk(clk),
    .rst_n(rst_n),
    .duty(duty),
    .max_value(max_value), 
    .pwm_out(pwm_out)
  );

assign rst_n = ~rst;                    // Invert the reset signal
assign duty = switches;                 // Assign the switches to the duty cycle
assign led = pwm_out;                   // Assign the PWM output to the LED
endmodule
