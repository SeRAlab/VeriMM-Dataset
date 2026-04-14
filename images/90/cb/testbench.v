`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg [1:0] op;
    wire [7:0] result;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .op(op),
        .result(result),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 8'd0;
            b = 8'd0;
            op = 2'b00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (15 + 25)", test_num);
            reset_dut();
            a = 8'd15;
            b = 8'd25;
            op = 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd40, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (100 - 35)", test_num);
            reset_dut();
            a = 8'd100;
            b = 8'd35;
            op = 2'b01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd65, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication (12 * 5)", test_num);
            reset_dut();
            a = 8'd12;
            b = 8'd5;
            op = 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd60, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division (80 / 4)", test_num);
            reset_dut();
            a = 8'd80;
            b = 8'd4;
            op = 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd20, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Overflow (200 + 100)", test_num);
            reset_dut();
            a = 8'd200;
            b = 8'd100;
            op = 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd44, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction Underflow (10 - 20)", test_num);
            reset_dut();
            a = 8'd10;
            b = 8'd20;
            op = 2'b01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd246, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication Overflow (50 * 10)", test_num);
            reset_dut();
            a = 8'd50;
            b = 8'd10;
            op = 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd244, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division Floor (20 / 3)", test_num);
            reset_dut();
            a = 8'd20;
            b = 8'd3;
            op = 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd6, 1'b1);
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
        input [7:0] expected_result;
        input expected_valid;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: result=%h, valid=%b",
                         result, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, valid=%b",
                         expected_result, expected_valid);
                $display("  Got:      result=%h, valid=%b",
                         result, valid);
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
        $dumpvars(0,a, b, clk, op, result, valid);
    end

endmodule
