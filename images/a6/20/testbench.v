`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] delay;
    reg in;
    reg reset;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .delay(delay),
        .in(in),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 0;
            delay = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Counter basic increment...");
            reset_dut();

            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Delay 0 (1-cycle delay)...");
            reset_dut();
            in = 1;
            delay = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Delay 3 (4-cycle delay)...");
            reset_dut();
            in = 1;
            delay = 3;
            @(posedge clk);
            in = 0;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Counter overflow (4-bit wrap)...");
            reset_dut();
            in = 0;
            repeat(16) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Bitwise OR logic check...");
            reset_dut();
            in = 1;
            delay = 1;
            @(posedge clk);
            in = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Synchronous reset mid-operation...");
            reset_dut();
            repeat(3) @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Multiple samples and delay switching...");
            reset_dut();
            in = 1;
            @(posedge clk);
            in = 1;
            @(posedge clk);
            in = 0;
            @(posedge clk);
            delay = 1;
            #1;

            #1;


            check_outputs(4'd3);
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
        testcase007();
        
        
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
        input [3:0] expected_q;
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
        $dumpvars(0,clk, delay, in, reset, q);
    end

endmodule
