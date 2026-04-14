`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg reset_n;
    wire [9:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .reset_n(reset_n),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en = 0;
            reset_n = 0;
            @(posedge clk);
            #1;
            reset_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset behavior", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic increment (5 cycles)", test_num);
            reset_dut();
            en = 1;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(10'h005);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Enable signal toggle logic", test_num);
            reset_dut();
            en = 1;
            repeat (10) @(posedge clk);
            en = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(10'h00A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Rollover (0x3FF -> 0x000)", test_num);
            reset_dut();
            en = 1;


            repeat (1024) @(posedge clk);
            #1;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Synchronous reset while counting", test_num);
            reset_dut();
            en = 1;
            repeat (50) @(posedge clk);
            reset_n = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h000);
            reset_n = 1;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Long count sequence to specific value", test_num);
            reset_dut();
            en = 1;
            repeat (512) @(posedge clk);
            #1;
            #1;

            check_outputs(10'h200);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Reset priority over Enable", test_num);
            reset_dut();
            en = 1;
            repeat (5) @(posedge clk);
            reset_n = 0;
            en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h000);
            reset_n = 1;
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
        $dumpvars(0,clk, en, reset_n, q);
    end

endmodule
