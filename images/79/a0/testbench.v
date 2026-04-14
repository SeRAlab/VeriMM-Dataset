`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg [1:0] op;
    reg reset;
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
        .reset(reset),
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
            reset = 1;
            a = 8'h00;
            b = 8'h00;
            op = 2'b00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Addition (15 + 10)", test_num);
            reset_dut();
            a = 8'd15;
            b = 8'd10;
            op = 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd25, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Addition Overflow (255 + 1)", test_num);
            reset_dut();
            a = 8'd255;
            b = 8'd1;
            op = 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Subtraction (50 - 20)", test_num);
            reset_dut();
            a = 8'd50;
            b = 8'd20;
            op = 2'b01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd30, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Subtraction (10 - 15)", test_num);
            reset_dut();
            a = 8'd10;
            b = 8'd15;
            op = 2'b01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFB, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Multiplication (12 * 4)", test_num);
            reset_dut();
            a = 8'd12;
            b = 8'd4;
            op = 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd48, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Multiplication Truncation (16 * 16)", test_num);
            reset_dut();
            a = 8'd16;
            b = 8'd16;
            op = 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Division (100 / 5)", test_num);
            reset_dut();
            a = 8'd100;
            b = 8'd5;
            op = 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd20, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Division (7 / 2)", test_num);
            reset_dut();
            a = 8'd7;
            b = 8'd2;
            op = 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd3, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Division by Zero (50 / 0)", test_num);
            reset_dut();
            a = 8'd50;
            b = 8'd0;
            op = 2'b11;
            @(posedge clk);
            #2;

            #1;


            check_outputs(result, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();
            a = 8'd10;
            b = 8'd10;
            op = 2'b00;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, valid);
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
        $dumpvars(0,a, b, clk, op, reset, result, valid);
    end

endmodule
