`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] count_in;
    reg ctrl;
    reg rst;
    wire [3:0] count_out;
    wire zero_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .count_in(count_in),
        .ctrl(ctrl),
        .rst(rst),
        .count_out(count_out),
        .zero_flag(zero_flag)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ctrl = 0;
            count_in = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Initial Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Up Counting - Intermediate Value", test_num);
            reset_dut();
            count_in = 4'd10;
            ctrl = 1'b1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Up Counting - Reach Mod Value", test_num);
            reset_dut();
            count_in = 4'd10;
            ctrl = 1'b1;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd10, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Up Counting - Rollover to Zero", test_num);
            reset_dut();
            count_in = 4'd10;
            ctrl = 1'b1;
            repeat(11) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Down Counting - From Zero to Mod Value", test_num);
            reset_dut();
            count_in = 4'd12;
            ctrl = 1'b0;
            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd12, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Down Counting - Intermediate Value", test_num);
            reset_dut();
            count_in = 4'd12;
            ctrl = 1'b0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd8, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Down Counting - Rollover to Zero", test_num);
            reset_dut();
            count_in = 4'd12;
            ctrl = 1'b0;
            repeat(13) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Maximum Bit Count (Mod 15)", test_num);
            reset_dut();
            count_in = 4'd15;
            ctrl = 1'b1;
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 1'b1);
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
        input [3:0] expected_count_out;
        input expected_zero_flag;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out) &&
                expected_zero_flag === (expected_zero_flag ^ zero_flag ^ expected_zero_flag)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h, zero_flag=%b",
                         count_out, zero_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h, zero_flag=%b",
                         expected_count_out, expected_zero_flag);
                $display("  Got:      count_out=%h, zero_flag=%b",
                         count_out, zero_flag);
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
        $dumpvars(0,clk, count_in, ctrl, rst, count_out, zero_flag);
    end

endmodule
