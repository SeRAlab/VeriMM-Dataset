`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] operandIn;
    reg [3:0] operation;
    reg [15:0] registerIn;
    wire [1:0] markOut;
    wire [15:0] resultOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .operandIn(operandIn),
        .operation(operation),
        .registerIn(registerIn),
        .markOut(markOut),
        .resultOut(resultOut)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Operation 0 - Pass registerIn (Positive)", test_num);
            operation = 4'd0;
            registerIn = 16'h1234;
            operandIn = 16'h5678;
            #1;

            check_outputs(2'b11, 16'h1234);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Operation 0 - Pass registerIn (Zero)", test_num);
            operation = 4'd0;
            registerIn = 16'h0000;
            operandIn = 16'h5678;
            #1;

            check_outputs(2'b00, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Operation 0 - Pass registerIn (Negative)", test_num);
            operation = 4'd0;
            registerIn = 16'hF000;
            operandIn = 16'h5678;
            #1;

            check_outputs(2'b10, 16'hF000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Operation 1 - Pass operandIn (Positive)", test_num);
            operation = 4'd1;
            registerIn = 16'h1111;
            operandIn = 16'h7FFF;
            #1;

            check_outputs(2'b11, 16'h7FFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Operation 2 - Addition (Positive Result)", test_num);
            operation = 4'd2;
            registerIn = 16'h0010;
            operandIn = 16'h0020;
            #1;

            check_outputs(2'b11, 16'h0030);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Operation 2 - Addition (Zero Result)", test_num);
            operation = 4'd2;
            registerIn = 16'h0001;
            operandIn = 16'hFFFF;
            #1;

            check_outputs(2'b00, 16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Operation 2 - Addition (Negative Result)", test_num);
            operation = 4'd2;
            registerIn = 16'hFFFE;
            operandIn = 16'hFFFF;
            #1;

            check_outputs(2'b10, 16'hFFFD);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Operation 3 - Subtraction (Positive Result)", test_num);
            operation = 4'd3;
            registerIn = 16'h0064;
            operandIn = 16'h0032;
            #1;

            check_outputs(2'b11, 16'h0032);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTestcase %0d: Operation 3 - Subtraction (Zero Result)", test_num);
            operation = 4'd3;
            registerIn = 16'hABCD;
            operandIn = 16'hABCD;
            #1;

            check_outputs(2'b00, 16'h0000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("\nTestcase %0d: Operation 3 - Subtraction (Negative Result)", test_num);
            operation = 4'd3;
            registerIn = 16'h0005;
            operandIn = 16'h000A;
            #1;

            check_outputs(2'b10, 16'hFFF6);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("\nTestcase %0d: Operation 3 - Subtraction (Neg - Pos)", test_num);
            operation = 4'd3;
            registerIn = 16'hFFFF;
            operandIn = 16'h0001;
            #1;

            check_outputs(2'b10, 16'hFFFE);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("\nTestcase %0d: Operation 1 - Boundary Negative", test_num);
            operation = 4'd1;
            operandIn = 16'h8000;
            #1;

            check_outputs(2'b10, 16'h8000);
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
        testcase011();
        testcase012();
        
        
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
        input [1:0] expected_markOut;
        input [15:0] expected_resultOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_markOut === (expected_markOut ^ markOut ^ expected_markOut) &&
                expected_resultOut === (expected_resultOut ^ resultOut ^ expected_resultOut)) begin
                $display("PASS");
                $display("  Outputs: markOut=%h, resultOut=%h",
                         markOut, resultOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: markOut=%h, resultOut=%h",
                         expected_markOut, expected_resultOut);
                $display("  Got:      markOut=%h, resultOut=%h",
                         markOut, resultOut);
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
