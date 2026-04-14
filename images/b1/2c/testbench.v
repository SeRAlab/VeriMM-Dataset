`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bin;
    wire [3:0] ones;
    wire [3:0] tens;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin(bin),
        .ones(ones),
        .tens(tens)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Input = 0 (Lower bound)");
            bin = 4'd0;
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Input = 5 (Single digit)");
            bin = 4'd5;
            #1;

            check_outputs(4'd5, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Input = 9 (Boundary single digit)");
            bin = 4'd9;
            #1;

            check_outputs(4'd9, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Input = 10 (First double digit)");
            bin = 4'd10;
            #1;

            check_outputs(4'd0, 4'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Input = 13 (Double digit)");
            bin = 4'd13;
            #1;

            check_outputs(4'd3, 4'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Input = 15 (Upper bound)");
            bin = 4'd15;
            #1;

            check_outputs(4'd5, 4'd1);
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
        input [3:0] expected_ones;
        input [3:0] expected_tens;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ones === (expected_ones ^ ones ^ expected_ones) &&
                expected_tens === (expected_tens ^ tens ^ expected_tens)) begin
                $display("PASS");
                $display("  Outputs: ones=%h, tens=%h",
                         ones, tens);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ones=%h, tens=%h",
                         expected_ones, expected_tens);
                $display("  Got:      ones=%h, tens=%h",
                         ones, tens);
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
