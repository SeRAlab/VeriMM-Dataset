`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in;
    reg [2:0] state;
    wire ACTIVE_next;
    wire DONE_next;
    wire READY_next;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .state(state),
        .ACTIVE_next(ACTIVE_next),
        .DONE_next(DONE_next),
        .READY_next(READY_next),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: State READY, in=0", test_num);
            state = 3'b001;
            in = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: State READY, in=1", test_num);
            state = 3'b001;
            in = 1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: State ACTIVE, in=0", test_num);
            state = 3'b010;
            in = 0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: State ACTIVE, in=1", test_num);
            state = 3'b010;
            in = 1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: State DONE, in=0", test_num);
            state = 3'b100;
            in = 0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: State DONE, in=1", test_num);
            state = 3'b100;
            in = 1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
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
        input expected_ACTIVE_next;
        input expected_DONE_next;
        input expected_READY_next;
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ACTIVE_next === (expected_ACTIVE_next ^ ACTIVE_next ^ expected_ACTIVE_next) &&
                expected_DONE_next === (expected_DONE_next ^ DONE_next ^ expected_DONE_next) &&
                expected_READY_next === (expected_READY_next ^ READY_next ^ expected_READY_next) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: ACTIVE_next=%b, DONE_next=%b, READY_next=%b, out=%b",
                         ACTIVE_next, DONE_next, READY_next, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ACTIVE_next=%b, DONE_next=%b, READY_next=%b, out=%b",
                         expected_ACTIVE_next, expected_DONE_next, expected_READY_next, expected_out);
                $display("  Got:      ACTIVE_next=%b, DONE_next=%b, READY_next=%b, out=%b",
                         ACTIVE_next, DONE_next, READY_next, out);
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
