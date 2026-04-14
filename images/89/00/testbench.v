`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg clk;
    reg [7:0] d;
    wire [7:0] f;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .d(d),
        .f(f)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        a = 0;
        b = 0;
        c = 0;
        d = 0;

        repeat(5) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        a = 8'd10; b = 8'd5; c = 8'd20; d = 8'd4;
        repeat(3) @(posedge clk);
        #1;
        $display("Test Case 001: Basic Arithmetic");
        #1;

        check_outputs(8'd124);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        a = 8'd0; b = 8'd0; c = 8'd0; d = 8'd0;
        repeat(3) @(posedge clk);
        #1;
        $display("Test Case 002: Zero Inputs");
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        a = 8'd150; b = 8'd150; c = 8'd20; d = 8'd10;
        repeat(3) @(posedge clk);
        #1;
        $display("Test Case 003: Addition Overflow");
        #1;

        check_outputs(8'd28);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        a = 8'd5; b = 8'd5; c = 8'd5; d = 8'd10;
        repeat(3) @(posedge clk);
        #1;
        $display("Test Case 004: Negative Subtraction Wrap");
        #1;

        check_outputs(8'd50);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        a = 8'd100; b = 8'd100; c = 8'd50; d = 8'd40;
        repeat(3) @(posedge clk);
        #1;
        $display("Test Case 005: Large Value Wrap Around");
        #1;

        check_outputs(8'd208);
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
        input [7:0] expected_f;
        begin
            if (expected_f === (expected_f ^ f ^ expected_f)) begin
                $display("PASS");
                $display("  Outputs: f=%h",
                         f);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f=%h",
                         expected_f);
                $display("  Got:      f=%h",
                         f);
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
        $dumpvars(0,a, b, c, clk, d, f);
    end

endmodule
