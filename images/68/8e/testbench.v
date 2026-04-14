`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [13:0] e;
    wire [13:0] and_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .e(e),
        .and_result(and_result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Input all zeros (14'h0000)");
            e = 14'h0000;
            #1;

            check_outputs(14'h0000 & 14'h3FFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Input all ones (14'h3FFF)");
            e = 14'h3FFF;
            #1;

            check_outputs(14'h3FFF & 14'h3FFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Input alternating pattern 1 (14'h2AAA)");
            e = 14'h2AAA;
            #1;

            check_outputs(14'h2AAA & 14'h3FFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Input alternating pattern 2 (14'h1555)");
            e = 14'h1555;
            #1;

            check_outputs(14'h1555 & 14'h3FFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Input LSB and MSB (14'h2001)");
            e = 14'h2001;
            #1;

            check_outputs(14'h2001 & 14'h3FFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Input nibble pattern (14'h0F0F)");
            e = 14'h0F0F;
            #1;

            check_outputs(14'h0F0F & 14'h3FFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Input arbitrary value (14'h1234)");
            e = 14'h1234;
            #1;

            check_outputs(14'h1234 & 14'h3FFF);
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
        input [13:0] expected_and_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_and_result === (expected_and_result ^ and_result ^ expected_and_result)) begin
                $display("PASS");
                $display("  Outputs: and_result=%h",
                         and_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: and_result=%h",
                         expected_and_result);
                $display("  Got:      and_result=%h",
                         and_result);
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
