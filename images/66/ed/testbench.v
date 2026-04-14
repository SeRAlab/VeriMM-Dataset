`timescale 1ns/1ps

module traffic_light_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] state;
    wire green;
    wire [2:0] next_state;
    wire red;
    wire yellow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    traffic_light_controller dut (
        .clk(clk),
        .state(state),
        .green(green),
        .next_state(next_state),
        .red(red),
        .yellow(yellow)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin

            state = 3'b001;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %0d: Green State Logic", test_num);
            reset_dut();


            #1;



            check_outputs(1'b1, 3'b010, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %0d: Yellow State Logic", test_num);
            reset_dut();

            state = 3'b010;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 3'b100, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %0d: Red State Logic", test_num);
            reset_dut();

            state = 3'b100;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 3'b001, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %0d: Sequential Cycle Transition", test_num);
            reset_dut();


            state = next_state;
            @(posedge clk);
            #1;


            state = next_state;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 3'b001, 1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("traffic_light_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_green;
        input [2:0] expected_next_state;
        input expected_red;
        input expected_yellow;
        begin
            if (expected_green === (expected_green ^ green ^ expected_green) &&
                expected_next_state === (expected_next_state ^ next_state ^ expected_next_state) &&
                expected_red === (expected_red ^ red ^ expected_red) &&
                expected_yellow === (expected_yellow ^ yellow ^ expected_yellow)) begin
                $display("PASS");
                $display("  Outputs: green=%b, next_state=%h, red=%b, yellow=%b",
                         green, next_state, red, yellow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: green=%b, next_state=%h, red=%b, yellow=%b",
                         expected_green, expected_next_state, expected_red, expected_yellow);
                $display("  Got:      green=%b, next_state=%h, red=%b, yellow=%b",
                         green, next_state, red, yellow);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, state, green, next_state, red, yellow);
    end

endmodule
