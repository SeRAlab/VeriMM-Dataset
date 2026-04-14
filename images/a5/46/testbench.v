`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg async_in;
    reg clk_sync;
    reg rst_sync;
    wire sync_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .async_in(async_in),
        .clk_sync(clk_sync),
        .rst_sync(rst_sync),
        .sync_out(sync_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_sync = 0;
        forever #5 clk_sync = ~clk_sync;
    end

        task reset_dut;

    begin
        rst_sync = 1;
        async_in = 0;
        @(posedge clk_sync);
        #1;
        rst_sync = 0;
        @(posedge clk_sync);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 0 to 1 Synchronization", test_num);
        reset_dut();
        async_in = 1;

        repeat(3) @(posedge clk_sync);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 1 to 0 Synchronization", test_num);
        reset_dut();

        async_in = 1;
        repeat(3) @(posedge clk_sync);

        async_in = 0;
        repeat(3) @(posedge clk_sync);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset overrides active high input", test_num);
        reset_dut();
        async_in = 1;
        repeat(3) @(posedge clk_sync);
        rst_sync = 1;
        @(posedge clk_sync);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Synchronizing a 4-cycle pulse", test_num);
        reset_dut();
        async_in = 1;
        repeat(4) @(posedge clk_sync);
        async_in = 0;


        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sustained high input check", test_num);
        reset_dut();
        async_in = 1;
        repeat(10) @(posedge clk_sync);
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
        input expected_sync_out;
        begin
            if (expected_sync_out === (expected_sync_out ^ sync_out ^ expected_sync_out)) begin
                $display("PASS");
                $display("  Outputs: sync_out=%b",
                         sync_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sync_out=%b",
                         expected_sync_out);
                $display("  Got:      sync_out=%b",
                         sync_out);
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
        $dumpvars(0,async_in, clk_sync, rst_sync, sync_out);
    end

endmodule
