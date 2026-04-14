`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [47:0] LBA_BEGIN;
    reg [47:0] LBA_END;
    reg SW_RD;
    reg SW_WR;
    reg clk;
    reg nRST;
    reg [7:0] test;
    wire [47:0] begin_LBA;
    wire begin_work;
    wire [47:0] end_LBA;
    wire nWRpRD;
    wire start_RD;
    wire start_WR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .LBA_BEGIN(LBA_BEGIN),
        .LBA_END(LBA_END),
        .SW_RD(SW_RD),
        .SW_WR(SW_WR),
        .clk(clk),
        .nRST(nRST),
        .test(test),
        .begin_LBA(begin_LBA),
        .begin_work(begin_work),
        .end_LBA(end_LBA),
        .nWRpRD(nWRpRD),
        .start_RD(start_RD),
        .start_WR(start_WR)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            nRST = 0;
            SW_WR = 0;
            SW_RD = 0;
            LBA_BEGIN = 0;
            LBA_END = 0;
            test = 0;
            @(posedge clk);
            #1;
            nRST = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Write Operation", test_num);
            reset_dut();

            LBA_BEGIN = 48'hAAAA_BBBB_CCCC;
            LBA_END   = 48'hDDDD_EEEE_FFFF;
            SW_WR     = 1;
            SW_RD     = 0;

            @(posedge clk);
            #1;
            SW_WR     = 0;


            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(48'hAAAA_BBBB_CCCC, 1'b1, 48'hDDDD_EEEE_FFFF, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Read Operation", test_num);
            reset_dut();

            LBA_BEGIN = 48'h1111_2222_3333;
            LBA_END   = 48'h4444_5555_6666;
            SW_WR     = 0;
            SW_RD     = 1;

            @(posedge clk);
            #1;
            SW_RD     = 0;

            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(48'h1111_2222_3333, 1'b1, 48'h4444_5555_6666, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Idle State Check", test_num);
            reset_dut();

            SW_WR = 0;
            SW_RD = 0;

            repeat(3) @(posedge clk);
            #1;


            #1;



            check_outputs(begin_LBA, 1'b0, end_LBA, nWRpRD, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();


            LBA_BEGIN = 48'hFFFF_FFFF_FFFF;
            SW_WR = 1;
            @(posedge clk);
            #1;
            SW_WR = 0;
            @(posedge clk);


            nRST = 0;
            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(begin_LBA, 1'b0, end_LBA, nWRpRD, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Secondary Write Address Check", test_num);
            reset_dut();

            LBA_BEGIN = 48'h1234_5678_9ABC;
            LBA_END   = 48'hFEDC_BA98_7654;
            SW_WR     = 1;

            @(posedge clk);
            #1;
            SW_WR     = 0;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(48'h1234_5678_9ABC, 1'b1, 48'hFEDC_BA98_7654, 1'b0, 1'b0, 1'b1);
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
        input [47:0] expected_begin_LBA;
        input expected_begin_work;
        input [47:0] expected_end_LBA;
        input expected_nWRpRD;
        input expected_start_RD;
        input expected_start_WR;
        begin
            if (expected_begin_LBA === (expected_begin_LBA ^ begin_LBA ^ expected_begin_LBA) &&
                expected_begin_work === (expected_begin_work ^ begin_work ^ expected_begin_work) &&
                expected_end_LBA === (expected_end_LBA ^ end_LBA ^ expected_end_LBA) &&
                expected_nWRpRD === (expected_nWRpRD ^ nWRpRD ^ expected_nWRpRD) &&
                expected_start_RD === (expected_start_RD ^ start_RD ^ expected_start_RD) &&
                expected_start_WR === (expected_start_WR ^ start_WR ^ expected_start_WR)) begin
                $display("PASS");
                $display("  Outputs: begin_LBA=%h, begin_work=%b, end_LBA=%h, nWRpRD=%b, start_RD=%b, start_WR=%b",
                         begin_LBA, begin_work, end_LBA, nWRpRD, start_RD, start_WR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: begin_LBA=%h, begin_work=%b, end_LBA=%h, nWRpRD=%b, start_RD=%b, start_WR=%b",
                         expected_begin_LBA, expected_begin_work, expected_end_LBA, expected_nWRpRD, expected_start_RD, expected_start_WR);
                $display("  Got:      begin_LBA=%h, begin_work=%b, end_LBA=%h, nWRpRD=%b, start_RD=%b, start_WR=%b",
                         begin_LBA, begin_work, end_LBA, nWRpRD, start_RD, start_WR);
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
        $dumpvars(0,LBA_BEGIN, LBA_END, SW_RD, SW_WR, clk, nRST, test, begin_LBA, begin_work, end_LBA, nWRpRD, start_RD, start_WR);
    end

endmodule
