`timescale 1ns/1ps


module pwm_module
#(parameter bit_width = 8)
(
input wire clk,                         // 1-bit input: clock
input wire rst_n,                       // 1-bit input: reset
input [bitwidth-1:0] duty,              // bitwidth-bit input: duty cycle
input [bitwidth-1:0] max_value,         // bitwidth-bit input: maximum value
output reg pwm_out,                     // 1-bit output: pwm output
);

reg [bit_width-1:0] counter;

// pwm output is high when counter is less than duty
// otherwise, pwm output is low
always_ff @(posedge clk)
begin
    if (~rst_n) begin
        counter <= 0;
        pwm_out <= 0;
    end begin // Check if enable signal is active
        if (counter == max_value) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
        pwm_out <= (counter < duty);
    end
end
endmodule