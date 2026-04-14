`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] dividend;
    reg [3:0] divisor;
    reg load;
    reg select;
    reg [3:0] serial_in;
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
        .load(load),
        .select(select),
        .serial_in(serial_in),
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
        load = 0;
        select = 0;
        dividend = 0;
        divisor = 0;
        serial_in = 0;
        repeat(2) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Positive / Positive (6 / 2)", test_num);
        reset_dut();
        dividend = 4'sd6;
        divisor = 4'sd2;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;

        repeat(4) @(posedge clk);
        #1;

        select = 0;
        #1;

        select = 1;
        #1;
        #1;

        check_outputs(4'sd3, 4'sd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Negative / Positive (-6 / 2)", test_num);
        reset_dut();
        dividend = -4'sd6;
        divisor = 4'sd2;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        repeat(4) @(posedge clk);
        #1;
        select = 0; #1;
        select = 1; #1;
        #1;

        check_outputs(-4'sd3, 4'sd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Positive / Negative (7 / -2)", test_num);
        reset_dut();
        dividend = 4'sd7;
        divisor = -4'sd2;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        repeat(4) @(posedge clk);
        #1;
        select = 0; #1;
        select = 1; #1;
        #1;

        check_outputs(-4'sd3, 4'sd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Negative / Negative (-7 / -3)", test_num);
        reset_dut();
        dividend = -4'sd7;
        divisor = -4'sd3;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        repeat(4) @(posedge clk);
        #1;
        select = 0; #1;
        select = 1; #1;
        #1;

        check_outputs(4'sd2, -4'sd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Zero Dividend (0 / 5)", test_num);
        reset_dut();
        dividend = 4'sd0;
        divisor = 4'sd5;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        repeat(4) @(posedge clk);
        #1;
        select = 0; #1;
        select = 1; #1;
        #1;

        check_outputs(4'sd0, 4'sd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Max Negative Dividend (-8 / 2)", test_num);
        reset_dut();
        dividend = -4'sd8;
        divisor = 4'sd2;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        repeat(4) @(posedge clk);
        #1;
        select = 0; #1;
        select = 1; #1;
        #1;

        check_outputs(-4'sd4, 4'sd0);
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
        $dumpvars(0,clk, dividend, divisor, load, select, serial_in, quotient, remainder);
    end

endmodule
