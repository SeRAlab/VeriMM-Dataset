`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in;
    reg [2:0] state;
    wire ONE_next;
    wire TWO_next;
    wire ZERO_next;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .state(state),
        .ONE_next(ONE_next),
        .TWO_next(TWO_next),
        .ZERO_next(ZERO_next),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: State ZERO (3'b001), in=0", test_num);
            state = 3'b001;
            in = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: State ZERO (3'b001), in=1", test_num);
            state = 3'b001;
            in = 1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: State ONE (3'b010), in=0", test_num);
            state = 3'b010;
            in = 0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: State ONE (3'b010), in=1", test_num);
            state = 3'b010;
            in = 1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: State TWO (3'b100), in=0", test_num);
            state = 3'b100;
            in = 0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: State TWO (3'b100), in=1", test_num);
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
        input expected_ONE_next;
        input expected_TWO_next;
        input expected_ZERO_next;
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ONE_next === (expected_ONE_next ^ ONE_next ^ expected_ONE_next) &&
                expected_TWO_next === (expected_TWO_next ^ TWO_next ^ expected_TWO_next) &&
                expected_ZERO_next === (expected_ZERO_next ^ ZERO_next ^ expected_ZERO_next) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: ONE_next=%b, TWO_next=%b, ZERO_next=%b, out=%b",
                         ONE_next, TWO_next, ZERO_next, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ONE_next=%b, TWO_next=%b, ZERO_next=%b, out=%b",
                         expected_ONE_next, expected_TWO_next, expected_ZERO_next, expected_out);
                $display("  Got:      ONE_next=%b, TWO_next=%b, ZERO_next=%b, out=%b",
                         ONE_next, TWO_next, ZERO_next, out);
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
