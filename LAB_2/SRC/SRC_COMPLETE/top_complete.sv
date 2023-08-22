
module top (
    input clk,
    input reset,
    input [15:0] switches,
    output reg [15:0] led
);

    localparam bit_width = 8; // Set the bit width to 8 for PWM instances
    reg rst_n;
    reg [7:0] duty [15:0];
    reg [15:0] pwm_out;
    reg [7:0] reg_out [15:0]; // Output of the circular shift register
    reg wide_pwm_out;
    wire clk_reduced; // Reduced clock signal for the circular shift register

    // Instantiate 16 PWM modules
    genvar i;
    generate
        for(i = 0; i < 16; i++) begin
            pwm_module #(
                .bit_width(bit_width)
            ) pwm_unit (
                .clk(clk),
                .rst_n(rst_n),
                .duty(duty[i]),
                .max_value(8'd255),
                .pwm_out(pwm_out[i])
            );
        end
    endgenerate

    // Instantiate the circular shift register
    circular_shift_register csr (
        .clk(clk_reduced),
        .rst_n(rst_n),
        .reg_out(reg_out)
    );

    // Instantiate the 17th PWM module to reduce the clock speed
    pwm_module #(
        .bit_width(32) // Wide bit width setup
    ) clk_reducer (
        .clk(clk),
        .rst_n(rst_n),
        .duty(5000000), // 50% duty cycle to reduce 100MHz to 50Hz
        .max_value(10000000), // Set to 100MHz
        .pwm_out(wide_pwm_out)
    );

    // Clock reduction using the 17th PWM module
    assign clk_reduced = (wide_pwm_out == 1);

    // Control signals
    assign rst_n = ~reset;
    assign duty = reg_out; // Hooking the duty cycles to the output registers
    assign led = pwm_out; // Drive LEDs with each bit of the PWM outputs

endmodule