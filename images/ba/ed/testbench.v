`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg start;
    reg [1:0] state;
    reg stop;
    wire Idle_next;
    wire Running_next;
    wire active;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .start(start),
        .state(state),
        .stop(stop),
        .Idle_next(Idle_next),
        .Running_next(Running_next),
        .active(active)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Idle state, start=0, stop=0", test_num);
            state = 2'b01;
            start = 0;
            stop  = 0;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Idle state, start=1, stop=0", test_num);
            state = 2'b01;
            start = 1;
            stop  = 0;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Running state, start=0, stop=0", test_num);
            state = 2'b10;
            start = 0;
            stop  = 0;
            #1;

            check_outputs(0, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Running state, start=0, stop=1", test_num);
            state = 2'b10;
            start = 0;
            stop  = 1;
            #1;

            check_outputs(1, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Idle state, start=1, stop=1 (stop is don't care in Idle)", test_num);
            state = 2'b01;
            start = 1;
            stop  = 1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Running state, start=1, stop=1 (start is don't care in Running)", test_num);
            state = 2'b10;
            start = 1;
            stop  = 1;
            #1;

            check_outputs(1, 0, 1);
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
        testcase006();
        
        
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
        input expected_Idle_next;
        input expected_Running_next;
        input expected_active;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Idle_next === (expected_Idle_next ^ Idle_next ^ expected_Idle_next) &&
                expected_Running_next === (expected_Running_next ^ Running_next ^ expected_Running_next) &&
                expected_active === (expected_active ^ active ^ expected_active)) begin
                $display("PASS");
                $display("  Outputs: Idle_next=%b, Running_next=%b, active=%b",
                         Idle_next, Running_next, active);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Idle_next=%b, Running_next=%b, active=%b",
                         expected_Idle_next, expected_Running_next, expected_active);
                $display("  Got:      Idle_next=%b, Running_next=%b, active=%b",
                         Idle_next, Running_next, active);
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

endmodule
