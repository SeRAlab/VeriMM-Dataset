`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg start;
    reg stop;
    wire [7:0] tdc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .start(start),
        .stop(stop),
        .tdc(tdc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            stop = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: 5-cycle interval...");
            test_num = test_num + 1;
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(4) @(posedge clk);

            stop = 1;
            @(posedge clk);
            stop = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: 20-cycle interval...");
            test_num = test_num + 1;
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(19) @(posedge clk);

            stop = 1;
            @(posedge clk);
            stop = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'd20);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Minimum 1-cycle interval...");
            test_num = test_num + 1;
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            stop = 1;
            @(posedge clk);
            stop = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Stability check...");
            test_num = test_num + 1;
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(9) @(posedge clk);

            stop = 1;
            @(posedge clk);
            stop = 0;

            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Large interval (250 cycles)...");
            test_num = test_num + 1;
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(249) @(posedge clk);

            stop = 1;
            @(posedge clk);
            stop = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'd250);
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
        input [7:0] expected_tdc;
        begin
            if (expected_tdc === (expected_tdc ^ tdc ^ expected_tdc)) begin
                $display("PASS");
                $display("  Outputs: tdc=%h",
                         tdc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tdc=%h",
                         expected_tdc);
                $display("  Got:      tdc=%h",
                         tdc);
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
        $dumpvars(0,clk, start, stop, tdc);
    end

endmodule
