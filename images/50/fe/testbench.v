`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bin;
    wire [15:0] bcd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin(bin),
        .bcd(bcd)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Input bin = 4'd0");
        bin = 4'd0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Input bin = 4'd5");
        bin = 4'd5;
        #1;

        check_outputs(16'h0005);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Input bin = 4'd9");
        bin = 4'd9;
        #1;

        check_outputs(16'h0009);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Input bin = 4'd10");
        bin = 4'd10;
        #1;

        check_outputs(16'h0010);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Input bin = 4'd13");
        bin = 4'd13;
        #1;

        check_outputs(16'h0013);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Input bin = 4'd15");
        bin = 4'd15;
        #1;

        check_outputs(16'h0015);
    end
        endtask

    task testcase007;

        integer i;
        reg [15:0] expected;
    begin
        test_num = 7;
        $display("Test Case 007: Comprehensive Sweep 0-15");
        for (i = 0; i < 16; i = i + 1) begin
            bin = i;


            expected = ((i / 10) << 4) | (i % 10);
            #1;

            check_outputs(expected);
        end
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
        input [15:0] expected_bcd;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bcd === (expected_bcd ^ bcd ^ expected_bcd)) begin
                $display("PASS");
                $display("  Outputs: bcd=%h",
                         bcd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd=%h",
                         expected_bcd);
                $display("  Got:      bcd=%h",
                         bcd);
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
