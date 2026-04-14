`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg partD;
    reg [3:0] unsorted_num0;
    reg [3:0] unsorted_num1;
    reg [3:0] unsorted_num2;
    reg [3:0] unsorted_num3;
    wire [3:0] sorted_num0;
    wire [3:0] sorted_num1;
    wire [3:0] sorted_num2;
    wire [3:0] sorted_num3;
    wire start_display;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .partD(partD),
        .unsorted_num0(unsorted_num0),
        .unsorted_num1(unsorted_num1),
        .unsorted_num2(unsorted_num2),
        .unsorted_num3(unsorted_num3),
        .sorted_num0(sorted_num0),
        .sorted_num1(sorted_num1),
        .sorted_num2(sorted_num2),
        .sorted_num3(sorted_num3),
        .start_display(start_display)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            partD = 0;
            unsorted_num0 = 0;
            unsorted_num1 = 0;
            unsorted_num2 = 0;
            unsorted_num3 = 0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("\nTestcase %0d: General unsorted input (8, 3, 11, 2)", test_num);
            unsorted_num0 = 4'd8;
            unsorted_num1 = 4'd3;
            unsorted_num2 = 4'd11;
            unsorted_num3 = 4'd2;
            partD = 1;


            wait(start_display === 1);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2, 4'd3, 4'd8, 4'd11, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("\nTestcase %0d: Reverse sorted input (15, 10, 5, 0)", test_num);
            unsorted_num0 = 4'd15;
            unsorted_num1 = 4'd10;
            unsorted_num2 = 4'd5;
            unsorted_num3 = 4'd0;
            partD = 1;

            wait(start_display === 1);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 4'd5, 4'd10, 4'd15, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("\nTestcase %0d: Input with duplicates (7, 2, 7, 2)", test_num);
            unsorted_num0 = 4'd7;
            unsorted_num1 = 4'd2;
            unsorted_num2 = 4'd7;
            unsorted_num3 = 4'd2;
            partD = 1;

            wait(start_display === 1);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2, 4'd2, 4'd7, 4'd7, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("\nTestcase %0d: Already sorted input (1, 4, 9, 13)", test_num);
            unsorted_num0 = 4'd1;
            unsorted_num1 = 4'd4;
            unsorted_num2 = 4'd9;
            unsorted_num3 = 4'd13;
            partD = 1;

            wait(start_display === 1);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1, 4'd4, 4'd9, 4'd13, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("\nTestcase %0d: All identical inputs (10, 10, 10, 10)", test_num);
            unsorted_num0 = 4'd10;
            unsorted_num1 = 4'd10;
            unsorted_num2 = 4'd10;
            unsorted_num3 = 4'd10;
            partD = 1;

            wait(start_display === 1);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd10, 4'd10, 4'd10, 4'd10, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("\nTestcase %0d: Max and Min values (15, 0, 15, 0)", test_num);
            unsorted_num0 = 4'd15;
            unsorted_num1 = 4'd0;
            unsorted_num2 = 4'd15;
            unsorted_num3 = 4'd0;
            partD = 1;

            wait(start_display === 1);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 4'd0, 4'd15, 4'd15, 1'b1);
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
        input [3:0] expected_sorted_num0;
        input [3:0] expected_sorted_num1;
        input [3:0] expected_sorted_num2;
        input [3:0] expected_sorted_num3;
        input expected_start_display;
        begin
            if (expected_sorted_num0 === (expected_sorted_num0 ^ sorted_num0 ^ expected_sorted_num0) &&
                expected_sorted_num1 === (expected_sorted_num1 ^ sorted_num1 ^ expected_sorted_num1) &&
                expected_sorted_num2 === (expected_sorted_num2 ^ sorted_num2 ^ expected_sorted_num2) &&
                expected_sorted_num3 === (expected_sorted_num3 ^ sorted_num3 ^ expected_sorted_num3) &&
                expected_start_display === (expected_start_display ^ start_display ^ expected_start_display)) begin
                $display("PASS");
                $display("  Outputs: sorted_num0=%h, sorted_num1=%h, sorted_num2=%h, sorted_num3=%h, start_display=%b",
                         sorted_num0, sorted_num1, sorted_num2, sorted_num3, start_display);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sorted_num0=%h, sorted_num1=%h, sorted_num2=%h, sorted_num3=%h, start_display=%b",
                         expected_sorted_num0, expected_sorted_num1, expected_sorted_num2, expected_sorted_num3, expected_start_display);
                $display("  Got:      sorted_num0=%h, sorted_num1=%h, sorted_num2=%h, sorted_num3=%h, start_display=%b",
                         sorted_num0, sorted_num1, sorted_num2, sorted_num3, start_display);
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
        $dumpvars(0,clk, partD, unsorted_num0, unsorted_num1, unsorted_num2, unsorted_num3, sorted_num0, sorted_num1, sorted_num2, sorted_num3, start_display);
    end

endmodule
