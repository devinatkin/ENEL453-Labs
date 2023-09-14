`timescale 1ns / 1ps

module sevenseg4ddriver(
    input wire clk, //100Mhz System Clock
    input wire rst_n,
    input wire [6:0] digit0_segments,
    input wire [6:0] digit1_segments,
    input wire [6:0] digit2_segments,
    input wire [6:0] digit3_segments,
    output logic [6:0] segments,
    output logic [3:0] anodes
    );

    logic clk_reduced; // Reduced clock signal for the mux

    segment_mux persistence_mux (
        .clk(clk_reduced),
        .rst_n(rst_n),
        .in0(digit0_segments),
        .in1(digit1_segments),
        .in2(digit2_segments),
        .in3(digit3_segments),
        .out_val(segments),
        .out_sel(anodes)
    );

    pwm_module #(
        .bit_width(32) // Wide bit width setup
    ) clk_reducer (
        .clk(clk),
        .rst_n(rst_n),
        .duty(5000000), 
        .max_value(10000000),
        .pwm_out(clk_reduced)
    );

endmodule