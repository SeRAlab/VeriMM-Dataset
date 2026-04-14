`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst_n;
    wire [7:0] cnt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .rst_n(rst_n),
        .cnt(cnt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        en = 0;
        @(posedge clk);
        #1 rst_n = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Initial Reset State", test_num);
        reset_dut();
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Single Shift (1 clock cycle)", test_num);
        reset_dut();
        en = 1;
        @(posedge clk);
        en = 0;
        @(posedge clk);
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Four Shifts", test_num);
        reset_dut();
        en = 1;
        repeat(4) @(posedge clk);
        en = 0;
        @(posedge clk);
        #1;

        check_outputs(8'h10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Enable Low (No movement)", test_num);
        reset_dut();
        en = 0;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Full Rotation (8 clock cycles)", test_num);
        reset_dut();
        en = 1;
        repeat(8) @(posedge clk);
        en = 0;
        @(posedge clk);
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Shift to MSB (7 cycles)", test_num);
        reset_dut();
        en = 1;
        repeat(7) @(posedge clk);
        en = 0;
        @(posedge clk);
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Intermittent Enable", test_num);
        reset_dut();
        en = 1;
        repeat(2) @(posedge clk);
        en = 0;
        repeat(3) @(posedge clk);
        en = 1;
        repeat(1) @(posedge clk);
        en = 0;
        @(posedge clk);
        #1;

        check_outputs(8'h08);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Multiple Wrap-arounds (19 cycles)", test_num);
        reset_dut();
        en = 1;
        repeat(19) @(posedge clk);
        en = 0;
        @(posedge clk);
        #1;

        check_outputs(8'h08);
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
        input [7:0] expected_cnt;
        begin
            if (expected_cnt === (expected_cnt ^ cnt ^ expected_cnt)) begin
                $display("PASS");
                $display("  Outputs: cnt=%h",
                         cnt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cnt=%h",
                         expected_cnt);
                $display("  Got:      cnt=%h",
                         cnt);
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
        $dumpvars(0,clk, en, rst_n, cnt);
    end

endmodule
