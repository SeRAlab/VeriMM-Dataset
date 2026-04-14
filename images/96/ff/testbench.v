`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg start;
    reg stop;
    wire [31:0] elapsed_time;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .start(start),
        .stop(stop),
        .elapsed_time(elapsed_time)
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
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase 001: Measuring 10 clock cycles");
            start = 1;
            @(posedge clk);
            start = 0;
            repeat (9) @(posedge clk);
            stop = 1;
            @(posedge clk);
            stop = 0;
            repeat (2) @(posedge clk);
            #1;

            check_outputs(10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase 002: Minimum duration (1 cycle)");
            start = 1;
            @(posedge clk);
            start = 0;

            stop = 1;
            @(posedge clk);
            stop = 0;
            repeat (2) @(posedge clk);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase 003: Measuring 50 clock cycles");
            start = 1;
            @(posedge clk);
            start = 0;
            repeat (49) @(posedge clk);
            stop = 1;
            @(posedge clk);
            stop = 0;
            repeat (2) @(posedge clk);
            #1;

            check_outputs(50);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase 004: Consecutive measurements (First 15, then 20)");


            start = 1; @(posedge clk); start = 0;
            repeat (14) @(posedge clk);
            stop = 1; @(posedge clk); stop = 0;
            repeat (2) @(posedge clk);


            start = 1; @(posedge clk); start = 0;
            repeat (19) @(posedge clk);
            stop = 1; @(posedge clk); stop = 0;
            repeat (2) @(posedge clk);

            #1;


            check_outputs(20);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase 005: Checking output stability after stop");
            start = 1; @(posedge clk); start = 0;
            repeat (4) @(posedge clk);
            stop = 1; @(posedge clk); stop = 0;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(5);
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
        input [31:0] expected_elapsed_time;
        begin
            if (expected_elapsed_time === (expected_elapsed_time ^ elapsed_time ^ expected_elapsed_time)) begin
                $display("PASS");
                $display("  Outputs: elapsed_time=%h",
                         elapsed_time);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: elapsed_time=%h",
                         expected_elapsed_time);
                $display("  Got:      elapsed_time=%h",
                         elapsed_time);
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
        $dumpvars(0,clk, start, stop, elapsed_time);
    end

endmodule
