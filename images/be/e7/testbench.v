`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg operation;
    wire [8:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .operation(operation),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 8'd10;
            b = 8'd20;
            operation = 1'b1;
            $display("Test %0d: Simple Addition (10 + 20)", test_num);
            #1;

            check_outputs(9'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 8'd255;
            b = 8'd1;
            operation = 1'b1;
            $display("Test %0d: Addition with Overflow Bit (255 + 1)", test_num);
            #1;

            check_outputs(9'd256);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 8'd255;
            b = 8'd255;
            operation = 1'b1;
            $display("Test %0d: Maximum Addition (255 + 255)", test_num);
            #1;

            check_outputs(9'd510);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 8'd100;
            b = 8'd40;
            operation = 1'b0;
            $display("Test %0d: Simple Subtraction (100 - 40)", test_num);
            #1;

            check_outputs(9'd60);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 8'd50;
            b = 8'd50;
            operation = 1'b0;
            $display("Test %0d: Subtraction Resulting in Zero (50 - 50)", test_num);
            #1;

            check_outputs(9'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 8'd0;
            b = 8'd1;
            operation = 1'b0;
            $display("Test %0d: Subtraction with Borrow/Wrap (0 - 1)", test_num);

            #1;


            check_outputs(9'h1FF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 8'd10;
            b = 8'd20;
            operation = 1'b0;
            $display("Test %0d: Subtraction with Negative Result (10 - 20)", test_num);

            #1;


            check_outputs(9'd502);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 8'hAA;
            b = 8'h55;
            operation = 1'b1;
            $display("Test %0d: Bit Pattern Addition (0xAA + 0x55)", test_num);
            #1;

            check_outputs(9'h0FF);
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
        input [8:0] expected_result;
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
