`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg op;
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
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Basic Addition (10 + 20)", test_num);
        a = 8'sd10;
        b = 8'sd20;
        op = 1'b0;
        @(posedge clk);
        #1;

        check_outputs(8'sd30);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Basic Addition (-15 + -30)", test_num);
        a = -8'sd15;
        b = -8'sd30;
        op = 1'b0;
        @(posedge clk);
        #1;

        check_outputs(-8'sd45);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Mixed Sign Addition (50 + -20)", test_num);
        a = 8'sd50;
        b = -8'sd20;
        op = 1'b0;
        @(posedge clk);
        #1;

        check_outputs(8'sd30);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Addition Overflow (120 + 10)", test_num);
        a = 8'sd120;
        b = 8'sd10;
        op = 1'b0;
        @(posedge clk);
        #1;

        check_outputs(-8'sd126);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Addition Underflow (-120 + -10)", test_num);
        a = -8'sd120;
        b = -8'sd10;
        op = 1'b0;
        @(posedge clk);
        #1;

        check_outputs(8'sd126);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Basic Subtraction (50 - 20)", test_num);
        a = 8'sd50;
        b = 8'sd20;
        op = 1'b1;
        @(posedge clk);
        #1;

        check_outputs(8'sd30);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Subtraction Positive - Negative (10 - -10)", test_num);
        a = 8'sd10;
        b = -8'sd10;
        op = 1'b1;
        @(posedge clk);
        #1;

        check_outputs(8'sd20);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Subtraction Result Negative (5 - 15)", test_num);
        a = 8'sd5;
        b = 8'sd15;
        op = 1'b1;
        @(posedge clk);
        #1;

        check_outputs(-8'sd10);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Subtraction Overflow (100 - -40)", test_num);
        a = 8'sd100;
        b = -8'sd40;
        op = 1'b1;
        @(posedge clk);
        #1;

        check_outputs(-8'sd116);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Subtraction Underflow (-100 - 40)", test_num);
        a = -8'sd100;
        b = 8'sd40;
        op = 1'b1;
        @(posedge clk);
        #1;

        check_outputs(8'sd116);
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
            #1; // Small delay for combinational logic to settle
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

endmodule
