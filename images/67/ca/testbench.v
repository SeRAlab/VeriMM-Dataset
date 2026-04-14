`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] op;
    reg [3:0] reg_a;
    reg [3:0] reg_b;
    reg start;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .op(op),
        .reg_a(reg_a),
        .reg_b(reg_b),
        .start(start),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Addition (5 + 3)", test_num);
            op = 2'b00;
            reg_a = 4'd5;
            reg_b = 4'd3;
            start = 1'b1;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Subtraction (10 - 4)", test_num);
            op = 2'b01;
            reg_a = 4'd10;
            reg_b = 4'd4;
            start = 1'b1;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Multiplication (3 * 4)", test_num);
            op = 2'b10;
            reg_a = 4'd3;
            reg_b = 4'd4;
            start = 1'b1;
            #1;

            check_outputs(4'd12);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Division (12 / 3)", test_num);
            op = 2'b11;
            reg_a = 4'd12;
            reg_b = 4'd3;
            start = 1'b1;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Addition Overflow (12 + 5)", test_num);
            op = 2'b00;
            reg_a = 4'd12;
            reg_b = 4'd5;
            start = 1'b1;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Subtraction Underflow (2 - 5)", test_num);
            op = 2'b01;
            reg_a = 4'd2;
            reg_b = 4'd5;
            start = 1'b1;
            #1;

            check_outputs(4'd13);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Multiplication Overflow (5 * 4)", test_num);
            op = 2'b10;
            reg_a = 4'd5;
            reg_b = 4'd4;
            start = 1'b1;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Division Integer (7 / 2)", test_num);
            op = 2'b11;
            reg_a = 4'd7;
            reg_b = 4'd2;
            start = 1'b1;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Start Inactive", test_num);
            op = 2'b00;
            reg_a = 4'd5;
            reg_b = 4'd5;
            start = 1'b0;


            #1;



            check_outputs(4'd0);
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
        input [3:0] expected_result;
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
