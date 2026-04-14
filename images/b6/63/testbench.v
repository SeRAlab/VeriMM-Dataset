`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg arg_0;
    reg arg_1;
    reg [20:0] arg_2;
    reg [20:0] arg_3;
    reg [4:0] arg_4;
    reg arg_5;
    reg arg_6;
    reg clk;
    reg rst;
    wire [21:0] ret_0;
    wire ret_1;
    wire ret_2;
    wire [4:0] ret_3;
    wire ret_4;
    wire ret_5;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .arg_0(arg_0),
        .arg_1(arg_1),
        .arg_2(arg_2),
        .arg_3(arg_3),
        .arg_4(arg_4),
        .arg_5(arg_5),
        .arg_6(arg_6),
        .clk(clk),
        .rst(rst),
        .ret_0(ret_0),
        .ret_1(ret_1),
        .ret_2(ret_2),
        .ret_3(ret_3),
        .ret_4(ret_4),
        .ret_5(ret_5)
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
            arg_2 = 0;
            arg_3 = 0;
            arg_4 = 0;
            arg_5 = 0;
            arg_6 = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            arg_0 = 0; arg_1 = 1;
            arg_2 = 21'd100; arg_3 = 21'd200;
            arg_4 = 5'h05; arg_5 = 0; arg_6 = 0;

            #1;


            check_outputs(22'd300, 0, 1, 5'h05, 0, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            arg_0 = 1; arg_1 = 0;
            arg_2 = 21'd500; arg_3 = 21'd500;
            arg_4 = 5'h1F; arg_5 = 0; arg_6 = 1;

            #1;


            check_outputs(22'd1001, 1, 0, 5'h1F, 0, 1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            arg_0 = 1; arg_1 = 1;
            arg_2 = 21'h1000; arg_3 = 21'h2000;
            arg_4 = 5'h00; arg_5 = 1; arg_6 = 0;

            #1;


            check_outputs(22'h3001, 1, 1, 5'h00, 1, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            arg_0 = 0; arg_1 = 0;
            arg_2 = 21'h7FFFF; arg_3 = 21'h1;
            arg_4 = 5'h12; arg_5 = 1; arg_6 = 1;

            #1;


            check_outputs(22'h80000, 0, 0, 5'h12, 1, 1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            arg_0 = 1; arg_1 = 0;
            arg_2 = 21'h1FFFFF; arg_3 = 21'h1FFFFF;
            arg_4 = 5'h0A; arg_5 = 0; arg_6 = 1;

            #1;


            check_outputs(22'h3FFFFF, 1, 0, 5'h0A, 0, 1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            arg_0 = 0; arg_1 = 0;
            arg_2 = 21'd0; arg_3 = 21'd0;
            arg_4 = 5'h00; arg_5 = 0; arg_6 = 0;

            #1;


            check_outputs(22'd0, 0, 0, 5'h00, 0, 0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            arg_0 = 0; arg_1 = 0;
            arg_2 = 21'd0; arg_3 = 21'd0;
            arg_4 = 5'h10; arg_5 = 1; arg_6 = 0;

            #1;


            check_outputs(22'd1, 0, 0, 5'h10, 1, 0);
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
        input [21:0] expected_ret_0;
        input expected_ret_1;
        input expected_ret_2;
        input [4:0] expected_ret_3;
        input expected_ret_4;
        input expected_ret_5;
        begin
            if (expected_ret_0 === (expected_ret_0 ^ ret_0 ^ expected_ret_0) &&
                expected_ret_1 === (expected_ret_1 ^ ret_1 ^ expected_ret_1) &&
                expected_ret_2 === (expected_ret_2 ^ ret_2 ^ expected_ret_2) &&
                expected_ret_3 === (expected_ret_3 ^ ret_3 ^ expected_ret_3) &&
                expected_ret_4 === (expected_ret_4 ^ ret_4 ^ expected_ret_4) &&
                expected_ret_5 === (expected_ret_5 ^ ret_5 ^ expected_ret_5)) begin
                $display("PASS");
                $display("  Outputs: ret_0=%h, ret_1=%b, ret_2=%b, ret_3=%h, ret_4=%b, ret_5=%b",
                         ret_0, ret_1, ret_2, ret_3, ret_4, ret_5);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ret_0=%h, ret_1=%b, ret_2=%b, ret_3=%h, ret_4=%b, ret_5=%b",
                         expected_ret_0, expected_ret_1, expected_ret_2, expected_ret_3, expected_ret_4, expected_ret_5);
                $display("  Got:      ret_0=%h, ret_1=%b, ret_2=%b, ret_3=%h, ret_4=%b, ret_5=%b",
                         ret_0, ret_1, ret_2, ret_3, ret_4, ret_5);
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
        $dumpvars(0,arg_0, arg_1, arg_2, arg_3, arg_4, arg_5, arg_6, clk, rst, ret_0, ret_1, ret_2, ret_3, ret_4, ret_5);
    end

endmodule
