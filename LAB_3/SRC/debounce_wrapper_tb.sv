module tb_debounce_wrapper;

    typedef enum {Resetting, Bouncing, Stable, Completed, Failed} StateType;

    // Constants
    time stable_time_tb = 70ms;
    time some_delay = 3ns;
    time clock_period = 10ns;

    // Inputs
    reg clk;
    reg [4:0] buttons; // For multiple buttons
    reg reset_n;

    // Outputs
    wire [4:0] results; // For multiple debounced results

    reg error = 0;
    StateType Test_State;

    // Instantiate the Unit Under Test (UUT)
    debounce_wrapper uut (
        .clk(clk), 
        .rst_n(reset_n), 
        .buttons(buttons), 
        .results(results)
    );

    always begin
        #(clock_period/2);
        clk = 1;
        #(clock_period/2);
        clk = 0;    
    end

    initial begin
        // Initialize Inputs
        clk = 0;
        buttons = 0;
        reset_n = 0;
        Test_State = Resetting;

        #100;
        reset_n = 1;

        // Example test for one button (say, START button at index 0)
        Test_State = Bouncing;
        buttons[0] = 1; #100;
        buttons[0] = 0; #100;
        buttons[0] = 1; #100;
        buttons[0] = 0; #100;
        Test_State = Stable;
        buttons[0] = 1;

        #(stable_time_tb+some_delay);

        assert(results[0] == 1) else begin
            $error("First Test Failed");
            Test_State = Failed;
            error = 1;
        end

        // You can add more tests for other buttons here, just like the example above.

        $display("Testbench Finished");
        if(error == 1) begin
            $display("Test Failed with Some Errors");
        end else begin
            $display("Test Passed with no Errors");
        end

        $stop;
    end
endmodule
