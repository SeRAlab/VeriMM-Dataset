`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst_n;
    reg [7:0] rst_val;
    wire [7:0] gry_cnt;
    wire [7:0] gry_cnt_nxt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .rst_n(rst_n),
        .rst_val(rst_val),
        .gry_cnt(gry_cnt),
        .gry_cnt_nxt(gry_cnt_nxt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [7:0] val;
        begin
            @(negedge clk);
            rst_n = 0;
            rst_val = val;
            en = 0;
            @(negedge clk);
            rst_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reset to 0x00, En=0", test_num);
            reset_dut(8'h00);

            #1;


            check_outputs(bin_to_gray(8'h00), bin_to_gray(8'h00));
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Reset to 0x05, En=1", test_num);
            reset_dut(8'h05);
            en = 1;
            #1;

            #1;


            check_outputs(bin_to_gray(8'h05), bin_to_gray(8'h06));
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Increment from 0x0F", test_num);
            reset_dut(8'h0F);
            en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(bin_to_gray(8'h10), bin_to_gray(8'h11));
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Enable Disable Toggle", test_num);
            reset_dut(8'h20);
            en = 1;
            @(posedge clk);
            en = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(bin_to_gray(8'd33), bin_to_gray(8'd33));
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Rollover 0xFF to 0x00", test_num);
            reset_dut(8'hFF);
            en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(bin_to_gray(8'h00), bin_to_gray(8'h01));
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Test Case %0d: Multi-cycle increment from 0x7E", test_num);
            reset_dut(8'h7E);
            en = 1;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(bin_to_gray(8'h80), bin_to_gray(8'h81));
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
        input [7:0] expected_gry_cnt;
        input [7:0] expected_gry_cnt_nxt;
        begin
            if (expected_gry_cnt === (expected_gry_cnt ^ gry_cnt ^ expected_gry_cnt) &&
                expected_gry_cnt_nxt === (expected_gry_cnt_nxt ^ gry_cnt_nxt ^ expected_gry_cnt_nxt)) begin
                $display("PASS");
                $display("  Outputs: gry_cnt=%h, gry_cnt_nxt=%h",
                         gry_cnt, gry_cnt_nxt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gry_cnt=%h, gry_cnt_nxt=%h",
                         expected_gry_cnt, expected_gry_cnt_nxt);
                $display("  Got:      gry_cnt=%h, gry_cnt_nxt=%h",
                         gry_cnt, gry_cnt_nxt);
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
        $dumpvars(0,clk, en, rst_n, rst_val, gry_cnt, gry_cnt_nxt);
    end

endmodule
