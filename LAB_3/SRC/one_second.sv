module clock_divider
(
    input logic clk_100MHz,     // Input clock at 100MHz
    input logic rst_n,          // Active-low synchronous reset
    output logic clk_1Hz,       // Output clock at 1Hz
    output logic clk_1kHz       // Output clock at 1kHz
);

    // Counters for 1Hz and 1kHz clock divisions
    logic [26:0] counter_1Hz = 0;
    logic [16:0] counter_1kHz = 0;

    // Clock signals for 1Hz and 1kHz
    logic clk_1Hz_reg = 0;
    logic clk_1kHz_reg = 0;

    // Clock division for 1Hz
    always_ff @(posedge clk_100MHz) begin
        if (!rst_n) begin
            counter_1Hz <= 0;
            clk_1Hz_reg <= 0;
        end else if(counter_1Hz == 50_000_000 - 1) begin
            counter_1Hz <= 0;
            clk_1Hz_reg <= ~clk_1Hz_reg;
        end else begin
            counter_1Hz <= counter_1Hz + 1;
        end
    end

    // Clock division for 1kHz
    always_ff @(posedge clk_100MHz) begin
        if (!rst_n) begin
            counter_1kHz <= 0;
            clk_1kHz_reg <= 0;
        end else if(counter_1kHz == 50_000 - 1) begin
            counter_1kHz <= 0;
            clk_1kHz_reg <= ~clk_1kHz_reg;
        end else begin
            counter_1kHz <= counter_1kHz + 1;
        end
    end

    // Output assignment
    assign clk_1Hz = clk_1Hz_reg;
    assign clk_1kHz = clk_1kHz_reg;

endmodule
