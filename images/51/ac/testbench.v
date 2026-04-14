`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in_a;
    reg [15:0] in_b;
    reg in_mode;
    reg in_valid;
    reg rst_n;
    wire [35:0] out;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_a(in_a),
        .in_b(in_b),
        .in_mode(in_mode),
        .in_valid(in_valid),
        .rst_n(rst_n),
        .out(out),
        .out_valid(out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(posedge clk);
        rst_n = 0;
        in_a = 0;
        in_b = 0;
        in_mode = 0;
        in_valid = 0;
        @(posedge clk);
        #1;
        rst_n = 1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        @(posedge clk);
        in_a = 16'd500;
        in_b = 16'd250;
        in_mode = 0;
        in_valid = 1;
        @(posedge clk);
        #1;
        $display("Testcase 001: Basic Addition (500 + 250)");
        #1;

        check_outputs(36'd750, 1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        @(posedge clk);
        in_a = 16'd500;
        in_b = 16'd250;
        in_mode = 1;
        in_valid = 1;
        @(posedge clk);
        #1;
        $display("Testcase 002: Basic Subtraction (500 - 250)");
        #1;

        check_outputs(36'd250, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        @(posedge clk);
        in_a = 16'hFFFF;
        in_b = 16'hFFFF;
        in_mode = 0;
        in_valid = 1;
        @(posedge clk);
        #1;
        $display("Testcase 003: Maximum Addition (65535 + 65535)");
        #1;

        check_outputs(36'd131070, 1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        @(posedge clk);
        in_a = 16'd100;
        in_b = 16'd200;
        in_mode = 1;
        in_valid = 1;
        @(posedge clk);
        #1;
        $display("Testcase 004: Negative Subtraction (100 - 200)");

        #1;


        check_outputs(36'hFFFFFFFF9C, 1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        @(posedge clk);
        in_a = 16'd10;
        in_b = 16'd10;
        in_mode = 0;
        in_valid = 0;
        @(posedge clk);
        #1;
        $display("Testcase 005: Input invalid (out_valid should be 0)");


        #1;



        check_outputs(out, 1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        @(posedge clk);
        in_a = 16'd0;
        in_b = 16'd1;
        in_mode = 1;
        in_valid = 1;
        @(posedge clk);
        #1;
        $display("Testcase 006: Subtraction from zero (0 - 1)");
        #1;

        check_outputs(36'hFFFFFFFFF, 1'b1);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        @(posedge clk);
        in_a = 16'hAAAA;
        in_b = 16'h5555;
        in_mode = 0;
        in_valid = 1;
        @(posedge clk);
        rst_n = 0;
        @(posedge clk);
        #1;
        $display("Testcase 007: Reset during operation");

        #1;


        check_outputs(36'd0, 1'b0);
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
        input [35:0] expected_out;
        input expected_out_valid;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid)) begin
                $display("PASS");
                $display("  Outputs: out=%h, out_valid=%b",
                         out, out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, out_valid=%b",
                         expected_out, expected_out_valid);
                $display("  Got:      out=%h, out_valid=%b",
                         out, out_valid);
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
        $dumpvars(0,clk, in_a, in_b, in_mode, in_valid, rst_n, out, out_valid);
    end

endmodule
