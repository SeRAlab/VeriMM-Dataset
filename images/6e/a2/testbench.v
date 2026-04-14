`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg shift_in;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .shift_in(shift_in),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            shift_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Checking Synchronous Reset value...");
            reset_dut();
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Single Right Shift with shift_in=0...");
            reset_dut();
            shift_in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h091A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Single Right Shift with shift_in=1...");
            reset_dut();
            shift_in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h891A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Shifting in 16 zeros...");
            reset_dut();
            shift_in = 0;
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Shifting in 16 ones...");
            reset_dut();
            shift_in = 1;
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Shifting mixed sequence (1, 0, 1, 1)...");
            reset_dut();
            @(posedge clk) shift_in = 1;
            @(posedge clk) shift_in = 0;
            @(posedge clk) shift_in = 1;
            @(posedge clk) shift_in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hD123);
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
        input [15:0] expected_q;
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
        $dumpvars(0,clk, reset, shift_in, q);
    end

endmodule
