`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] wejscieA;
    reg [3:0] wejscieB;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .wejscieA(wejscieA),
        .wejscieB(wejscieB),
        .Q(Q)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Basic Addition (2 + 3)");
            wejscieA = 4'd2;
            wejscieB = 4'd3;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Zero Addition (0 + 0)");
            wejscieA = 4'd0;
            wejscieB = 4'd0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Max value and zero (15 + 0)");
            wejscieA = 4'd15;
            wejscieB = 4'd0;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Overflow case (8 + 8)");

            wejscieA = 4'd8;
            wejscieB = 4'd8;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Maximum overflow (15 + 15)");

            wejscieA = 4'd15;
            wejscieB = 4'd15;
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Alternating bits (10 + 5)");

            wejscieA = 4'b1010;
            wejscieB = 4'b0101;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Single bit carry (7 + 1)");

            wejscieA = 4'd7;
            wejscieB = 4'd1;
            #1;

            check_outputs(4'd8);
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
        input [3:0] expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
