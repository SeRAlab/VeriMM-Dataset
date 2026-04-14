`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg sync_reset;
    wire [2:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .sync_reset(sync_reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        sync_reset = 1;
        @(posedge clk);
        #1;
        sync_reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %0d: Initial Reset Check", test_num);
        reset_dut();
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %0d: Single Increment Check", test_num);
        reset_dut();
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %0d: Count to Max (7)", test_num);
        reset_dut();
        repeat(7) @(posedge clk);
        #1;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %0d: Rollover Check (8 cycles)", test_num);
        reset_dut();
        repeat(8) @(posedge clk);
        #1;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase %0d: Mid-count Synchronous Reset", test_num);
        reset_dut();
        repeat(4) @(posedge clk);
        sync_reset = 1;
        @(posedge clk);
        sync_reset = 0;
        #1;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running Testcase %0d: Multi-cycle Increment (3 cycles)", test_num);
        reset_dut();
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(3'd3);
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
        input [2:0] expected_q;
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
        $dumpvars(0,clk, sync_reset, q);
    end

endmodule
