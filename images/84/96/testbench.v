`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg async_in;
    reg clk;
    reg rst_n;
    wire sync_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .async_in(async_in),
        .clk(clk),
        .rst_n(rst_n),
        .sync_out(sync_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            async_in = 1'b1;
            #20;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase 001: Verifying Reset State (sync_out should be 1)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase 002: Propagation of LOW signal (1 -> 0 transition)");

            @(negedge clk);
            async_in = 1'b0;


            @(negedge clk);
            @(negedge clk);
            #2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase 003: Propagation of HIGH signal (0 -> 1 transition)");


            @(negedge clk);
            async_in = 1'b0;
            repeat(2) @(negedge clk);


            async_in = 1'b1;
            repeat(2) @(negedge clk);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase 004: Successive transitions (1 -> 0 -> 1)");

            async_in = 1'b0;
            @(negedge clk);
            async_in = 1'b1;
            @(negedge clk);
            async_in = 1'b0;


            repeat(3) @(negedge clk);
            #2;

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
        $dumpvars(0,async_in, clk, rst_n, sync_out);
    end

endmodule
