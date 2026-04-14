`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire blank_n;
    wire hs;
    wire vs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .blank_n(blank_n),
        .hs(hs),
        .vs(vs)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            repeat(5) @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();

            repeat(10) @(posedge clk);
            #1;
            $display("Testcase %0d: Verifying Active Video Region...", test_num);
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();

            repeat(645) @(posedge clk);
            #1;
            $display("Testcase %0d: Verifying Horizontal Front Porch (Blanking)...", test_num);
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();

            repeat(666) @(posedge clk);
            #1;
            $display("Testcase %0d: Verifying Horizontal Sync Pulse...", test_num);
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();


            repeat(800 * 481 + 10) @(posedge clk);
            #1;
            $display("Testcase %0d: Verifying Vertical Blanking Region...", test_num);
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();


            repeat(800 * 490 + 10) @(posedge clk);
            #1;
            $display("Testcase %0d: Verifying Vertical Sync Pulse...", test_num);
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
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
        input expected_blank_n;
        input expected_hs;
        input expected_vs;
        begin
            if (expected_blank_n === (expected_blank_n ^ blank_n ^ expected_blank_n) &&
                expected_hs === (expected_hs ^ hs ^ expected_hs) &&
                expected_vs === (expected_vs ^ vs ^ expected_vs)) begin
                $display("PASS");
                $display("  Outputs: blank_n=%b, hs=%b, vs=%b",
                         blank_n, hs, vs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: blank_n=%b, hs=%b, vs=%b",
                         expected_blank_n, expected_hs, expected_vs);
                $display("  Got:      blank_n=%b, hs=%b, vs=%b",
                         blank_n, hs, vs);
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
        $dumpvars(0,clk, rst, blank_n, hs, vs);
    end

endmodule
