`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] x;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        x = 32'sh0000_0000;
        #10;
        $display("Testcase 001: x = 0.0 (Expect asin(0) = 0)");
        #1;

        check_outputs(32'sh0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        x = 32'sh0001_0000;
        #10;
        $display("Testcase 002: x = 1.0 (Expect asin(1) approx 1.5708)");

        #1;


        check_outputs(32'sh0001_921F);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        x = 32'shFFFF_0000;
        #10;
        $display("Testcase 003: x = -1.0 (Expect asin(-1) approx -1.5708)");

        #1;


        check_outputs(32'shFFFE_6DE1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        x = 32'sh0000_8000;
        #10;
        $display("Testcase 004: x = 0.5 (Expect asin(0.5) approx 0.5236)");

        #1;


        check_outputs(32'sh0000_860B);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        x = 32'sh0002_0000;
        #10;
        $display("Testcase 005: x = 2.0 (Expect atan(2) approx 1.1071)");

        #1;


        check_outputs(32'sh0001_1B6E);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        x = 32'shFFFE_0000;
        #10;
        $display("Testcase 006: x = -2.0 (Expect atan(-2) approx -1.1071)");

        #1;


        check_outputs(32'shFFFE_E492);
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
        input [31:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
