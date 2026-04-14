`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [7:0] in1;
    reg [7:0] in2;
    reg reset;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in1(in1),
        .in2(in2),
        .reset(reset),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset and Zero Check (0 * 0)", test_num);
        reset = 1; in1 = 8'sd0; in2 = 8'sd0;
        @(posedge clk);
        #1; reset = 0;
        @(posedge clk);
        #1;

        check_outputs(16'sd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Positive * Positive (10 * 5)", test_num);
        reset = 1; #2; reset = 0;
        in1 = 8'sd10; in2 = 8'sd5;
        @(posedge clk);
        #1;

        check_outputs(16'sd50);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Negative * Positive (-10 * 5)", test_num);
        reset = 1; #2; reset = 0;
        in1 = -8'sd10; in2 = 8'sd5;
        @(posedge clk);
        #1;

        check_outputs(-16'sd50);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Positive * Negative (12 * -4)", test_num);
        reset = 1; #2; reset = 0;
        in1 = 8'sd12; in2 = -8'sd4;
        @(posedge clk);
        #1;

        check_outputs(-16'sd48);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Negative * Negative (-7 * -8)", test_num);
        reset = 1; #2; reset = 0;
        in1 = -8'sd7; in2 = -8'sd8;
        @(posedge clk);
        #1;

        check_outputs(16'sd56);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiply by Zero (0 * -128)", test_num);
        reset = 1; #2; reset = 0;
        in1 = 8'sd0; in2 = -8'sd128;
        @(posedge clk);
        #1;

        check_outputs(16'sd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max Positive * Max Positive (127 * 127)", test_num);
        reset = 1; #2; reset = 0;
        in1 = 8'sd127; in2 = 8'sd127;
        @(posedge clk);
        #1;

        check_outputs(16'sd16129);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max Negative * Max Negative (-128 * -128)", test_num);
        reset = 1; #2; reset = 0;
        in1 = -8'sd128; in2 = -8'sd128;
        @(posedge clk);
        #1;

        check_outputs(16'sd16384);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max Negative * Max Positive (-128 * 127)", test_num);
        reset = 1; #2; reset = 0;
        in1 = -8'sd128; in2 = 8'sd127;
        @(posedge clk);
        #1;

        check_outputs(-16'sd16256);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Identity Multiplication (-1 * 127)", test_num);
        reset = 1; #2; reset = 0;
        in1 = -8'sd1; in2 = 8'sd127;
        @(posedge clk);
        #1;

        check_outputs(-16'sd127);
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
            #1; // Small delay for combinational logic to settle
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

endmodule
