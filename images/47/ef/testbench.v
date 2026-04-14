`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in_data;
    reg reset;
    reg start;
    wire [15:0] coefficients;
    wire [15:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_data(in_data),
        .reset(reset),
        .start(start),
        .coefficients(coefficients),
        .out_data(out_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            in_data = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %03d: Simple Even Values (1000, 500)", test_num);
            @(posedge clk);
            start = 1;
            in_data = 16'd1000;
            @(posedge clk);
            in_data = 16'd500;
            @(posedge clk);
            start = 0;
            in_data = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd250, 16'd750);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %03d: Negative Coefficient (200, 800)", test_num);
            @(posedge clk);
            start = 1;
            in_data = 16'd200;
            @(posedge clk);
            in_data = 16'd800;
            @(posedge clk);
            start = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'hFED4, 16'd500);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %03d: Identical Values (1024, 1024)", test_num);
            @(posedge clk);
            start = 1;
            in_data = 16'd1024;
            @(posedge clk);
            in_data = 16'd1024;
            @(posedge clk);
            start = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd0, 16'd1024);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %03d: Odd Sum Truncation (11, 4)", test_num);
            @(posedge clk);
            start = 1;
            in_data = 16'd11;
            @(posedge clk);
            in_data = 16'd4;
            @(posedge clk);
            start = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd3, 16'd7);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %03d: Zero Values", test_num);
            @(posedge clk);
            start = 1;
            in_data = 16'h0;
            @(posedge clk);
            in_data = 16'h0;
            @(posedge clk);
            start = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h0, 16'h0);
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
        input [15:0] expected_coefficients;
        input [15:0] expected_out_data;
        begin
            if (expected_coefficients === (expected_coefficients ^ coefficients ^ expected_coefficients) &&
                expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: coefficients=%h, out_data=%h",
                         coefficients, out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: coefficients=%h, out_data=%h",
                         expected_coefficients, expected_out_data);
                $display("  Got:      coefficients=%h, out_data=%h",
                         coefficients, out_data);
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
        $dumpvars(0,clk, in_data, reset, start, coefficients, out_data);
    end

endmodule
