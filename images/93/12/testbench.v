`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] state;
    reg trigger;
    wire Off_next;
    wire On_next;
    wire alarm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .state(state),
        .trigger(trigger),
        .Off_next(Off_next),
        .On_next(On_next),
        .alarm(alarm)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Current state Off (2'b01), Trigger 0", test_num);
        state = 2'b01;
        trigger = 0;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Current state Off (2'b01), Trigger 1", test_num);
        state = 2'b01;
        trigger = 1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Current state On (2'b10), Trigger 0", test_num);
        state = 2'b10;
        trigger = 0;

        #1;


        check_outputs(1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Current state On (2'b10), Trigger 1", test_num);
        state = 2'b10;
        trigger = 1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b1);
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
        input expected_Off_next;
        input expected_On_next;
        input expected_alarm;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Off_next === (expected_Off_next ^ Off_next ^ expected_Off_next) &&
                expected_On_next === (expected_On_next ^ On_next ^ expected_On_next) &&
                expected_alarm === (expected_alarm ^ alarm ^ expected_alarm)) begin
                $display("PASS");
                $display("  Outputs: Off_next=%b, On_next=%b, alarm=%b",
                         Off_next, On_next, alarm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Off_next=%b, On_next=%b, alarm=%b",
                         expected_Off_next, expected_On_next, expected_alarm);
                $display("  Got:      Off_next=%b, On_next=%b, alarm=%b",
                         Off_next, On_next, alarm);
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
