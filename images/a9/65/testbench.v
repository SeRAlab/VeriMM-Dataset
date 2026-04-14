`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in1;
    reg [7:0] in2;
    reg op;
    reg reset;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in1(in1),
        .in2(in2),
        .op(op),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in1 = 0;
            in2 = 0;
            op = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Addition (10 + 20)");
            test_num = test_num + 1;
            reset_dut();
            in1 = 8'd10;
            in2 = 8'd20;
            op = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Subtraction (50 - 15)");
            test_num = test_num + 1;
            reset_dut();
            in1 = 8'd50;
            in2 = 8'd15;
            op = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd35);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Multiplication (12 * 5)");
            test_num = test_num + 1;
            reset_dut();
            in1 = 8'd12;
            in2 = 8'd5;
            op = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Division (100 / 4)");
            test_num = test_num + 1;
            reset_dut();
            in1 = 8'd100;
            in2 = 8'd4;
            op = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Division by Zero Safety Check");
            test_num = test_num + 1;
            reset_dut();
            in1 = 8'd50;
            in2 = 8'd0;
            op = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Subtraction Underflow (5 - 10)");
            test_num = test_num + 1;
            reset_dut();
            in1 = 8'd5;
            in2 = 8'd10;
            op = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd251);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Multiplication 8-bit Truncation (100 * 3)");
            test_num = test_num + 1;
            reset_dut();
            in1 = 8'd100;
            in2 = 8'd3;
            op = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd44);
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
        $dumpvars(0,clk, in1, in2, op, reset, out);
    end

endmodule
