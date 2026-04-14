`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] op;
    reg [31:0] opA;
    reg [31:0] opB;
    wire [31:0] result;
    wire result_slt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .op(op),
        .opA(opA),
        .opB(opB),
        .result(result),
        .result_slt(result_slt)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Addition (10 + 20)", test_num);
        op = 3'b000; opA = 32'd10; opB = 32'd20;

        #1;


        check_outputs(32'd30, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Subtraction (50 - 20)", test_num);
        op = 3'b001; opA = 32'd50; opB = 32'd20;

        #1;


        check_outputs(32'd30, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (20 - 50)", test_num);
        op = 3'b001; opA = 32'd20; opB = 32'd50;

        #1;


        check_outputs(32'hFFFFFFE2, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Signed Addition (-1 + 1)", test_num);
        op = 3'b000; opA = 32'hFFFFFFFF; opB = 32'h00000001;

        #1;


        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SLT Signed Comparison (-10 < -5)", test_num);
        op = 3'b000; opA = 32'hFFFFFFF6; opB = 32'hFFFFFFFB;


        #1;



        check_outputs(32'hFFFFFFF1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Signed Overflow (MaxPos + 1)", test_num);
        op = 3'b000; opA = 32'h7FFFFFFF; opB = 32'h00000001;

        #1;


        check_outputs(32'h80000000, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Signed Overflow Subtraction (MaxNeg - 1)", test_num);
        op = 3'b001; opA = 32'h80000000; opB = 32'h00000001;

        #1;


        check_outputs(32'h7FFFFFFF, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SLT Equality (100 < 100)", test_num);
        op = 3'b000; opA = 32'd100; opB = 32'd100;

        #1;


        check_outputs(32'd200, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SLT Comparison (Large Pos vs Large Neg)", test_num);
        op = 3'b000; opA = 32'h70000000; opB = 32'h80000000;


        #1;



        check_outputs(32'hF0000000, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction Resulting in Zero", test_num);
        op = 3'b001; opA = 32'hABCDE123; opB = 32'hABCDE123;

        #1;


        check_outputs(32'h00000000, 1'b0);
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
        input [31:0] expected_result;
        input expected_result_slt;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_result_slt === (expected_result_slt ^ result_slt ^ expected_result_slt)) begin
                $display("PASS");
                $display("  Outputs: result=%h, result_slt=%b",
                         result, result_slt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, result_slt=%b",
                         expected_result, expected_result_slt);
                $display("  Got:      result=%h, result_slt=%b",
                         result, result_slt);
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
