module tb_stopwatch_timer_wrapper;

    // Declare signals for the testbench
    logic clk;
    logic clk_1kHz;
    logic rst_n;
    logic mode_sw;
    logic start;
    logic stop;
    logic reset;
    logic inc_min;
    logic inc_sec;
    logic [5:0] minutes;
    logic [5:0] seconds;
    logic blink;

    // Instantiate the DUT (Device Under Test)
    stopwatch_timer_wrapper dut (
        .clk(clk),
        .clk_1kHz(clk_1kHz),
        .rst_n(rst_n),
        .mode_sw(mode_sw),
        .start(start),
        .stop(stop),
        .reset(reset),
        .inc_min(inc_min),
        .inc_sec(inc_sec),
        .minutes(minutes),
        .seconds(seconds),
        .blink(blink)
    );

    // Clock generation for clk and clk_1kHz
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        clk_1kHz = 0;
        forever #500 clk_1kHz = ~clk_1kHz;
    end

    // Main testbench logic
    initial begin
        // Initialize signals
        rst_n = 0;
        mode_sw = 0;
        start = 0;
        stop = 0;
        reset = 0;
        inc_min = 0;
        inc_sec = 0;

        // Apply reset
        #10 rst_n = 1;
        #10 rst_n = 0;
        #10 rst_n = 1;

        // Switch to Stopwatch mode and start it
        mode_sw = 1;
        start = 1;
        #10 start = 0;
        
        // Let it run for some time
        #200;

        // Stop the Stopwatch
        stop = 1;
        #10 stop = 0;

        // Switch to Timer mode and start it
        mode_sw = 0;
        start = 1;
        #10 start = 0;

        // Let it run for some time
        #200;

        // Stop the Timer
        stop = 1;
        #10 stop = 0;

        // End the simulation
        $finish;
    end
endmodule
