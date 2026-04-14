`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    reg [1:0] op;
    reg reset;
    wire [3:0] result;

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
            a = 4'd0;
            b = 4'd0;
            op = 2'b00;
            @(posedge clk);
            #1 reset = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (5 + 3)", test_num);
            reset_dut();
            a = 4'd5;
            b = 4'd3;
            op = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Overflow (10 + 10 = 20 -> 4)", test_num);
            reset_dut();
            a = 4'd10;
            b = 4'd10;
            op = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (15 - 7)", test_num);
            reset_dut();
            a = 4'd15;
            b = 4'd7;
            op = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Underflow (3 - 5 = -2 -> 14)", test_num);
            reset_dut();
            a = 4'd3;
            b = 4'd5;
            op = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication (3 * 4)", test_num);
            reset_dut();
            a = 4'd3;
            b = 4'd4;
            op = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd12);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication Overflow (8 * 3 = 24 -> 8)", test_num);
            reset_dut();
            a = 4'd8;
            b = 4'd3;
            op = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division (12 / 3)", test_num);
            reset_dut();
            a = 4'd12;
            b = 4'd3;
            op = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division Truncation (13 / 4)", test_num);
            reset_dut();
            a = 4'd13;
            b = 4'd4;
            op = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential Operations (2+2 then 4*2)", test_num);
            reset_dut();

            a = 4'd2; b = 4'd2; op = 2'b00;
            @(posedge clk);
            #1;

            a = result; b = 4'd2; op = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd8);
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
        input [3:0] expected_result;
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
        $dumpvars(0,a, b, clk, op, reset, result);
    end

endmodule
