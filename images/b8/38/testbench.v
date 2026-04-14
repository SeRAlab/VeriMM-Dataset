`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg clk;
    wire [63:0] pdt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .pdt(pdt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        a = 32'h0;
        b = 32'h0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Test Case 001: Zero Multiplication");
        reset_dut();
        a = 32'd123456;
        b = 32'd0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(64'd0);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Identity Multiplication");
        reset_dut();
        a = 32'hFFFF_FFFF;
        b = 32'd1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(64'h0000_0000_FFFF_FFFF);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Basic Small Integers");
        reset_dut();
        a = 32'd25;
        b = 32'd40;
        @(posedge clk);
        #2;
        #1;

        check_outputs(64'd1000);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Maximum 32-bit values");
        reset_dut();
        a = 32'hFFFF_FFFF;
        b = 32'hFFFF_FFFF;
        @(posedge clk);
        #2;

        #1;


        check_outputs(64'hFFFF_FFFE_0000_0001);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Powers of 2");
        reset_dut();
        a = 32'h0001_0000;
        b = 32'h0000_0400;
        @(posedge clk);
        #2;
        #1;

        check_outputs(64'h0000_0000_0400_0000);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Prime Numbers");
        reset_dut();
        a = 32'd104729;
        b = 32'd7919;
        @(posedge clk);
        #2;
        #1;

        check_outputs(64'd829348951);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: High-bit patterns");
        reset_dut();
        a = 32'h8000_0000;
        b = 32'd2;
        @(posedge clk);
        #2;
        #1;

        check_outputs(64'h0000_0001_0000_0000);
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
        input [63:0] expected_pdt;
        begin
            if (expected_pdt === (expected_pdt ^ pdt ^ expected_pdt)) begin
                $display("PASS");
                $display("  Outputs: pdt=%h",
                         pdt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pdt=%h",
                         expected_pdt);
                $display("  Got:      pdt=%h",
                         pdt);
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
        $dumpvars(0,a, b, clk, pdt);
    end

endmodule
