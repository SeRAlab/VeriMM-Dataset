`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_50M;
    reg rst;
    wire clk_1Khz;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_50M(clk_50M),
        .rst(rst),
        .clk_1Khz(clk_1Khz)
    );

    // Clock generation (10ns period)
    initial begin
        clk_50M = 0;
        forever #5 clk_50M = ~clk_50M;
    end

        task reset_dut;

        begin
            rst = 1;
            repeat(10) @(posedge clk_50M);
            #2 rst = 0;
            @(posedge clk_50M);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Initial Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Mid-phase Check (Cycles=12500)", test_num);
            reset_dut();
            repeat(12500) @(posedge clk_50M);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: First Toggle Check (Cycles=25000)", test_num);
            reset_dut();
            repeat(25000) @(posedge clk_50M);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Full Period Check (Cycles=50000)", test_num);
            reset_dut();
            repeat(50000) @(posedge clk_50M);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Multi-toggle Check (Cycles=75000)", test_num);
            reset_dut();
            repeat(75000) @(posedge clk_50M);
            #1;
            #1;

            check_outputs(1'b1);
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
        input expected_clk_1Khz;
        begin
            if (expected_clk_1Khz === (expected_clk_1Khz ^ clk_1Khz ^ expected_clk_1Khz)) begin
                $display("PASS");
                $display("  Outputs: clk_1Khz=%b",
                         clk_1Khz);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_1Khz=%b",
                         expected_clk_1Khz);
                $display("  Got:      clk_1Khz=%b",
                         clk_1Khz);
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
        $dumpvars(0,clk_50M, rst, clk_1Khz);
    end

endmodule
