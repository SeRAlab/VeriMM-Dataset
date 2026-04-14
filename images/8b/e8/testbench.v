`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] bin_in;
    reg clk;
    reg rst;
    wire [3:0] bcd_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin_in(bin_in),
        .clk(clk),
        .rst(rst),
        .bcd_out(bcd_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        bin_in = 0;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset Condition", test_num);
        reset_dut();

        #1;


        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Binary 0 -> BCD 0", test_num);
        reset_dut();
        bin_in = 4'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Binary 3 -> BCD 3", test_num);
        reset_dut();
        bin_in = 4'd3;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Binary 5 -> BCD 5", test_num);
        reset_dut();
        bin_in = 4'd5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Binary 8 -> BCD 8", test_num);
        reset_dut();
        bin_in = 4'd8;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h8);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Binary 9 -> BCD 9", test_num);
        reset_dut();
        bin_in = 4'd9;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h9);
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
        input [3:0] expected_bcd_out;
        begin
            if (expected_bcd_out === (expected_bcd_out ^ bcd_out ^ expected_bcd_out)) begin
                $display("PASS");
                $display("  Outputs: bcd_out=%h",
                         bcd_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd_out=%h",
                         expected_bcd_out);
                $display("  Got:      bcd_out=%h",
                         bcd_out);
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
        $dumpvars(0,bin_in, clk, rst, bcd_out);
    end

endmodule
