`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg c;
    reg clk;
    reg e;
    reg i;
    reg n;
    reg rst;
    wire [2:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c(c),
        .clk(clk),
        .e(e),
        .i(i),
        .n(n),
        .rst(rst),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            n = 0; i = 0; c = 0; e = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Initial state after reset");
            reset_dut();

            #1;


            check_outputs(3'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Transition 1 -> 2 (n=1)");
            reset_dut();
            n = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Transition 1 -> 2 -> 3 (n=1, i=1)");
            reset_dut();
            n = 1; @(posedge clk); #1;
            n = 0; i = 1; @(posedge clk); #1;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Transition 1 -> 2 -> 3 -> 4 (n=1, i=1, c=1)");
            reset_dut();
            n = 1; @(posedge clk); #1;
            n = 0; i = 1; @(posedge clk); #1;
            i = 0; c = 1; @(posedge clk); #1;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Transition 1 -> 2 -> 3 -> 4 -> 6 (n, i, c, e sequence)");
            reset_dut();
            n = 1; @(posedge clk); #1;
            n = 0; i = 1; @(posedge clk); #1;
            i = 0; c = 1; @(posedge clk); #1;
            c = 0; e = 1; @(posedge clk); #1;
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Transition 1 -> 2 -> 3 -> 4 -> 6 -> 7");
            reset_dut();
            n = 1; @(posedge clk); #1;
            n = 0; i = 1; @(posedge clk); #1;
            i = 0; c = 1; @(posedge clk); #1;
            c = 0; e = 1; @(posedge clk); #1;
            e = 0; @(posedge clk); #1;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Wrong input at state 1 (n=0)");
            reset_dut();
            n = 0; i = 1; c = 1; e = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Reset from State 3");
            reset_dut();
            n = 1; @(posedge clk); #1;
            n = 0; i = 1; @(posedge clk); #1;
            rst = 1; @(posedge clk); #1;
            rst = 0;
            #1;

            check_outputs(3'd1);
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
        testcase008();
        
        
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
        input [2:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,c, clk, e, i, n, rst, Q);
    end

endmodule
