`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] fcw;
    reg [31:0] ref_freq;
    reg rst;
    wire locked;
    wire [31:0] out_freq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .fcw(fcw),
        .ref_freq(ref_freq),
        .rst(rst),
        .locked(locked),
        .out_freq(out_freq)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        fcw = 0;
        ref_freq = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Reset behavior with zero inputs", test_num);
        reset_dut();

        repeat(5) @(posedge clk);
        #1;

        check_outputs(1'b1, 32'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Basic frequency generation (fcw=10, ref=100)", test_num);
        reset_dut();
        fcw = 16'd10;
        ref_freq = 32'd100;

        repeat(20) @(posedge clk);
        #1;

        check_outputs(1'b1, 32'd1000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Frequency generation (fcw=5, ref=200)", test_num);
        reset_dut();
        fcw = 16'd5;
        ref_freq = 32'd200;
        repeat(20) @(posedge clk);
        #1;

        check_outputs(1'b1, 32'd1000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Large FCW", test_num);
        reset_dut();
        fcw = 16'h00FF;
        ref_freq = 32'd1000;
        repeat(20) @(posedge clk);
        #1;

        check_outputs(1'b1, 32'd255000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: High reference frequency", test_num);
        reset_dut();
        fcw = 16'd2;
        ref_freq = 32'h0000_FFFF;
        repeat(20) @(posedge clk);
        #1;

        check_outputs(1'b1, 32'd131070);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Dynamic parameter change", test_num);
        reset_dut();
        fcw = 16'd10;
        ref_freq = 32'd50;
        repeat(20) @(posedge clk);


        fcw = 16'd20;
        repeat(20) @(posedge clk);
        #1;

        check_outputs(1'b1, 32'd1000);
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
        input expected_locked;
        input [31:0] expected_out_freq;
        begin
            if (expected_locked === (expected_locked ^ locked ^ expected_locked) &&
                expected_out_freq === (expected_out_freq ^ out_freq ^ expected_out_freq)) begin
                $display("PASS");
                $display("  Outputs: locked=%b, out_freq=%h",
                         locked, out_freq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: locked=%b, out_freq=%h",
                         expected_locked, expected_out_freq);
                $display("  Got:      locked=%b, out_freq=%h",
                         locked, out_freq);
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
        $dumpvars(0,clk, fcw, ref_freq, rst, locked, out_freq);
    end

endmodule
