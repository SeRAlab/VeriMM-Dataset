`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg rst;
    reg [31:0] shift_amt;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .shift_amt(shift_amt),
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
            data_in = 0;
            shift_amt = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Reset check");
            reset_dut();
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Load data (shift_amt = 0)");
            reset_dut();
            data_in = 32'hA5A5A5A5;
            shift_amt = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Left shift by 1");
            reset_dut();
            data_in = 32'h00000001;
            shift_amt = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Left shift by 8");
            reset_dut();
            data_in = 32'h000000FF;
            shift_amt = 8;
            @(posedge clk); #1;
            #1;

            check_outputs(32'h0000FF00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Left shift by 31");
            reset_dut();
            data_in = 32'h00000001;
            shift_amt = 31;
            @(posedge clk); #1;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Right shift by 1");
            reset_dut();
            data_in = 32'h80000000;
            shift_amt = -1;
            @(posedge clk); #1;
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Right shift by 16");
            reset_dut();
            data_in = 32'hFFFF0000;
            shift_amt = -16;
            @(posedge clk); #1;
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Right shift by 31");
            reset_dut();
            data_in = 32'h80000000;
            shift_amt = -31;
            @(posedge clk); #1;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case 009: Large positive shift (32)");
            reset_dut();
            data_in = 32'hFFFFFFFF;
            shift_amt = 32;
            @(posedge clk); #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case 010: Alternating pattern shift left 4");
            reset_dut();
            data_in = 32'h55555555;
            shift_amt = 4;
            @(posedge clk); #1;
            #1;

            check_outputs(32'h55555550);
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
        testcase009();
        testcase010();
        
        
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
        input [31:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
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
        $dumpvars(0,clk, data_in, rst, shift_amt, data_out);
    end

endmodule
