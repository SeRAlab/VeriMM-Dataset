`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk_en;
    reg rst;
    reg zero;
    wire [14:0] eg_cnt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk_en(clk_en),
        .rst(rst),
        .zero(zero),
        .eg_cnt(eg_cnt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            clk_en = 0;
            zero = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase 001: Initial Reset Check");
            #1;

            check_outputs(15'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase 002: 3 Active Cycles (Increment by 1)");
            clk_en = 1;
            zero = 1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(15'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase 003: 9 Active Cycles (Increment by 3)");
            clk_en = 1;
            zero = 1;
            repeat(9) @(posedge clk);
            #1;
            #1;

            check_outputs(15'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase 004: clk_en Gating Test");

            clk_en = 1; zero = 1;
            repeat(2) @(posedge clk);

            clk_en = 0; zero = 1;
            repeat(5) @(posedge clk);

            clk_en = 1; zero = 1;
            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(15'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase 005: zero Signal Gating Test");

            clk_en = 1; zero = 1;
            repeat(2) @(posedge clk);

            clk_en = 1; zero = 0;
            repeat(5) @(posedge clk);

            clk_en = 1; zero = 1;
            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(15'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase 006: 30 Active Cycles (Increment by 10)");
            clk_en = 1;
            zero = 1;
            repeat(30) @(posedge clk);
            #1;
            #1;

            check_outputs(15'd10);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Testcase 007: Mid-count Asynchronous Reset");
            clk_en = 1;
            zero = 1;
            repeat(5) @(posedge clk);
            #2 rst = 1;
            #1;
            #1;

            check_outputs(15'd0);
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
        input [14:0] expected_eg_cnt;
        begin
            if (expected_eg_cnt === (expected_eg_cnt ^ eg_cnt ^ expected_eg_cnt)) begin
                $display("PASS");
                $display("  Outputs: eg_cnt=%h",
                         eg_cnt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eg_cnt=%h",
                         expected_eg_cnt);
                $display("  Got:      eg_cnt=%h",
                         eg_cnt);
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
        $dumpvars(0,clk, clk_en, rst, zero, eg_cnt);
    end

endmodule
