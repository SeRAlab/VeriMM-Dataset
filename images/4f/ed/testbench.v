`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] mole16bit;
    wire [4:0] mole_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mole16bit(mole16bit),
        .mole_position(mole_position)
    );
    task testcase001;

        begin
            $display("Test Case 001: No bits asserted");
            mole16bit = 16'h0000;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Bit 0 asserted");
            mole16bit = 16'h0001;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Bit 1 asserted");
            mole16bit = 16'h0002;
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Bit 7 asserted");
            mole16bit = 16'h0080;
            #1;

            check_outputs(5'd7);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Bit 15 asserted");
            mole16bit = 16'h8000;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Multiple bits asserted (0 and 1)");
            mole16bit = 16'h0003;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Multiple bits asserted (14 and 15)");
            mole16bit = 16'hC000;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Bit 10 asserted");
            mole16bit = 16'h0400;
            #1;

            check_outputs(5'd10);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: All bits asserted");
            mole16bit = 16'hFFFF;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: Sparse multiple bits (bits 4, 8, 12)");
            mole16bit = 16'h1110;
            #1;

            check_outputs(5'd0);
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
        testcase010();
        
        
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
        input [4:0] expected_mole_position;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mole_position === (expected_mole_position ^ mole_position ^ expected_mole_position)) begin
                $display("PASS");
                $display("  Outputs: mole_position=%h",
                         mole_position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mole_position=%h",
                         expected_mole_position);
                $display("  Got:      mole_position=%h",
                         mole_position);
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
