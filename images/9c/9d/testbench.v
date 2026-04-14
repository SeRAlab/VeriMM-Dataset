`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_8f;
    reg enb;
    reg rst;
    wire clk_2f;
    wire clk_f;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_8f(clk_8f),
        .enb(enb),
        .rst(rst),
        .clk_2f(clk_2f),
        .clk_f(clk_f)
    );

    // Clock generation (10ns period)
    initial begin
        clk_8f = 0;
        forever #5 clk_8f = ~clk_8f;
    end

        task reset_dut;

        begin
            rst = 1;
            enb = 0;
            @(posedge clk_8f);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Checking first toggle of clk_2f (2 cycles)", test_num);
            reset_dut();
            enb = 1;
            repeat(2) @(posedge clk_8f);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Checking first toggle of clk_f (4 cycles)", test_num);
            reset_dut();
            enb = 1;
            repeat(4) @(posedge clk_8f);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Checking state after 6 cycles", test_num);
            reset_dut();
            enb = 1;
            repeat(6) @(posedge clk_8f);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Full cycle completion (8 cycles)", test_num);
            reset_dut();
            enb = 1;
            repeat(8) @(posedge clk_8f);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Testing Enable gating (freeze)", test_num);
            reset_dut();
            enb = 1;
            repeat(2) @(posedge clk_8f);
            enb = 0;
            repeat(4) @(posedge clk_8f);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Testing Reset during operation", test_num);
            reset_dut();
            enb = 1;
            repeat(6) @(posedge clk_8f);
            rst = 1;
            @(posedge clk_8f);
            #1;
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
        input expected_clk_2f;
        input expected_clk_f;
        begin
            if (expected_clk_2f === (expected_clk_2f ^ clk_2f ^ expected_clk_2f) &&
                expected_clk_f === (expected_clk_f ^ clk_f ^ expected_clk_f)) begin
                $display("PASS");
                $display("  Outputs: clk_2f=%b, clk_f=%b",
                         clk_2f, clk_f);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_2f=%b, clk_f=%b",
                         expected_clk_2f, expected_clk_f);
                $display("  Got:      clk_2f=%b, clk_f=%b",
                         clk_2f, clk_f);
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
        $dumpvars(0,clk_8f, enb, rst, clk_2f, clk_f);
    end

endmodule
