module display_driver(
    input wire clk, //100Mhz System Clock
    input wire clk100k, //100Khz Clock
    input wire clk1s, //1Hz Clock
    input wire rst_n,
    input wire [5:0] minutes,
    input wire [5:0] seconds,
    input wire blink,
    output reg [6:0] seg,   //Segment Outputs
    output reg [3:0] an     //Common Anode Outputs (0 = on, 1 = off)

    );

    wire [6:0] digit0, digit1, digit2, digit3;
    reg [3:0] bcd0, bcd1, bcd2, bcd3;
    wire [15:0] seconds_bcd;
    wire [15:0] minutes_bcd;
    wire seconds_ready;
    wire minutes_ready;
    wire [3:0] out_sel;

    wire [3:0] assigned_value;
    
    reg clk1k;
    reg [15:0] clk1k_counter;
    assign assigned_value = !out_sel;
    assign an = (blink) ? (clk1s ? 6'h3F : assigned_value) : assigned_value;

    bcd_to_binary digit0_bcd_to_binary (
        .bcd(bcd0),
        .bin(digit0)
    );

    bcd_to_binary digit1_bcd_to_binary (
        .bcd(bcd1),
        .bin(digit1)
    );

    bcd_to_binary digit2_bcd_to_binary (
        .bcd(bcd2),
        .bin(digit2)
    );

    bcd_to_binary digit3_bcd_to_binary (
        .bcd(bcd3),
        .bin(digit3)
    );

    doubleDabble double_dabble_seconds(
        .bin({8'd0,seconds}),
        .bcd(seconds_bcd),
        .clk(clk),
        .rst(!rst_n),
        .ready(seconds_ready)
    );

    doubleDabble double_dabble_minutes(
        .bin({8'd0,minutes}),
        .bcd(minutes_bcd),
        .clk(clk),
        .rst(!rst_n),
        .ready(minutes_ready)
    );

    segment_mux persistence_mux (
        .clk(clk25k),
        .rst_n(rst_n),
        .in0(digit0),
        .in1(digit1),
        .in2(digit2),
        .in3(digit3),
        .out_val(seg),
        .out_sel(out_sel)
    );

    always @(posedge clk) begin //Simple Logic to drive the BCD inputs to the 7-segment decoder
        if(!rst_n) begin
            bcd0 <= 4'd0;
            bcd1 <= 4'd0;
            bcd2 <= 4'd0;
            bcd3 <= 4'd0;
        end else begin
            if(seconds_ready) begin
                bcd0 <= seconds_bcd[3:0];
                bcd1 <= seconds_bcd[7:4];
            end
            if(minutes_ready) begin
                bcd2 <= minutes_bcd[11:8];
                bcd3 <= minutes_bcd[15:12];
            end
        end
    end

    always@(posedge clk100k) begin
        if(!rst_n) begin
            clk1k <= 1'b0;
            clk1k_counter <= 16'd0;
        end else begin
            clk1k <= (clk1k_counter == 16'd49999) ? !clk1k : clk1k;
            clk1k_counter <= (clk1k_counter == 16'd49999) ? 16'd0 : clk1k_counter + 16'd1;
        end
    end

endmodule
