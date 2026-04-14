`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d1;
    reg d2;
    reg reset;
    reg select;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d1(d1),
        .d2(d2),
        .reset(reset),
        .select(select),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            d1 = 0;
            d2 = 0;
            select = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Executing testcase001: Loading d1=1 and selecting q1");
            reset_dut();
            d1 = 1;
            d2 = 0;
            select = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase002;

        begin
            $display("Executing testcase002: Loading d2=1 and selecting q2");
            reset_dut();
            d1 = 0;
            d2 = 1;
            select = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            $display("Executing testcase003: Switching select after capturing values");
            reset_dut();
            d1 = 1;
            d2 = 0;
            select = 0;
            @(posedge clk);
            #2;
            select = 1;
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Executing testcase004: Synchronous reset with active inputs");
            reset_dut();
            d1 = 1;
            d2 = 1;
            select = 0;
            @(posedge clk);
            #2;
            reset = 1;
            @(posedge clk);
            #2;
            reset = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Executing testcase005: Data persistence check");
            reset_dut();
            d1 = 1;
            d2 = 1;
            select = 0;
            @(posedge clk);
            #2;
            d1 = 0;
            d2 = 0;
            #2;

            #1;


            check_outputs(4'h1);
        end
        endtask

    task testcase006;

        begin
            $display("Executing testcase006: Capturing and selecting zero values");
            reset_dut();
            d1 = 0;
            d2 = 0;
            select = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h0);
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
        $dumpvars(0,clk, d1, d2, reset, select, q);
    end

endmodule
