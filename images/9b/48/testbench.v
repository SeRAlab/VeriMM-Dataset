`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pwr_on;
    wire rst;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pwr_on(pwr_on),
        .rst(rst)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            pwr_on = 0;
            @(posedge clk);
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying reset de-assertion after long duration...", test_num);
            reset_dut();
            pwr_on = 1;

            repeat (100) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verifying reset assertion immediately after power-on...", test_num);
            reset_dut();
            pwr_on = 1;

            repeat (2) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verifying rst behavior when pwr_on is low...", test_num);
            reset_dut();
            repeat (10) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verifying power cycle recovery...", test_num);
            reset_dut();
            pwr_on = 1;
            repeat (50) @(posedge clk);
            pwr_on = 0;
            repeat (10) @(posedge clk);
            pwr_on = 1;
            repeat (100) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(0);
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
        input expected_rst;
        begin
            if (expected_rst === (expected_rst ^ rst ^ expected_rst)) begin
                $display("PASS");
                $display("  Outputs: rst=%b",
                         rst);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rst=%b",
                         expected_rst);
                $display("  Got:      rst=%b",
                         rst);
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
        $dumpvars(0,clk, pwr_on, rst);
    end

endmodule
