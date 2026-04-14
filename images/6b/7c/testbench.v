`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] base;
    reg clk;
    reg [7:0] exponent;
    reg reset;
    wire isDone;
    wire [99:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .base(base),
        .clk(clk),
        .exponent(exponent),
        .reset(reset),
        .isDone(isDone),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        base = 0;
        exponent = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task wait_and_check;

        input [99:0] expected_val;
        begin

            while (!isDone) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, expected_val);
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: 2^8", test_num);
        reset_dut();
        base = 9'd2;
        exponent = 8'd8;
        wait_and_check(100'd256);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: 7^3", test_num);
        reset_dut();
        base = 9'd7;
        exponent = 8'd3;
        wait_and_check(100'd343);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: 10^5", test_num);
        reset_dut();
        base = 9'd10;
        exponent = 8'd5;
        wait_and_check(100'd100000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: 1^255", test_num);
        reset_dut();
        base = 9'd1;
        exponent = 8'd255;
        wait_and_check(100'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: 0^10", test_num);
        reset_dut();
        base = 9'd0;
        exponent = 8'd10;
        wait_and_check(100'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: 511^1", test_num);
        reset_dut();
        base = 9'd511;
        exponent = 8'd1;
        wait_and_check(100'd511);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: 12^0", test_num);
        reset_dut();
        base = 9'd12;
        exponent = 8'd0;
        wait_and_check(100'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: 2^32", test_num);
        reset_dut();
        base = 9'd2;
        exponent = 8'd32;
        wait_and_check(100'h100000000);
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
        input expected_isDone;
        input [99:0] expected_result;
        begin
            if (expected_isDone === (expected_isDone ^ isDone ^ expected_isDone) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: isDone=%b, result=%h",
                         isDone, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: isDone=%b, result=%h",
                         expected_isDone, expected_result);
                $display("  Got:      isDone=%b, result=%h",
                         isDone, result);
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
        $dumpvars(0,base, clk, exponent, reset, isDone, result);
    end

endmodule
