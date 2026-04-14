`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg ctrl;
    reg rst;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .ctrl(ctrl),
        .rst(rst),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            #2;
            rst = 0;
            #10;
            rst = 1;
            a = 0;
            b = 0;
            ctrl = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            a = 8'd10;
            b = 8'd20;
            ctrl = 1'b0;
            @(posedge clk);
            #1;
            $display("Test 001: Addition (10 + 20)");
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            a = 8'd50;
            b = 8'd20;
            ctrl = 1'b1;
            @(posedge clk);
            #1;
            $display("Test 002: Subtraction (50 - 20)");
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            a = 8'hFF;
            b = 8'h01;
            ctrl = 1'b0;
            @(posedge clk);
            #1;
            $display("Test 003: Addition with Overflow (255 + 1)");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            a = 8'd10;
            b = 8'd20;
            ctrl = 1'b1;
            @(posedge clk);
            #1;
            $display("Test 004: Subtraction with Underflow (10 - 20)");
            #1;

            check_outputs(8'd246);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            a = 8'd0;
            b = 8'd0;
            ctrl = 1'b0;
            @(posedge clk);
            #1;
            $display("Test 005: Zero check (0 + 0)");
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            a = 8'hFF;
            b = 8'hFF;
            ctrl = 1'b1;
            @(posedge clk);
            #1;
            $display("Test 006: Max value subtraction (255 - 255)");
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            a = 8'd100;
            b = 8'd50;
            ctrl = 1'b0;
            @(posedge clk);
            #1;

            rst = 0;
            #5;
            $display("Test 007: Async/Posedge reset verification");
            #1;

            check_outputs(8'd0);
            rst = 1;
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
        input [7:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,a, b, clk, ctrl, rst, out);
    end

endmodule
