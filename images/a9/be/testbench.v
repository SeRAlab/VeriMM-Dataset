`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cnt_dir;
    reg [15:0] cnt_max;
    reg en;
    reg rst;
    wire [15:0] cnt_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .cnt_dir(cnt_dir),
        .cnt_max(cnt_max),
        .en(en),
        .rst(rst),
        .cnt_out(cnt_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            cnt_dir = 0;
            cnt_max = 16'h0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Upward Counting", test_num);
            reset_dut();
            cnt_max = 16'd20;
            cnt_dir = 0;
            en = 1;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Upward Wrap-around", test_num);
            reset_dut();
            cnt_max = 16'd5;
            cnt_dir = 0;
            en = 1;

            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Downward Wrap from Zero", test_num);
            reset_dut();
            cnt_max = 16'd15;
            cnt_dir = 1;
            en = 1;

            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Downward Counting Sequence", test_num);
            reset_dut();
            cnt_max = 16'd10;
            cnt_dir = 1;
            en = 1;

            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Enable Signal Check", test_num);
            reset_dut();
            cnt_max = 16'd10;
            cnt_dir = 0;
            en = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Direction Switching Mid-stream", test_num);
            reset_dut();
            cnt_max = 16'd10;
            cnt_dir = 0;
            en = 1;
            repeat(5) @(posedge clk);
            @(negedge clk);
            cnt_dir = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Maximum Value Boundary (Up)", test_num);
            reset_dut();
            cnt_max = 16'd2;
            cnt_dir = 0;
            en = 1;

            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0);
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
        input [15:0] expected_cnt_out;
        begin
            if (expected_cnt_out === (expected_cnt_out ^ cnt_out ^ expected_cnt_out)) begin
                $display("PASS");
                $display("  Outputs: cnt_out=%h",
                         cnt_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cnt_out=%h",
                         expected_cnt_out);
                $display("  Got:      cnt_out=%h",
                         cnt_out);
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
        $dumpvars(0,clk, cnt_dir, cnt_max, en, rst, cnt_out);
    end

endmodule
