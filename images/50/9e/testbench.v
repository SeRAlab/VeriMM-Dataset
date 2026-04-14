`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg bit_a;
    reg bit_b;
    reg bit_borrow_in;
    reg start;
    wire bit_borrow_out;
    wire bit_diff;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bit_a(bit_a),
        .bit_b(bit_b),
        .bit_borrow_in(bit_borrow_in),
        .start(start),
        .bit_borrow_out(bit_borrow_out),
        .bit_diff(bit_diff),
        .done(done)
    );
    task testcase001;

        begin
            $display("Test Case 001: 0 - 0 - 0 (start=1)");
            test_num = 1;
            bit_a = 0;
            bit_b = 0;
            bit_borrow_in = 0;
            start = 1;
            #10;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: 0 - 0 - 1 (start=1)");
            test_num = 2;
            bit_a = 0;
            bit_b = 0;
            bit_borrow_in = 1;
            start = 1;
            #10;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: 0 - 1 - 0 (start=1)");
            test_num = 3;
            bit_a = 0;
            bit_b = 1;
            bit_borrow_in = 0;
            start = 1;
            #10;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: 0 - 1 - 1 (start=1)");
            test_num = 4;
            bit_a = 0;
            bit_b = 1;
            bit_borrow_in = 1;
            start = 1;
            #10;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: 1 - 0 - 0 (start=1)");
            test_num = 5;
            bit_a = 1;
            bit_b = 0;
            bit_borrow_in = 0;
            start = 1;
            #10;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: 1 - 0 - 1 (start=1)");
            test_num = 6;
            bit_a = 1;
            bit_b = 0;
            bit_borrow_in = 1;
            start = 1;
            #10;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: 1 - 1 - 0 (start=1)");
            test_num = 7;
            bit_a = 1;
            bit_b = 1;
            bit_borrow_in = 0;
            start = 1;
            #10;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: 1 - 1 - 1 (start=1)");
            test_num = 8;
            bit_a = 1;
            bit_b = 1;
            bit_borrow_in = 1;
            start = 1;
            #10;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: start=0 Check");
            test_num = 9;
            bit_a = 1;
            bit_b = 0;
            bit_borrow_in = 0;
            start = 0;
            #10;

            #1;


            check_outputs(bit_borrow_out, bit_diff, 1'b0);
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
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input expected_bit_borrow_out;
        input expected_bit_diff;
        input expected_done;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bit_borrow_out === (expected_bit_borrow_out ^ bit_borrow_out ^ expected_bit_borrow_out) &&
                expected_bit_diff === (expected_bit_diff ^ bit_diff ^ expected_bit_diff) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: bit_borrow_out=%b, bit_diff=%b, done=%b",
                         bit_borrow_out, bit_diff, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bit_borrow_out=%b, bit_diff=%b, done=%b",
                         expected_bit_borrow_out, expected_bit_diff, expected_done);
                $display("  Got:      bit_borrow_out=%b, bit_diff=%b, done=%b",
                         bit_borrow_out, bit_diff, done);
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
