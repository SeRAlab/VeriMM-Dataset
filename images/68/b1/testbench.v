`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] in1;
    reg [8:0] in2;
    wire [8:0] outAdd;
    wire [8:0] outSub;
    wire overflowA;
    wire overflowS;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .outAdd(outAdd),
        .outSub(outSub),
        .overflowA(overflowA),
        .overflowS(overflowS)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simple positive inputs", test_num);
            in1 = 9'd10;
            in2 = 9'd20;

            #1;


            check_outputs(9'd30, 9'h1f6, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition Overflow (Pos + Pos)", test_num);
            in1 = 9'd200;
            in2 = 9'd100;

            #1;


            check_outputs(9'd300, 9'd100, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition Overflow (Neg + Neg)", test_num);
            in1 = -9'd200;
            in2 = -9'd100;

            #1;


            check_outputs(9'd212, 9'h19c, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction Overflow (Pos - Neg)", test_num);
            in1 = 9'd200;
            in2 = -9'd100;

            #1;


            check_outputs(9'd100, 9'd300, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction Overflow (Neg - Pos)", test_num);
            in1 = -9'd200;
            in2 = 9'd100;

            #1;


            check_outputs(9'h19c, 9'd212, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero inputs", test_num);
            in1 = 9'd0;
            in2 = 9'd0;
            #1;

            check_outputs(9'd0, 9'd0, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Min/Max Boundary check", test_num);
            in1 = 9'h100;
            in2 = 9'h001;

            #1;


            check_outputs(9'h101, 9'h0FF, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mixed signs no overflow", test_num);
            in1 = -9'd50;
            in2 = 9'd40;

            #1;


            check_outputs(9'h1f6, 9'h1a6, 1'b0, 1'b0);
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
        input [8:0] expected_outAdd;
        input [8:0] expected_outSub;
        input expected_overflowA;
        input expected_overflowS;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outAdd === (expected_outAdd ^ outAdd ^ expected_outAdd) &&
                expected_outSub === (expected_outSub ^ outSub ^ expected_outSub) &&
                expected_overflowA === (expected_overflowA ^ overflowA ^ expected_overflowA) &&
                expected_overflowS === (expected_overflowS ^ overflowS ^ expected_overflowS)) begin
                $display("PASS");
                $display("  Outputs: outAdd=%h, outSub=%h, overflowA=%b, overflowS=%b",
                         outAdd, outSub, overflowA, overflowS);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outAdd=%h, outSub=%h, overflowA=%b, overflowS=%b",
                         expected_outAdd, expected_outSub, expected_overflowA, expected_overflowS);
                $display("  Got:      outAdd=%h, outSub=%h, overflowA=%b, overflowS=%b",
                         outAdd, outSub, overflowA, overflowS);
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
