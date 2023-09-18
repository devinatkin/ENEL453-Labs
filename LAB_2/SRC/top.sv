module top_level (
    input clk,
    input rst,
    input [15:0] switches,
    output reg led
);

localparam bit_width = 16;
localparam max_value = 2**bit_width-1;   
logic rst_n;
logic [bit_width-1:0] duty;
logic pwm_out;

  pwm_module #(
    .bit_width(bit_width)
  ) dut (
    .clk(clk),
    .rst_n(rst_n),
    .duty(duty),
    .max_value(max_value), // Set maximum value to 2^32-1 (2^bit_width-
    .pwm_out(pwm_out)
  );

assign rst_n = ~rst;
assign duty = switches;
assign led = pwm_out;
endmodule
