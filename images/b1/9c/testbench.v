`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [23:0] i_0;
    reg [23:0] i_1;
    reg [23:0] i_2;
    reg [23:0] i_3;
    reg rst;
    wire [24:0] o_0;
    wire [24:0] o_1;
    wire [24:0] o_2;
    wire [24:0] o_3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i_0(i_0),
        .i_1(i_1),
        .i_2(i_2),
        .i_3(i_3),
        .rst(rst),
        .o_0(o_0),
        .o_1(o_1),
        .o_2(o_2),
        .o_3(o_3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            i_0 = 24'd0;
            i_1 = 24'd0;
            i_2 = 24'd0;
            i_3 = 24'd0;
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
            test_num = 1;
            $display("Testcase %0d: Basic positive values", test_num);
            i_0 = 24'sd1000;
            i_1 = 24'sd500;
            i_2 = 24'sd200;
            i_3 = 24'sd100;




            @(posedge clk);
            #1;
            #1;

            check_outputs(25'sd1100, 25'sd700, 25'sd300, 25'sd900);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Negative values", test_num);
            i_0 = -24'sd50;
            i_1 = -24'sd100;
            i_2 = -24'sd30;
            i_3 = -24'sd20;




            @(posedge clk);
            #1;
            #1;

            check_outputs(-25'sd70, -25'sd130, -25'sd70, -25'sd30);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Mixed signs", test_num);
            i_0 = 24'sd1000;
            i_1 = -24'sd500;
            i_2 = 24'sd200;
            i_3 = -24'sd100;




            @(posedge clk);
            #1;
            #1;

            check_outputs(25'sd900, -25'sd300, -25'sd700, 25'sd1100);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Boundary Max Positive", test_num);
            i_0 = 24'h7FFFFF;
            i_1 = 24'h7FFFFF;
            i_2 = 24'h000001;
            i_3 = 24'h7FFFFF;




            @(posedge clk);
            #1;
            #1;

            check_outputs(25'sd16777214, 25'sd8388608, 25'sd8388606, 25'sd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Boundary Min Negative", test_num);
            i_0 = 24'h800000;
            i_1 = 24'h800000;
            i_2 = 24'h000001;
            i_3 = 24'h800000;




            @(posedge clk);
            #1;
            #1;

            check_outputs(-25'sd16777216, -25'sd8388607, -25'sd8388609, 25'sd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Reset logic verify", test_num);
            i_0 = 24'sd555;
            i_1 = 24'sd444;
            i_2 = 24'sd333;
            i_3 = 24'sd222;
            @(posedge clk);
            #1;

            if (o_0 !== 25'sd777) $display("Pre-reset check failed");


            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(25'd0, 25'd0, 25'd0, 25'd0);
            rst = 0;
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
        input [24:0] expected_o_0;
        input [24:0] expected_o_1;
        input [24:0] expected_o_2;
        input [24:0] expected_o_3;
        begin
            if (expected_o_0 === (expected_o_0 ^ o_0 ^ expected_o_0) &&
                expected_o_1 === (expected_o_1 ^ o_1 ^ expected_o_1) &&
                expected_o_2 === (expected_o_2 ^ o_2 ^ expected_o_2) &&
                expected_o_3 === (expected_o_3 ^ o_3 ^ expected_o_3)) begin
                $display("PASS");
                $display("  Outputs: o_0=%h, o_1=%h, o_2=%h, o_3=%h",
                         o_0, o_1, o_2, o_3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_0=%h, o_1=%h, o_2=%h, o_3=%h",
                         expected_o_0, expected_o_1, expected_o_2, expected_o_3);
                $display("  Got:      o_0=%h, o_1=%h, o_2=%h, o_3=%h",
                         o_0, o_1, o_2, o_3);
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
        $dumpvars(0,clk, i_0, i_1, i_2, i_3, rst, o_0, o_1, o_2, o_3);
    end

endmodule
