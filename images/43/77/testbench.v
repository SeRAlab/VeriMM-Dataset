`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg reset;
    reg sel;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .sel(sel),
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
            a = 0;
            b = 0;
            sel = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Synchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(16'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Positive Addition (10 + 25)", test_num);
            reset_dut();
            a = 8'sd10;
            b = 8'sd25;
            sel = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd35);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Signed Addition (50 + -20)", test_num);
            reset_dut();
            a = 8'sd50;
            b = -8'sd20;
            sel = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd30);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Signed Addition (-100 + -28)", test_num);
            reset_dut();
            a = -8'sd100;
            b = -8'sd28;
            sel = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-16'sd128);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Positive Multiplication (12 * 10)", test_num);
            reset_dut();
            a = 8'sd12;
            b = 8'sd10;
            sel = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd120);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Signed Multiplication (-5 * 20)", test_num);
            reset_dut();
            a = -8'sd5;
            b = 8'sd20;
            sel = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-16'sd100);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Signed Multiplication (-10 * -12)", test_num);
            reset_dut();
            a = -8'sd10;
            b = -8'sd12;
            sel = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd120);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Boundary Addition (127 + 127)", test_num);
            reset_dut();
            a = 8'sb01111111;
            b = 8'sb01111111;
            sel = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd254);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Boundary Multiplication (-128 * 2)", test_num);
            reset_dut();
            a = 8'sb10000000;
            b = 8'sd2;
            sel = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-16'sd256);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Zero Multiplication (127 * 0)", test_num);
            reset_dut();
            a = 8'sd127;
            b = 8'sd0;
            sel = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd0);
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
        input [15:0] expected_out;
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
        $dumpvars(0,a, b, clk, reset, sel, out);
    end

endmodule
