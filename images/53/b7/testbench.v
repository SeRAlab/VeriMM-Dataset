`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control_signal;
    reg [7:0] data_in_1;
    reg [7:0] data_in_2;
    reg reset;
    wire ready_out;
    wire [15:0] result_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .control_signal(control_signal),
        .data_in_1(data_in_1),
        .data_in_2(data_in_2),
        .reset(reset),
        .ready_out(ready_out),
        .result_out(result_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in_1 = 0;
            data_in_2 = 0;
            control_signal = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simple Addition (15 + 25)", test_num);
            reset_dut();
            data_in_1 = 8'd15;
            data_in_2 = 8'd25;
            control_signal = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 16'h0028);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition with Overflow (200 + 100)", test_num);
            reset_dut();
            data_in_1 = 8'd200;
            data_in_2 = 8'd100;
            control_signal = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 16'h002C);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simple Multiplication (12 * 12)", test_num);
            reset_dut();
            data_in_1 = 8'd12;
            data_in_2 = 8'd12;
            control_signal = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 16'h0090);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max Multiplication (255 * 255)", test_num);
            reset_dut();
            data_in_1 = 8'hFF;
            data_in_2 = 8'hFF;
            control_signal = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 16'hFE01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiplication by Zero", test_num);
            reset_dut();
            data_in_1 = 8'd255;
            data_in_2 = 8'd0;
            control_signal = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Functionality Check", test_num);

            data_in_1 = 8'hFF;
            data_in_2 = 8'hFF;
            control_signal = 1'b1;
            @(posedge clk);
            #2;

            reset = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 16'h0000);
            reset = 0;
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
        input expected_ready_out;
        input [15:0] expected_result_out;
        begin
            if (expected_ready_out === (expected_ready_out ^ ready_out ^ expected_ready_out) &&
                expected_result_out === (expected_result_out ^ result_out ^ expected_result_out)) begin
                $display("PASS");
                $display("  Outputs: ready_out=%b, result_out=%h",
                         ready_out, result_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ready_out=%b, result_out=%h",
                         expected_ready_out, expected_result_out);
                $display("  Got:      ready_out=%b, result_out=%h",
                         ready_out, result_out);
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
        $dumpvars(0,clk, control_signal, data_in_1, data_in_2, reset, ready_out, result_out);
    end

endmodule
