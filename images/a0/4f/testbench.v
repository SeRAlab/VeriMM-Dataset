`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] dividend;
    reg [3:0] divisor;
    wire [3:0] quotient;
    wire [3:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient),
        .remainder(remainder)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            dividend <= 4'b0;
            divisor <= 4'b0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            dividend <= 4'd10;
            divisor <= 4'd3;
            repeat(10) @(posedge clk);
            $display("Test Case 001: 10 / 3");
            #1;

            check_outputs(4'd3, 4'd1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            dividend <= 4'd12;
            divisor <= 4'd4;
            repeat(10) @(posedge clk);
            $display("Test Case 002: 12 / 4");
            #1;

            check_outputs(4'd3, 4'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            dividend <= 4'd2;
            divisor <= 4'd5;
            repeat(10) @(posedge clk);
            $display("Test Case 003: 2 / 5");
            #1;

            check_outputs(4'd0, 4'd2);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            dividend <= 4'd15;
            divisor <= 4'd1;
            repeat(10) @(posedge clk);
            $display("Test Case 004: 15 / 1");
            #1;

            check_outputs(4'd15, 4'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            dividend <= 4'd7;
            divisor <= 4'd7;
            repeat(10) @(posedge clk);
            $display("Test Case 005: 7 / 7");
            #1;

            check_outputs(4'd1, 4'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            dividend <= 4'd15;
            divisor <= 4'd15;
            repeat(10) @(posedge clk);
            $display("Test Case 006: 15 / 15");
            #1;

            check_outputs(4'd1, 4'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            dividend <= 4'd0;
            divisor <= 4'd5;
            repeat(10) @(posedge clk);
            $display("Test Case 007: 0 / 5");
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            dividend <= 4'd13;
            divisor <= 4'd3;
            repeat(10) @(posedge clk);
            $display("Test Case 008: 13 / 3");
            #1;

            check_outputs(4'd4, 4'd1);
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
        input [3:0] expected_quotient;
        input [3:0] expected_remainder;
        begin
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h, remainder=%h",
                         quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h, remainder=%h",
                         expected_quotient, expected_remainder);
                $display("  Got:      quotient=%h, remainder=%h",
                         quotient, remainder);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, dividend, divisor, quotient, remainder);
    end

endmodule
