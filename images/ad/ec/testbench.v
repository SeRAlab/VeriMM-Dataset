`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg async_reset;
    reg clk;
    reg [9:0] d;
    reg sync_reset;
    wire [9:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .async_reset(async_reset),
        .clk(clk),
        .d(d),
        .sync_reset(sync_reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        async_reset = 0;
        forever #5 async_reset = ~async_reset;
    end

        task reset_dut;

        begin
            sync_reset = 0;
            async_reset = 1;
            d = 0;
            #12;
            async_reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Load Data");
            reset_dut();
            d = 10'h2AA;
            sync_reset = 0;
            async_reset = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h2AA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Synchronous Reset");
            reset_dut();

            d = 10'h3FF;
            @(posedge clk);
            #1;

            sync_reset = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Asynchronous Reset");
            reset_dut();

            d = 10'h155;
            @(posedge clk);
            #2;

            #3;
            async_reset = 1;
            #1;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Sync Reset vs Data Priority");
            reset_dut();
            d = 10'h0F0;
            sync_reset = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Async Reset Priority over Sync Reset");
            reset_dut();
            d = 10'h333;
            @(posedge clk);
            #1;

            sync_reset = 1;
            async_reset = 1;
            #1;
            #1;

            check_outputs(10'h000);
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
        input [9:0] expected_q;
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
        $dumpvars(0,async_reset, clk, d, sync_reset, q);
    end

endmodule
