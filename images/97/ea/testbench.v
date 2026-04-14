`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
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
            enable = 0;
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Basic Reset", test_num);
            reset_dut();
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Counting Increment (4 steps)", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            repeat (4) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Max Value Wrap Around (0-9 then 0)", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            repeat (10) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Enable Control (Pause at 3)", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            repeat (3) @(negedge clk);
            enable = 0;
            repeat (3) @(negedge clk);
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Cycle and Beyond (0-9-0-1-2)", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            repeat (12) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Asynchronous Reset Mid-Count", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            repeat (5) @(negedge clk);
            #2 reset = 1;
            #2 #1;
 check_outputs(4'd0);
            reset = 0;
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
        $dumpvars(0,clk, enable, reset, q);
    end

endmodule
