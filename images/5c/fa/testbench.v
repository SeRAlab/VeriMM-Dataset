`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] Divisor;
    reg clk;
    reg rst;
    wire clkOut;
    wire [31:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Divisor(Divisor),
        .clk(clk),
        .rst(rst),
        .clkOut(clkOut),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            Divisor = 32'd0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase 001: Divisor = 2, 2 cycles");
            reset_dut();
            Divisor = 32'd2;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase 002: Divisor = 5, 10 cycles");
            reset_dut();
            Divisor = 32'd5;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase 003: Divisor = 1, 3 cycles");
            reset_dut();
            Divisor = 32'd1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 32'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase 004: Divisor = 10, mid-check at 5 cycles");
            reset_dut();
            Divisor = 32'd10;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 32'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase 005: Divisor = 100, 100 cycles");
            reset_dut();
            Divisor = 32'd100;
            repeat(100) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 32'd0);
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
        input expected_clkOut;
        input [31:0] expected_count;
        begin
            if (expected_clkOut === (expected_clkOut ^ clkOut ^ expected_clkOut) &&
                expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: clkOut=%b, count=%h",
                         clkOut, count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clkOut=%b, count=%h",
                         expected_clkOut, expected_count);
                $display("  Got:      clkOut=%b, count=%h",
                         clkOut, count);
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
        $dumpvars(0,Divisor, clk, rst, clkOut, count);
    end

endmodule
