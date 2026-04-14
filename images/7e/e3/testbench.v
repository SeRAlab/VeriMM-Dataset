`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] column;
    reg [3:0] row;
    reg rst;
    wire [3:0] key;
    wire key_pressed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .column(column),
        .row(row),
        .rst(rst),
        .key(key),
        .key_pressed(key_pressed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            row = 4'b0000;
            column = 4'b0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            row = 4'b0000;
            column = 4'b0000;
            repeat(2) @(posedge clk);
            #1;
            test_num = 1;

            #1;


            check_outputs(4'b0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            row = 4'b0001;
            column = 4'b0001;
            repeat(2) @(posedge clk);
            #1;
            test_num = 2;

            #1;


            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            row = 4'b0010;
            column = 4'b0100;
            repeat(2) @(posedge clk);
            #1;
            test_num = 3;

            #1;


            check_outputs(4'd1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            row = 4'b0100;
            column = 4'b0010;
            repeat(2) @(posedge clk);
            #1;
            test_num = 4;

            #1;


            check_outputs(4'd2, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            row = 4'b1000;
            column = 4'b1000;
            repeat(2) @(posedge clk);
            #1;
            test_num = 5;

            #1;


            check_outputs(4'd3, 1'b1);
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
        input [3:0] expected_key;
        input expected_key_pressed;
        begin
            if (expected_key === (expected_key ^ key ^ expected_key) &&
                expected_key_pressed === (expected_key_pressed ^ key_pressed ^ expected_key_pressed)) begin
                $display("PASS");
                $display("  Outputs: key=%h, key_pressed=%b",
                         key, key_pressed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: key=%h, key_pressed=%b",
                         expected_key, expected_key_pressed);
                $display("  Got:      key=%h, key_pressed=%b",
                         key, key_pressed);
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
        $dumpvars(0,clk, column, row, rst, key, key_pressed);
    end

endmodule
