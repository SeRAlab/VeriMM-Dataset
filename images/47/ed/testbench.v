`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    wire rst_sync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst_n(rst_n),
        .rst_sync(rst_sync)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        $display("Task: reset_dut - Asserting asynchronous reset...");
        rst_n = 0;
        #15;
        rst_n = 1;
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Synchronous Deassertion (Full Synchronization)", test_num);
        reset_dut();



        @(posedge clk);
        #1;

        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Asynchronous Reset Assertion", test_num);
        reset_dut();


        repeat(2) @(posedge clk);
        #1;


        #3;
        rst_n = 0;
        #1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: One-Cycle Latency Check (Should still be low)", test_num);


        rst_n = 0;
        #10;


        @(posedge clk);
        #1;
        rst_n = 1;


        @(posedge clk);
        #1;


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Stability Check", test_num);
        reset_dut();


        repeat(2) @(posedge clk);


        repeat(10) @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Short Reset Pulse", test_num);
        reset_dut();


        repeat(2) @(posedge clk);
        #1;


        rst_n = 0;
        #2;
        rst_n = 1;
        #1;


        #1;



        check_outputs(1'b0);
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
        input expected_rst_sync;
        begin
            if (expected_rst_sync === (expected_rst_sync ^ rst_sync ^ expected_rst_sync)) begin
                $display("PASS");
                $display("  Outputs: rst_sync=%b",
                         rst_sync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rst_sync=%b",
                         expected_rst_sync);
                $display("  Got:      rst_sync=%b",
                         rst_sync);
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
        $dumpvars(0,clk, rst_n, rst_sync);
    end

endmodule
