`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in;
    wire [7:0] out_hi;
    wire [7:0] out_lo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        in = 16'h0000;
        @(posedge clk);
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        in = 16'h0000;

        repeat(3) @(posedge clk);
        #1;
        $display("Testcase 001: All Zeros");
        #1;

        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        in = 16'hA500;
        repeat(3) @(posedge clk);
        #1;
        $display("Testcase 002: Basic Split (No Shift)");
        #1;

        check_outputs(8'hA5, 8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        in = 16'hFF04;
        repeat(3) @(posedge clk);
        #1;
        $display("Testcase 003: Barrel Shift Logic (Shift 4)");


        #1;



        check_outputs(8'h0F, 8'h04);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        in = 16'hFFFF;
        repeat(3) @(posedge clk);
        #1;
        $display("Testcase 004: Maximum Input Values");


        #1;



        check_outputs(8'h00, 8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        in = 16'h55AA;
        repeat(3) @(posedge clk);
        #1;
        $display("Testcase 005: Alternating Bit Pattern");


        #1;



        check_outputs(8'h15, 8'hAA);
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
        input [7:0] expected_out_hi;
        input [7:0] expected_out_lo;
        begin
            if (expected_out_hi === (expected_out_hi ^ out_hi ^ expected_out_hi) &&
                expected_out_lo === (expected_out_lo ^ out_lo ^ expected_out_lo)) begin
                $display("PASS");
                $display("  Outputs: out_hi=%h, out_lo=%h",
                         out_hi, out_lo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_hi=%h, out_lo=%h",
                         expected_out_hi, expected_out_lo);
                $display("  Got:      out_hi=%h, out_lo=%h",
                         out_hi, out_lo);
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
        $dumpvars(0,clk, in, out_hi, out_lo);
    end

endmodule
