`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg async_reset;
    reg clk;
    reg reset;
    wire sync_reset;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .async_reset(async_reset),
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
        reset = 1;
        async_reset = 0;
        @(negedge clk);
        reset = 0;
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Initialization check", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Assertion of async_reset", test_num);
        reset_dut();
        @(negedge clk);
        async_reset = 1;

        repeat(3) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: De-assertion of async_reset", test_num);
        reset_dut();

        @(negedge clk);
        async_reset = 1;
        repeat(3) @(posedge clk);

        @(negedge clk);
        async_reset = 0;

        repeat(3) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Internal reset override", test_num);
        reset_dut();
        @(negedge clk);
        async_reset = 1;
        repeat(3) @(posedge clk);

        reset = 1;
        @(negedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Stable pulse synchronization", test_num);
        reset_dut();
        @(negedge clk);
        async_reset = 1;
        @(posedge clk);
        @(posedge clk);
        @(negedge clk);
        async_reset = 0;


        repeat(1) @(posedge clk);
        #2;
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
        $dumpvars(0,async_reset, clk, reset, sync_reset);
    end

endmodule
