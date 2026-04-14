`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dividend;
    reg [7:0] divisor;
    reg rst;
    wire [7:0] quotient;
    wire [7:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
        .rst(rst),
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
            rst = 1;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Division (10 / 3)", test_num);
            dividend = 8'd10;
            divisor = 8'd3;
            reset_dut();

            repeat(15) @(posedge clk);
            #1;

            check_outputs(8'd3, 8'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Exact Division (50 / 5)", test_num);
            dividend = 8'd50;
            divisor = 8'd5;
            reset_dut();
            repeat(15) @(posedge clk);
            #1;

            check_outputs(8'd10, 8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Divisor Larger Than Dividend (5 / 12)", test_num);
            dividend = 8'd5;
            divisor = 8'd12;
            reset_dut();
            repeat(15) @(posedge clk);
            #1;

            check_outputs(8'd0, 8'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division by 1 (255 / 1)", test_num);
            dividend = 8'd255;
            divisor = 8'd1;
            reset_dut();
            repeat(15) @(posedge clk);
            #1;

            check_outputs(8'd255, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dividend is Zero (0 / 20)", test_num);
            dividend = 8'd0;
            divisor = 8'd20;
            reset_dut();
            repeat(15) @(posedge clk);
            #1;

            check_outputs(8'd0, 8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Value Division (255 / 2)", test_num);
            dividend = 8'd255;
            divisor = 8'd2;
            reset_dut();
            repeat(15) @(posedge clk);
            #1;

            check_outputs(8'd127, 8'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division by Same Value (128 / 128)", test_num);
            dividend = 8'd128;
            divisor = 8'd128;
            reset_dut();
            repeat(15) @(posedge clk);
            #1;

            check_outputs(8'd1, 8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Remainder (100 / 11)", test_num);
            dividend = 8'd100;
            divisor = 8'd11;
            reset_dut();
            repeat(15) @(posedge clk);
            #1;

            check_outputs(8'd9, 8'd1);
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
        input [7:0] expected_quotient;
        input [7:0] expected_remainder;
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
        $dumpvars(0,clk, dividend, divisor, rst, quotient, remainder);
    end

endmodule
