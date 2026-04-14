`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] I;
    wire [3:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I(I),
        .O(O)
    );
    task testcase001;

        begin
            test_num = 1;
            I = 4'd0;
            $display("Test Case 001: Increment 0");
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            I = 4'd1;
            $display("Test Case 002: Increment 1");
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            I = 4'd7;
            $display("Test Case 003: Increment 7 (Transition to MSB)");
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            I = 4'd10;
            $display("Test Case 004: Increment 10");
            #1;

            check_outputs(4'd11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            I = 4'd14;
            $display("Test Case 005: Increment 14");
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            I = 4'd15;
            $display("Test Case 006: Increment 15 (Overflow/Rollover)");
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            I = 4'b0101;
            $display("Test Case 007: Increment binary 0101");
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            I = 4'b0011;
            $display("Test Case 008: Increment binary 0011");
            #1;

            check_outputs(4'b0100);
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
        input [3:0] expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%h",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h",
                         expected_O);
                $display("  Got:      O=%h",
                         O);
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
