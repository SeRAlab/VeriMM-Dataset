`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg add;
    reg clear;
    reg clk;
    reg div;
    reg mult;
    reg [7:0] num1;
    reg [7:0] num2;
    reg reset;
    reg sub;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .add(add),
        .clear(clear),
        .clk(clk),
        .div(div),
        .mult(mult),
        .num1(num1),
        .num2(num2),
        .reset(reset),
        .sub(sub),
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
            add = 0;
            sub = 0;
            mult = 0;
            div = 0;
            clear = 0;
            num1 = 0;
            num2 = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            num1 = 8'd25;
            num2 = 8'd15;
            add = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd40);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            num1 = 8'd50;
            num2 = 8'd20;
            sub = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            num1 = 8'd12;
            num2 = 8'd5;
            mult = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            num1 = 8'd100;
            num2 = 8'd4;
            div = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            num1 = 8'd10;
            num2 = 8'd10;
            add = 1;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            num1 = 8'd10;
            num2 = 8'd10;
            add = 1;
            @(posedge clk);
            #1;
            clear = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            add = 1;
            num1 = 8'd10;
            num2 = 8'd5;
            @(posedge clk);
            #1;
            num1 = 8'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            num1 = 8'd200;
            num2 = 8'd100;
            add = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd44);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            num1 = 8'd10;
            num2 = 8'd30;
            sub = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hEC);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            num1 = 8'd10;
            num2 = 8'd2;
            mult = 1;
            @(posedge clk);
            #1;
            mult = 0;
            div = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd5);
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
        $dumpvars(0,add, clear, clk, div, mult, num1, num2, reset, sub, result);
    end

endmodule
