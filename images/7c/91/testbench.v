`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] arg_0;
    reg [15:0] arg_1;
    reg clk;
    reg is_sub;
    reg rst;
    wire [15:0] ret_0;
    wire [15:0] ret_1;
    wire ret_2;
    wire ret_3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .arg_0(arg_0),
        .arg_1(arg_1),
        .clk(clk),
        .is_sub(is_sub),
        .rst(rst),
        .ret_0(ret_0),
        .ret_1(ret_1),
        .ret_2(ret_2),
        .ret_3(ret_3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            arg_0 = 0;
            arg_1 = 0;
            is_sub = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            arg_0 = 16'h000A;
            arg_1 = 16'h0014;
            is_sub = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h001E, 16'h001E, 0, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            arg_0 = 16'h0032;
            arg_1 = 16'h000A;
            is_sub = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0028, 16'h0028, 0, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            arg_0 = 16'h0005;
            arg_1 = 16'h000F;
            is_sub = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFF6, 16'hFFF6, 0, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            arg_0 = 16'hFFFF;
            arg_1 = 16'h0005;
            is_sub = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0004, 16'h0004, 1, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            arg_0 = 16'h0005;
            arg_1 = 16'hFFFE;
            is_sub = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0003, 16'h0003, 0, 1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            arg_0 = 16'hFFFF;
            arg_1 = 16'hFFFE;
            is_sub = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0001, 16'h0001, 1, 1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            arg_0 = 16'hFFFF;
            arg_1 = 16'h0001;
            is_sub = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000, 1, 0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            arg_0 = 16'h1234;
            arg_1 = 16'h1234;
            is_sub = 0;
            @(posedge clk);
            #1;

            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
            #1;

            check_outputs(16'h0000, 16'h0000, 0, 0);
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
        input [15:0] expected_ret_0;
        input [15:0] expected_ret_1;
        input expected_ret_2;
        input expected_ret_3;
        begin
            if (expected_ret_0 === (expected_ret_0 ^ ret_0 ^ expected_ret_0) &&
                expected_ret_1 === (expected_ret_1 ^ ret_1 ^ expected_ret_1) &&
                expected_ret_2 === (expected_ret_2 ^ ret_2 ^ expected_ret_2) &&
                expected_ret_3 === (expected_ret_3 ^ ret_3 ^ expected_ret_3)) begin
                $display("PASS");
                $display("  Outputs: ret_0=%h, ret_1=%h, ret_2=%b, ret_3=%b",
                         ret_0, ret_1, ret_2, ret_3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ret_0=%h, ret_1=%h, ret_2=%b, ret_3=%b",
                         expected_ret_0, expected_ret_1, expected_ret_2, expected_ret_3);
                $display("  Got:      ret_0=%h, ret_1=%h, ret_2=%b, ret_3=%b",
                         ret_0, ret_1, ret_2, ret_3);
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
        $dumpvars(0,arg_0, arg_1, clk, is_sub, rst, ret_0, ret_1, ret_2, ret_3);
    end

endmodule
