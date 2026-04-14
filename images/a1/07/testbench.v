`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg cnt_clk;
    reg cnt_en;
    reg fifo_reset;
    reg scan_cnt_clr;
    wire [10:0] scan_cnt_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cnt_clk(cnt_clk),
        .cnt_en(cnt_en),
        .fifo_reset(fifo_reset),
        .scan_cnt_clr(scan_cnt_clr),
        .scan_cnt_num(scan_cnt_num)
    );

    // Clock generation (10ns period)
    initial begin
        cnt_clk = 0;
        forever #5 cnt_clk = ~cnt_clk;
    end

        task reset_dut;

        begin
            fifo_reset = 1;
            cnt_en = 0;
            scan_cnt_clr = 0;
            repeat(2) @(posedge cnt_clk);
            fifo_reset = 0;
            repeat(1) @(posedge cnt_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic 10-count check", test_num);
            reset_dut();

            cnt_en = 1;
            repeat(10) @(posedge cnt_clk);
            cnt_en = 0;


            @(posedge cnt_clk);
            scan_cnt_clr = 1;
            repeat(2) @(posedge cnt_clk);

            #1;


            check_outputs(11'd10);
            scan_cnt_clr = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Count enable check", test_num);
            reset_dut();

            cnt_en = 1;
            repeat(5) @(posedge cnt_clk);
            cnt_en = 0;
            repeat(10) @(posedge cnt_clk);
            cnt_en = 1;
            repeat(5) @(posedge cnt_clk);

            @(posedge cnt_clk);
            scan_cnt_clr = 1;
            repeat(2) @(posedge cnt_clk);

            #1;


            check_outputs(11'd10);
            scan_cnt_clr = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Consecutive captures", test_num);
            reset_dut();


            cnt_en = 1;
            repeat(15) @(posedge cnt_clk);
            scan_cnt_clr = 1;
            repeat(1) @(posedge cnt_clk);
            scan_cnt_clr = 0;


            repeat(25) @(posedge cnt_clk);
            scan_cnt_clr = 1;
            repeat(2) @(posedge cnt_clk);

            #1;


            check_outputs(11'd25);
            scan_cnt_clr = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();

            cnt_en = 1;
            repeat(50) @(posedge cnt_clk);

            fifo_reset = 1;
            repeat(2) @(posedge cnt_clk);
            fifo_reset = 0;

            repeat(12) @(posedge cnt_clk);
            scan_cnt_clr = 1;
            repeat(2) @(posedge cnt_clk);

            #1;


            check_outputs(11'd12);
            scan_cnt_clr = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Max count check (2047)", test_num);
            reset_dut();

            cnt_en = 1;
            repeat(2047) @(posedge cnt_clk);
            cnt_en = 0;

            scan_cnt_clr = 1;
            repeat(2) @(posedge cnt_clk);

            #1;


            check_outputs(11'd2047);
            scan_cnt_clr = 0;
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
        input [10:0] expected_scan_cnt_num;
        begin
            if (expected_scan_cnt_num === (expected_scan_cnt_num ^ scan_cnt_num ^ expected_scan_cnt_num)) begin
                $display("PASS");
                $display("  Outputs: scan_cnt_num=%h",
                         scan_cnt_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: scan_cnt_num=%h",
                         expected_scan_cnt_num);
                $display("  Got:      scan_cnt_num=%h",
                         scan_cnt_num);
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
        $dumpvars(0,cnt_clk, cnt_en, fifo_reset, scan_cnt_clr, scan_cnt_num);
    end

endmodule
