`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_l;
    reg start;
    reg stopnclear;
    reg tick;
    wire busy;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst_l(rst_l),
        .start(start),
        .stopnclear(stopnclear),
        .tick(tick),
        .busy(busy),
        .error(error)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_l = 0;
            start = 0;
            stopnclear = 0;
            tick = 0;
            @(posedge clk);
            #1 rst_l = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Initial IDLE state", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Transition to COUNTING", test_num);
            reset_dut();
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            tick = 1;
            repeat (2) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Count to OVERFLOW state", test_num);
            reset_dut();
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            tick = 1;

            repeat (20) @(posedge clk);
            tick = 0;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Stop and Clear while COUNTING", test_num);
            reset_dut();
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            tick = 1;
            repeat (5) @(posedge clk);
            stopnclear = 1;
            @(posedge clk);
            stopnclear = 0;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Set Error flag in OVERFLOW", test_num);
            reset_dut();

            start = 1;
            @(posedge clk);
            start = 0;
            tick = 1;
            repeat (20) @(posedge clk);
            tick = 0;

            start = 1;
            @(posedge clk);
            start = 0;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Clear Error using stopnclear", test_num);
            reset_dut();

            start = 1;
            @(posedge clk);
            start = 0;
            tick = 1;
            repeat (20) @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            stopnclear = 1;
            @(posedge clk);
            stopnclear = 0;

            #1;


            check_outputs(1'b0, 1'b0);
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
        input expected_busy;
        input expected_error;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, error=%b",
                         busy, error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, error=%b",
                         expected_busy, expected_error);
                $display("  Got:      busy=%b, error=%b",
                         busy, error);
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
        $dumpvars(0,clk, rst_l, start, stopnclear, tick, busy, error);
    end

endmodule
