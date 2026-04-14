`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] input_num;
    wire [7:0] abs_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_num(input_num),
        .abs_value(abs_value)
    );
    task testcase001;

    begin
        $display("Testcase 001: Input 0");
        input_num = 8'sd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Input 127 (Max Positive)");
        input_num = 8'sd127;
        #1;

        check_outputs(8'd127);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Input 10");
        input_num = 8'sd10;
        #1;

        check_outputs(8'd10);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Input -1");
        input_num = -8'sd1;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Input -128 (Min Negative)");
        input_num = -8'sd128;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Input -10");
        input_num = -8'sd10;
        #1;

        check_outputs(8'd10);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Input 64");
        input_num = 8'sd64;
        #1;

        check_outputs(8'd64);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Input -64");
        input_num = -8'sd64;
        #1;

        check_outputs(8'd64);
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
        input [7:0] expected_abs_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_abs_value === (expected_abs_value ^ abs_value ^ expected_abs_value)) begin
                $display("PASS");
                $display("  Outputs: abs_value=%h",
                         abs_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: abs_value=%h",
                         expected_abs_value);
                $display("  Got:      abs_value=%h",
                         abs_value);
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
