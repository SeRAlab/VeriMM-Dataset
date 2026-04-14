`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] e;
    wire [6:0] rotate_left;
    wire [6:0] rotate_right;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .e(e),
        .rotate_left(rotate_left),
        .rotate_right(rotate_right)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros", test_num);
            e = 7'b0000000;
            #1;

            check_outputs(7'b0000000, 7'b0000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Ones", test_num);
            e = 7'b1111111;
            #1;

            check_outputs(7'b1111111, 7'b1111111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pattern from Specification (1010101)", test_num);
            e = 7'b1010101;
            #1;

            check_outputs(7'b0101011, 7'b1101010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Bit MSB", test_num);
            e = 7'b1000000;
            #1;

            check_outputs(7'b0000001, 7'b0100000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Bit LSB", test_num);
            e = 7'b0000001;
            #1;

            check_outputs(7'b0000010, 7'b1000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating Pattern 1 (0110011)", test_num);
            e = 7'b0110011;
            #1;

            check_outputs(7'b1100110, 7'b1011001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating Pattern 2 (1100110)", test_num);
            e = 7'b1100110;
            #1;

            check_outputs(7'b1001101, 7'b0110011);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High-Mid Pattern (0111110)", test_num);
            e = 7'b0111110;
            #1;

            check_outputs(7'b1111100, 7'b0011111);
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
        input [6:0] expected_rotate_left;
        input [6:0] expected_rotate_right;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rotate_left === (expected_rotate_left ^ rotate_left ^ expected_rotate_left) &&
                expected_rotate_right === (expected_rotate_right ^ rotate_right ^ expected_rotate_right)) begin
                $display("PASS");
                $display("  Outputs: rotate_left=%h, rotate_right=%h",
                         rotate_left, rotate_right);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rotate_left=%h, rotate_right=%h",
                         expected_rotate_left, expected_rotate_right);
                $display("  Got:      rotate_left=%h, rotate_right=%h",
                         rotate_left, rotate_right);
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
