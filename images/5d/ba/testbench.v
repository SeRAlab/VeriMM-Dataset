`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg ce;
    reg clk;
    reg [1:0] op;
    reg reset;
    wire [7:0] result;

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
            a = 0;
            b = 0;
            ce = 0;
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
            test_num = 1;
            $display("Testcase %0d: Simple Addition (15 + 5)", test_num);
            reset_dut();
            a = 8'd15;
            b = 8'd5;
            op = 2'b00;
            ce = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd20);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Simple Subtraction (50 - 20)", test_num);
            reset_dut();
            a = 8'd50;
            b = 8'd20;
            op = 2'b01;
            ce = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Addition with Overflow (255 + 2)", test_num);
            reset_dut();
            a = 8'hFF;
            b = 8'h02;
            op = 2'b00;
            ce = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Subtraction with Underflow (10 - 20)", test_num);
            reset_dut();
            a = 8'd10;
            b = 8'd20;
            op = 2'b01;
            ce = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd246);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Chip Enable logic (ce=0)", test_num);
            reset_dut();
            a = 8'd10;
            b = 8'd10;
            op = 2'b00;
            ce = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Result is Zero (100 - 100)", test_num);
            reset_dut();
            a = 8'd100;
            b = 8'd100;
            op = 2'b01;
            ce = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Max values (255 + 255)", test_num);
            reset_dut();
            a = 8'hFF;
            b = 8'hFF;
            op = 2'b00;
            ce = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Hold value (ce transitions 1->0)", test_num);
            reset_dut();

            a = 8'd40;
            b = 8'd2;
            op = 2'b00;
            ce = 1;
            @(posedge clk);
            #2;

            a = 8'd10;
            b = 8'd10;
            ce = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd42);
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
        $dumpvars(0,a, b, ce, clk, op, reset, result);
    end

endmodule
