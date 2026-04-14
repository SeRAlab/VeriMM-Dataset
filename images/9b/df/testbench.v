`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg ena;
    reg rst;
    reg touch_clk;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .ena(ena),
        .rst(rst),
        .touch_clk(touch_clk),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ena = 0;
            data_in = 8'b0;
            touch_clk = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task pulse_touch_clk;

        begin
            @(posedge clk);
            #1 touch_clk = 1;
            @(posedge clk);
            #1 touch_clk = 0;
            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Initial Reset and LSB Mask Check", test_num);
            reset_dut();
            data_in = 8'b0000_0001;
            ena = 1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Shift Left Check (Bit 1)", test_num);
            reset_dut();
            data_in = 8'b0000_0010;
            ena = 1;
            pulse_touch_clk();
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Enable Signal Check (No Shift when ena=0)", test_num);
            reset_dut();
            data_in = 8'b0000_0010;
            ena = 0;
            pulse_touch_clk();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Test Case %0d: Shift to MSB (Bit 7)", test_num);
            reset_dut();
            data_in = 8'b1000_0000;
            ena = 1;
            for (i = 0; i < 7; i = i + 1) begin
                pulse_touch_clk();
            end
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Data Input Sensitivity Check", test_num);
            reset_dut();
            ena = 1;
            data_in = 8'b0000_0001;
            @(posedge clk);
            data_in = 8'b0000_0000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Mid-operation Reset", test_num);
            reset_dut();
            data_in = 8'b0000_0010;
            ena = 1;
            pulse_touch_clk();
            rst = 1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
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
        input expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b",
                         expected_data_out);
                $display("  Got:      data_out=%b",
                         data_out);
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
        $dumpvars(0,clk, data_in, ena, rst, touch_clk, data_out);
    end

endmodule
