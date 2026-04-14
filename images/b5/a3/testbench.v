`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg ce;
    reg clk;
    reg op;
    reg reset;
    wire [15:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ce(ce),
        .clk(clk),
        .op(op),
        .reset(reset),
        .s(s)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ce = 0;
            a = 0;
            b = 0;
            op = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Addition (1500 + 2500)");
            reset_dut();
            a = 16'd1500;
            b = 16'd2500;
            op = 0;
            ce = 1;

            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd4000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Subtraction (5000 - 2000)");
            reset_dut();
            a = 16'd5000;
            b = 16'd2000;
            op = 1;
            ce = 1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd3000);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Negative Result Addition (10 + -20)");
            reset_dut();
            a = 16'd10;
            b = -16'd20;
            op = 0;
            ce = 1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(-16'd10);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Subtraction with Negatives (-100 - -50)");
            reset_dut();
            a = -16'd100;
            b = -16'd50;
            op = 1;
            ce = 1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(-16'd50);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Edge Case Addition (32760 + 7)");
            reset_dut();
            a = 16'h7FF8;
            b = 16'h0007;
            op = 0;
            ce = 1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h7FFF);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Clock Enable Verification");
            reset_dut();

            a = 16'd100;
            b = 16'd200;
            op = 0;
            ce = 1;
            repeat(4) @(posedge clk);
            #1;

            ce = 0;
            a = 16'd500;
            b = 16'd500;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(16'd300);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Reset assertion during operation");
            reset_dut();
            a = 16'd1000;
            b = 16'd1000;
            op = 0;
            ce = 1;
            repeat(4) @(posedge clk);
            #1;

            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000);
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
        input [15:0] expected_s;
        begin
            if (expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: s=%h",
                         s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s=%h",
                         expected_s);
                $display("  Got:      s=%h",
                         s);
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
        $dumpvars(0,a, b, ce, clk, op, reset, s);
    end

endmodule
