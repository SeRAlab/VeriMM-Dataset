`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] ena;
    reg reset;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ena(ena),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        ena = 3'b000;
        @(posedge clk);
        #1 reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase 001: Synchronous Reset");
        reset_dut();

        #1;


        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase 002: Units Digit Increment");
        reset_dut();
        ena = 3'b001;
        repeat(5) @(posedge clk);
        ena = 3'b000;
        #1;
        #1;

        check_outputs(12'h005);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase 003: Units Wrap-around (9->0)");
        reset_dut();
        ena = 3'b001;
        repeat(10) @(posedge clk);
        ena = 3'b000;
        #1;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase 004: Tens Digit Increment");
        reset_dut();
        ena = 3'b010;
        repeat(8) @(posedge clk);
        ena = 3'b000;
        #1;
        #1;

        check_outputs(12'h080);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase 005: Hundreds Digit Increment");
        reset_dut();
        ena = 3'b100;
        repeat(3) @(posedge clk);
        ena = 3'b000;
        #1;
        #1;

        check_outputs(12'h300);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running Testcase 006: Simultaneous Multi-digit Increment");
        reset_dut();
        ena = 3'b111;
        repeat(4) @(posedge clk);
        ena = 3'b000;
        #1;
        #1;

        check_outputs(12'h444);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Running Testcase 007: Full Rollover (999->000)");
        reset_dut();
        ena = 3'b111;
        repeat(9) @(posedge clk);
        @(posedge clk);
        ena = 3'b000;
        #1;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Running Testcase 008: Mixed digit sequence");
        reset_dut();

        ena = 3'b001; repeat(9) @(posedge clk);

        ena = 3'b010; repeat(2) @(posedge clk);

        ena = 3'b100; repeat(1) @(posedge clk);
        ena = 3'b000;
        #1;
        #1;

        check_outputs(12'h129);
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
        input [11:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, ena, reset, q);
    end

endmodule
