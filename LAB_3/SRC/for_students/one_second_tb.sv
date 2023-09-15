module tb_clock_divider;

    // Signals
    logic clk_100MHz;
    logic rst_n;
    logic clk_1Hz;
    logic clk_1kHz;

    logic current_1Hz;
    logic current_1kHz;
    time edge_1Hz;
    time edge_1kHz;
    time period_1Hz;
    time period_1kHz;

    // Instantiate the DUT (Device Under Test)
    clock_divider uut (
        .clk_100MHz(clk_100MHz),
        .rst_n(rst_n),
        .clk_1Hz(clk_1Hz),
        .clk_1kHz(clk_1kHz)
    );

    // Clock generation for 100MHz (5ns period)
    always begin
        #5 clk_100MHz = ~clk_100MHz;
    end

// Test procedure
initial begin
    // Initialization
    clk_100MHz = 0;
    rst_n = 0;

    #50 rst_n = 1; // De-assert reset after a longer period to ensure all clocks are running

    // Wait for the 1khz clock to toggle
    current_1kHz = clk_1kHz;
    wait(clk_1kHz !== current_1kHz);
    edge_1kHz = $time;
    current_1kHz = clk_1kHz;
    wait(clk_1kHz !== current_1kHz);
    period_1kHz = $time - edge_1kHz;
    $display("Measured 1kHz period: %0t", period_1kHz*2);

    // Wait for the 1hz clock to toggle
    current_1Hz = clk_1Hz;
    wait(clk_1Hz !== current_1Hz);
    edge_1Hz = $time;
    current_1Hz = clk_1Hz;
    wait(clk_1Hz !== current_1Hz);
    period_1Hz = $time - edge_1Hz;
    $display("Measured 1Hz period: %0t", period_1Hz*2);
    
    // Assertion to check periods are as expected
    if (period_1Hz == 1.0e9 && period_1kHz == 1.0e6) begin
        $display("Test Passed: Measured periods are as expected");
    end else begin
        $display("Test Failed: Measured periods are not as expected");
    end

    $finish;
end


endmodule
