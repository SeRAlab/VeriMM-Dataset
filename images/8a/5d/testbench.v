`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg enable;
    reg reset;
    wire [7:0] x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .x(x)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        enable = 0;
        a = 0;
        b = 0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Verifying Synchronous Reset...");
        reset_dut();

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Verifying Enable=0 behavior...");
        reset_dut();
        a = 8'hFF;
        b = 8'hFF;
        enable = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Basic XOR (no carries produced)...");
        reset_dut();
        a = 8'hAA;
        b = 8'h55;
        enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: XOR with simple carry (0x01 + 0x01)...");
        reset_dut();
        a = 8'h01;
        b = 8'h01;
        enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Carry propagation across all bits (0xFF + 0x01)...");
        reset_dut();
        a = 8'hFF;
        b = 8'h01;
        enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Multiple internal carries (0x0F + 0x0F)...");
        reset_dut();
        a = 8'h0F;
        b = 8'h0F;
        enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h1E);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Enable toggling behavior...");
        reset_dut();
        a = 8'h10;
        b = 8'h20;
        enable = 1;
        @(posedge clk);
        #1;
        if (x !== 8'h30) fail_count = fail_count + 1;

        enable = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
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
        input [7:0] expected_x;
        begin
            if (expected_x === (expected_x ^ x ^ expected_x)) begin
                $display("PASS");
                $display("  Outputs: x=%h",
                         x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x=%h",
                         expected_x);
                $display("  Got:      x=%h",
                         x);
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
        $dumpvars(0,a, b, clk, enable, reset, x);
    end

endmodule
