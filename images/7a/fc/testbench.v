`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce1us;
    reg clk;
    reg [15:0] sqX;
    wire imp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce1us(ce1us),
        .clk(clk),
        .sqX(sqX),
        .imp(imp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ce1us = 0;
            sqX = 16'd0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: sqX = 10...");
            reset_dut();
            sqX = 16'd10;
            ce1us = 1;

            repeat (9) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: sqX = 1 (Boundary)...");
            reset_dut();
            sqX = 16'd1;
            ce1us = 0;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: ce1us gating...");
            reset_dut();
            sqX = 16'd4;
            ce1us = 1;
            repeat (2) @(posedge clk);
            ce1us = 0;
            repeat (5) @(posedge clk);
            ce1us = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Wrap-around...");
            reset_dut();
            sqX = 16'd3;
            ce1us = 1;
            repeat (2) @(posedge clk);
            @(posedge clk);
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
        input expected_imp;
        begin
            if (expected_imp === (expected_imp ^ imp ^ expected_imp)) begin
                $display("PASS");
                $display("  Outputs: imp=%b",
                         imp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: imp=%b",
                         expected_imp);
                $display("  Got:      imp=%b",
                         imp);
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
        $dumpvars(0,ce1us, clk, sqX, imp);
    end

endmodule
