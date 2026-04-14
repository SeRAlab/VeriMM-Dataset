`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg candy_bar_left;
    reg clk;
    reg quarter;
    reg reset;
    wire dispense;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .candy_bar_left(candy_bar_left),
        .clk(clk),
        .quarter(quarter),
        .reset(reset),
        .dispense(dispense),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            quarter = 0;
            candy_bar_left = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Success Purchase Path", test_num);
            reset_dut();


            quarter = 1;
            @(posedge clk);
            #1;


            quarter = 1;
            @(posedge clk);
            #1;


            candy_bar_left = 1;
            quarter = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Out of Stock Path", test_num);
            reset_dut();

            quarter = 1;
            @(posedge clk);
            #1;

            quarter = 1;
            @(posedge clk);
            #1;


            candy_bar_left = 0;
            quarter = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, IDLE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Partial Input (Stay in ACCEPT)", test_num);
            reset_dut();


            quarter = 1;
            @(posedge clk);
            #1;


            quarter = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, ACCEPT);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: IDLE Stability", test_num);
            reset_dut();

            quarter = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, IDLE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Reset Mid-Transaction", test_num);
            reset_dut();

            quarter = 1;
            @(posedge clk);
            #1;

            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;

            #1;


            check_outputs(1'b0, IDLE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_dispense;
        input [1:0] expected_state;
        begin
            if (expected_dispense === (expected_dispense ^ dispense ^ expected_dispense) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: dispense=%b, state=%h",
                         dispense, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dispense=%b, state=%h",
                         expected_dispense, expected_state);
                $display("  Got:      dispense=%b, state=%h",
                         dispense, state);
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
        $dumpvars(0,candy_bar_left, clk, quarter, reset, dispense, state);
    end

endmodule
