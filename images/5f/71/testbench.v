`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
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
        .a(a),
        .b(b),
        .clk(clk),
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
            a = 0;
            b = 0;
            op = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Reset Check", test_num);
            reset = 1;
            a = 8'sd50;
            b = 8'sd20;
            op = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'sd0);
            reset = 0;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %03d: Simple Addition (10 + 20)", test_num);
            a = 8'sd10;
            b = 8'sd20;
            op = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'sd30);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %03d: Simple Addition (-15 + -5)", test_num);
            a = -8'sd15;
            b = -8'sd5;
            op = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, -8'sd20);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %03d: Addition Overflow (Positive)", test_num);
            a = 8'sd100;
            b = 8'sd50;
            op = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'sd100 + 8'sd50);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %03d: Addition Overflow (Negative)", test_num);
            a = -8'sd100;
            b = -8'sd40;
            op = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, -8'sd100 + -8'sd40);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %03d: Simple Subtraction (50 - 20)", test_num);
            a = 8'sd50;
            b = 8'sd20;
            op = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'sd30);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %03d: Simple Subtraction (-50 - -20)", test_num);
            a = -8'sd50;
            b = -8'sd20;
            op = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, -8'sd30);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %03d: Subtraction Overflow (Positive Result)", test_num);
            a = 8'sd100;
            b = -8'sd50;
            op = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'sd100 - (-8'sd50));
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %03d: Subtraction Overflow (Negative Result)", test_num);
            a = -8'sd100;
            b = 8'sd40;
            op = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, -8'sd100 - 8'sd40);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %03d: Boundary Check (127 + 1)", test_num);
            a = 8'sd127;
            b = 8'sd1;
            op = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, -8'sd128);
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
        $dumpvars(0,a, b, clk, op, reset, overflow, result);
    end

endmodule
