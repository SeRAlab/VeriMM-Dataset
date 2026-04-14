`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg enable;
    reg load;
    reg rst;
    reg shift;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .load(load),
        .rst(rst),
        .shift(shift),
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
        load = 0;
        shift = 0;
        enable = 0;
        data_in = 0;
        @(posedge clk);
        #1;
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Resetting DUT");
        reset_dut();
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Loading data 16'hA5A5");
        reset_dut();
        data_in = 16'hA5A5;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(16'hA5A5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Shift right 1 bit (0x8000 -> 0x4000)");
        reset_dut();
        data_in = 16'h8000;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        enable = 1;
        shift = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Shift right 4 times (0xFFFF -> 0x0FFF)");
        reset_dut();
        data_in = 16'hFFFF;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        enable = 1;
        shift = 1;
        repeat (4) @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0FFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Shift inhibited by enable=0");
        reset_dut();
        data_in = 16'h1234;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        enable = 0;
        shift = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Shift inhibited by shift=0");
        reset_dut();
        data_in = 16'h1234;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        enable = 1;
        shift = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Load priority check");
        reset_dut();
        data_in = 16'hAAAA;
        load = 1;
        @(posedge clk);
        #1;

        data_in = 16'hBBBB;
        load = 1;
        enable = 1;
        shift = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hBBBB);
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, enable, load, rst, shift, data_out);
    end

endmodule
