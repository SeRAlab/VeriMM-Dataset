`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg PCLK;
    reg [11:0] VtcHCnt;
    reg [10:0] VtcVCnt;
    reg [11:0] center_h;
    reg [10:0] center_v;
    wire [3:0] weight;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PCLK(PCLK),
        .VtcHCnt(VtcHCnt),
        .VtcVCnt(VtcVCnt),
        .center_h(center_h),
        .center_v(center_v),
        .weight(weight)
    );

    // Clock generation (10ns period)
    initial begin
        PCLK = 0;
        forever #5 PCLK = ~PCLK;
    end

        task reset_dut;

        begin
            VtcHCnt <= 0;
            VtcVCnt <= 0;
            center_h <= 0;
            center_v <= 0;
            @(posedge PCLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Perfect center match");
            center_h = 12'd500;
            center_v = 11'd400;
            VtcHCnt  = 12'd500;
            VtcVCnt  = 11'd400;
            @(posedge PCLK);
            #2;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Small horizontal offset");
            center_h = 12'd500;
            center_v = 11'd400;
            VtcHCnt  = 12'd501;
            VtcVCnt  = 11'd400;
            @(posedge PCLK);
            #2;
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: Small vertical offset");
            center_h = 12'd500;
            center_v = 11'd400;
            VtcHCnt  = 12'd500;
            VtcVCnt  = 11'd401;
            @(posedge PCLK);
            #2;
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: Moderate distance");
            center_h = 12'd500;
            center_v = 11'd400;
            VtcHCnt  = 12'd510;
            VtcVCnt  = 11'd405;
            @(posedge PCLK);
            #2;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: Far distance");
            center_h = 12'd100;
            center_v = 11'd100;
            VtcHCnt  = 12'd1000;
            VtcVCnt  = 11'd800;
            @(posedge PCLK);
            #2;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Testcase 006: Max boundary values");
            center_h = 12'hFFF;
            center_v = 11'h7FF;
            VtcHCnt  = 12'hFFF;
            VtcVCnt  = 11'h7FF;
            @(posedge PCLK);
            #2;
            #1;

            check_outputs(4'd15);
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
        input [3:0] expected_weight;
        begin
            if (expected_weight === (expected_weight ^ weight ^ expected_weight)) begin
                $display("PASS");
                $display("  Outputs: weight=%h",
                         weight);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: weight=%h",
                         expected_weight);
                $display("  Got:      weight=%h",
                         weight);
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
        $dumpvars(0,PCLK, VtcHCnt, VtcVCnt, center_h, center_v, weight);
    end

endmodule
