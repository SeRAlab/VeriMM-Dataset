`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg i_de;
    reg i_hs;
    reg i_vs;
    reg rst_n;
    reg th_flag;
    wire hs_fall;
    wire hs_rise;
    wire th_fall;
    wire th_rise;
    wire vs_fall;
    wire vs_rise;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i_de(i_de),
        .i_hs(i_hs),
        .i_vs(i_vs),
        .rst_n(rst_n),
        .th_flag(th_flag),
        .hs_fall(hs_fall),
        .hs_rise(hs_rise),
        .th_fall(th_fall),
        .th_rise(th_rise),
        .vs_fall(vs_fall),
        .vs_rise(vs_rise)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            i_de = 0;
            i_hs = 0;
            i_vs = 0;
            th_flag = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: i_hs Rising Edge Detection");
            reset_dut();
            @(posedge clk);
            i_hs = 0;
            @(posedge clk);
            i_hs = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: i_hs Falling Edge Detection");
            reset_dut();
            @(posedge clk);
            i_hs = 1;
            @(posedge clk);
            i_hs = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: i_vs Rising Edge Detection");
            reset_dut();
            @(posedge clk);
            i_vs = 0;
            @(posedge clk);
            i_vs = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: i_vs Falling Edge Detection");
            reset_dut();
            @(posedge clk);
            i_vs = 1;
            @(posedge clk);
            i_vs = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: th_flag Rising Edge Detection");
            reset_dut();
            @(posedge clk);
            th_flag = 0;
            @(posedge clk);
            th_flag = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: th_flag Falling Edge Detection");
            reset_dut();
            @(posedge clk);
            th_flag = 1;
            @(posedge clk);
            th_flag = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Concurrent Rising Edge Detection");
            reset_dut();
            @(posedge clk);
            i_hs = 0; i_vs = 0; th_flag = 0;
            @(posedge clk);
            i_hs = 1; i_vs = 1; th_flag = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0, 1, 0, 1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Concurrent Falling Edge Detection");
            reset_dut();
            @(posedge clk);
            i_hs = 1; i_vs = 1; th_flag = 1;
            @(posedge clk);
            i_hs = 0; i_vs = 0; th_flag = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 1, 0, 1, 0);
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
        input expected_hs_fall;
        input expected_hs_rise;
        input expected_th_fall;
        input expected_th_rise;
        input expected_vs_fall;
        input expected_vs_rise;
        begin
            if (expected_hs_fall === (expected_hs_fall ^ hs_fall ^ expected_hs_fall) &&
                expected_hs_rise === (expected_hs_rise ^ hs_rise ^ expected_hs_rise) &&
                expected_th_fall === (expected_th_fall ^ th_fall ^ expected_th_fall) &&
                expected_th_rise === (expected_th_rise ^ th_rise ^ expected_th_rise) &&
                expected_vs_fall === (expected_vs_fall ^ vs_fall ^ expected_vs_fall) &&
                expected_vs_rise === (expected_vs_rise ^ vs_rise ^ expected_vs_rise)) begin
                $display("PASS");
                $display("  Outputs: hs_fall=%b, hs_rise=%b, th_fall=%b, th_rise=%b, vs_fall=%b, vs_rise=%b",
                         hs_fall, hs_rise, th_fall, th_rise, vs_fall, vs_rise);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hs_fall=%b, hs_rise=%b, th_fall=%b, th_rise=%b, vs_fall=%b, vs_rise=%b",
                         expected_hs_fall, expected_hs_rise, expected_th_fall, expected_th_rise, expected_vs_fall, expected_vs_rise);
                $display("  Got:      hs_fall=%b, hs_rise=%b, th_fall=%b, th_rise=%b, vs_fall=%b, vs_rise=%b",
                         hs_fall, hs_rise, th_fall, th_rise, vs_fall, vs_rise);
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
        $dumpvars(0,clk, i_de, i_hs, i_vs, rst_n, th_flag, hs_fall, hs_rise, th_fall, th_rise, vs_fall, vs_rise);
    end

endmodule
