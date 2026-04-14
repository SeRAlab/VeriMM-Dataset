`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] num1;
    reg [7:0] num2;
    reg op;
    reg reset;
    wire overflow;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .num1(num1),
        .num2(num2),
        .op(op),
        .reset(reset),
        .overflow(overflow),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            num1 = 0;
            num2 = 0;
            op = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Addition (10 + 20)");
            reset_dut();
            num1 = 8'd10;
            num2 = 8'd20;
            op = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'd30);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Addition with Overflow (200 + 100)");
            reset_dut();
            num1 = 8'd200;
            num2 = 8'd100;
            op = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'd44);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Addition Boundary (255 + 0)");
            reset_dut();
            num1 = 8'd255;
            num2 = 8'd0;
            op = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'd255);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Addition Boundary (255 + 1)");
            reset_dut();
            num1 = 8'd255;
            num2 = 8'd1;
            op = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Basic Subtraction (50 - 20)");
            reset_dut();
            num1 = 8'd50;
            num2 = 8'd20;
            op = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'd30);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Subtraction with Overflow (10 - 20)");
            reset_dut();
            num1 = 8'd10;
            num2 = 8'd20;
            op = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'd246);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Subtraction Zero (100 - 100)");
            reset_dut();
            num1 = 8'd100;
            num2 = 8'd100;
            op = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'd0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Subtraction Boundary (0 - 1)");
            reset_dut();
            num1 = 8'd0;
            num2 = 8'd1;
            op = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'd255);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Verify Reset clearing outputs");

            reset_dut();
            num1 = 8'hFF;
            num2 = 8'hFF;
            op = 0;
            @(posedge clk);
            #1;

            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            #1;

            check_outputs(1'b0, 8'd0);
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
        input expected_overflow;
        input [7:0] expected_result;
        begin
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, result=%h",
                         overflow, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, result=%h",
                         expected_overflow, expected_result);
                $display("  Got:      overflow=%b, result=%h",
                         overflow, result);
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
        $dumpvars(0,clk, num1, num2, op, reset, overflow, result);
    end

endmodule
