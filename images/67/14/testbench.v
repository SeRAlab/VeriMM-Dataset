`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg mode;
    reg rst;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .mode(mode),
        .rst(rst),
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
        en = 0;
        mode = 0;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Verifying Reset state...");
        reset_dut();
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Counting up for 5 cycles...");
        reset_dut();
        en = 1;
        mode = 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Counting down from 0 (wrap to 15)...");
        reset_dut();
        en = 1;
        mode = 1;
        repeat(1) @(posedge clk);
        #1;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Verifying enable signal (pause counter)...");
        reset_dut();
        en = 1;
        mode = 0;
        repeat(3) @(posedge clk);
        #1;
        en = 0;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Verifying wrap-around from 15 to 0...");
        reset_dut();
        en = 1;
        mode = 0;
        repeat(16) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Counting down 4 steps from 0...");
        reset_dut();
        en = 1;
        mode = 1;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Switching mode from Up to Down mid-sequence...");
        reset_dut();
        en = 1;
        mode = 0;
        repeat(10) @(posedge clk);
        #1;
        mode = 1;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Counter disabled while toggling mode...");
        reset_dut();
        en = 1;
        mode = 0;
        repeat(2) @(posedge clk);
        #1;
        en = 0;
        mode = 1;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h2);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: Full cycle up (17 steps)...");
        reset_dut();
        en = 1;
        mode = 0;
        repeat(17) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: Complex sequence (Up, Down, Disable, Up)...");
        reset_dut();
        en = 1; mode = 0; repeat(5) @(posedge clk);
        #1;
        en = 1; mode = 1; repeat(2) @(posedge clk);
        #1;
        en = 0; mode = 0; repeat(4) @(posedge clk);
        #1;
        en = 1; mode = 0; repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h5);
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
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, en, mode, rst, count);
    end

endmodule
