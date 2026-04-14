`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [1:0] op;
    reg rst;
    wire overflow;
    wire [7:0] result;
    wire zero;

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
        .rst(rst),
        .overflow(overflow),
        .result(result),
        .zero(zero)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in1 = 0;
            in2 = 0;
            op = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Functionality");
            reset_dut();

            #1;


            check_outputs(1'b0, 8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Addition 15 + 30");
            reset_dut();
            in1 = 8'd15;
            in2 = 8'd30;
            op = ADD;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd45, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Addition 200 + 100 (Overflow)");
            reset_dut();
            in1 = 8'd200;
            in2 = 8'd100;
            op = ADD;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'd44, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Subtraction 100 - 40");
            reset_dut();
            in1 = 8'd100;
            in2 = 8'd40;
            op = SUB;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd60, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Subtraction 50 - 50");
            reset_dut();
            in1 = 8'd50;
            in2 = 8'd50;
            op = SUB;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Subtraction 10 - 20 (Underflow)");
            reset_dut();
            in1 = 8'd10;
            in2 = 8'd20;
            op = SUB;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'd246, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Multiplication 12 * 10");
            reset_dut();
            in1 = 8'd12;
            in2 = 8'd10;
            op = MUL;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd120, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Multiplication 40 * 10 (Overflow)");
            reset_dut();
            in1 = 8'd40;
            in2 = 8'd10;
            op = MUL;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'd144, 1'b0);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Division 100 / 4");
            reset_dut();
            in1 = 8'd100;
            in2 = 8'd4;
            op = DIV;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd25, 1'b0);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Division by Zero (Robustness)");
            reset_dut();
            in1 = 8'd50;
            in2 = 8'd0;
            op = DIV;
            @(posedge clk);

            #1 #1;
 check_outputs(1'b1, 8'd0, 1'b1);
        end
        endtask

    task testcase011;

        begin
            $display("Testcase 011: Division 5 / 10 (Integer result 0)");
            reset_dut();
            in1 = 8'd5;
            in2 = 8'd10;
            op = DIV;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd0, 1'b1);
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
        testcase010();
        testcase011();
        
        
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
        input expected_zero;
        begin
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, result=%h, zero=%b",
                         overflow, result, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, result=%h, zero=%b",
                         expected_overflow, expected_result, expected_zero);
                $display("  Got:      overflow=%b, result=%h, zero=%b",
                         overflow, result, zero);
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
        $dumpvars(0,clk, in1, in2, op, rst, overflow, result, zero);
    end

endmodule
