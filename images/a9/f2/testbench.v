`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clock;
    reg [1:0] op;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clock(clock),
        .op(op),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            op = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Addition (15 + 25)");
            reset_dut();
            a = 8'd15;
            b = 8'd25;
            op = 2'b00;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'd40);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Max Addition (255 + 255)");
            reset_dut();
            a = 8'd255;
            b = 8'd255;
            op = 2'b00;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'd510);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Basic Subtraction (100 - 40)");
            reset_dut();
            a = 8'd100;
            b = 8'd40;
            op = 2'b01;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'd60);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Subtraction Zero (50 - 50)");
            reset_dut();
            a = 8'd50;
            b = 8'd50;
            op = 2'b01;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Basic Multiplication (12 * 10)");
            reset_dut();
            a = 8'd12;
            b = 8'd10;
            op = 2'b10;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'd120);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Max Multiplication (255 * 255)");
            reset_dut();
            a = 8'd255;
            b = 8'd255;
            op = 2'b10;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'd65025);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Basic Division (100 / 5)");
            reset_dut();
            a = 8'd100;
            b = 8'd5;
            op = 2'b11;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'd20);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Division Truncation (7 / 2)");
            reset_dut();
            a = 8'd7;
            b = 8'd2;
            op = 2'b11;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'd3);
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
        input [15:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,a, b, clock, op, result);
    end

endmodule
