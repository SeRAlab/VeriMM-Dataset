`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] BIN;
    reg clk;
    reg rst;
    wire [3:0] GRAY;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BIN(BIN),
        .clk(clk),
        .rst(rst),
        .GRAY(GRAY)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        BIN = 0;
        @(posedge clk);
        #2;
        rst = 0;
        @(posedge clk);
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        BIN = 4'b0000;
        @(posedge clk);
        #2;
        $display("Testcase 001: BIN=0000");
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        BIN = 4'b0001;
        @(posedge clk);
        #2;
        $display("Testcase 002: BIN=0001");
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        BIN = 4'b0010;
        @(posedge clk);
        #2;
        $display("Testcase 003: BIN=0010");
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        BIN = 4'b0111;
        @(posedge clk);
        #2;
        $display("Testcase 004: BIN=0111");
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        BIN = 4'b1000;
        @(posedge clk);
        #2;
        $display("Testcase 005: BIN=1000");
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        BIN = 4'b1111;
        @(posedge clk);
        #2;
        $display("Testcase 006: BIN=1111");
        #1;

        check_outputs(4'b1000);
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
        input [3:0] expected_GRAY;
        begin
            if (expected_GRAY === (expected_GRAY ^ GRAY ^ expected_GRAY)) begin
                $display("PASS");
                $display("  Outputs: GRAY=%h",
                         GRAY);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GRAY=%h",
                         expected_GRAY);
                $display("  Got:      GRAY=%h",
                         GRAY);
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
        $dumpvars(0,BIN, clk, rst, GRAY);
    end

endmodule
