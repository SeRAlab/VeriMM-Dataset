`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire sync_reset;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .sync_reset(sync_reset)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 0;

        repeat(3) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("\nTest Case %0d: Assert Reset", test_num);

        reset = 1;

        repeat(2) @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("\nTest Case %0d: Deassert Reset", test_num);


        reset = 1;
        repeat(2) @(posedge clk);


        reset = 0;
        repeat(2) @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("\nTest Case %0d: Latency Verification (1 Cycle)", test_num);

        reset = 1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("\nTest Case %0d: Asynchronous Transition Timing", test_num);

        #3;
        reset = 1;

        repeat(2) @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("\nTest Case %0d: Sustained Assertion", test_num);

        reset = 1;
        repeat(5) @(posedge clk);
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
        input expected_sync_reset;
        begin
            if (expected_sync_reset === (expected_sync_reset ^ sync_reset ^ expected_sync_reset)) begin
                $display("PASS");
                $display("  Outputs: sync_reset=%b",
                         sync_reset);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sync_reset=%b",
                         expected_sync_reset);
                $display("  Got:      sync_reset=%b",
                         sync_reset);
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
        $dumpvars(0,clk, reset, sync_reset);
    end

endmodule
