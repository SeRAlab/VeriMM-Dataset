`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Zero input");
            test_num = 1;
            data_in = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Unit input");
            test_num = 2;
            data_in = 32'h00000001;
            #1;

            check_outputs(32'h000000E1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Small value");
            test_num = 3;
            data_in = 32'h0000000A;
            #1;

            check_outputs(32'h000008CA);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Power of 2 (Shift test)");
            test_num = 4;
            data_in = 32'h00000100;
            #1;

            check_outputs(32'h0000E100);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Large value without overflow");
            test_num = 5;
            data_in = 32'h00010001;
            #1;

            check_outputs(32'h00E100E1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Max signed value (boundary)");
            test_num = 6;
            data_in = 32'h7FFFFFFF;
            #1;

            check_outputs(32'h7FFFFF1F);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Negative equivalent (-1)");
            test_num = 7;
            data_in = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFF1F);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Large random hex value");
            test_num = 8;
            data_in = 32'h12345678;
            #1;

            check_outputs(32'hFFDEF778);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: MSB set (Minimum signed value)");
            test_num = 9;
            data_in = 32'h80000000;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Patterned input");
            test_num = 10;
            data_in = 32'h01010101;
            #1;

            check_outputs(32'hE1E1E1E1);
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
        input [31:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
