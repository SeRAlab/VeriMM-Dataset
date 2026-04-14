`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg enable;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .enable(enable),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 4'd5;
            b = 4'd3;
            enable = 1'b0;
            $display("Test Case 001: enable=0, a=5, b=3");
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 4'd5;
            b = 4'd3;
            enable = 1'b1;
            $display("Test Case 002: enable=1, a=5, b=3");
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 4'd0;
            b = 4'd0;
            enable = 1'b1;
            $display("Test Case 003: enable=1, a=0, b=0");
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 4'd12;
            b = 4'd6;
            enable = 1'b1;
            $display("Test Case 004: enable=1, a=12, b=6 (Overflow expected)");
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 4'hf;
            b = 4'hf;
            enable = 1'b0;
            $display("Test Case 005: enable=0, a=15, b=15");
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 4'hf;
            b = 4'hf;
            enable = 1'b1;
            $display("Test Case 006: enable=1, a=15, b=15");
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 4'd7;
            b = 4'd8;
            enable = 1'b1;
            $display("Test Case 007: enable=1, a=7, b=8");
            #1;

            check_outputs(4'd15);
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
        input [3:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
