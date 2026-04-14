`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg op;
    wire [31:0] result;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiplication Positive * Positive", test_num);
            a = 32'sd12;
            b = 32'sd11;
            op = 1'b0;
            #1;

            check_outputs(32'sd132, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiplication Positive * Negative", test_num);
            a = 32'sd15;
            b = -32'sd4;
            op = 1'b0;
            #1;

            check_outputs(-32'sd60, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiplication Negative * Negative", test_num);
            a = -32'sd10;
            b = -32'sd20;
            op = 1'b0;
            #1;

            check_outputs(32'sd200, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiplication by Zero", test_num);
            a = 32'sd0;
            b = 32'sd12345;
            op = 1'b0;
            #1;

            check_outputs(32'sd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Division Positive / Positive", test_num);
            a = 32'sd100;
            b = 32'sd5;
            op = 1'b1;
            #1;

            check_outputs(32'sd20, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Division Positive / Negative", test_num);
            a = 32'sd100;
            b = -32'sd7;
            op = 1'b1;
            #1;

            check_outputs(-32'sd14, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Division Negative / Negative", test_num);
            a = -32'sd50;
            b = -32'sd5;
            op = 1'b1;
            #1;

            check_outputs(32'sd10, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Division Negative / Positive", test_num);
            a = -32'sd7;
            b = 32'sd3;
            op = 1'b1;
            #1;

            check_outputs(-32'sd2, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Division by Zero", test_num);
            a = 32'sd50;
            b = 32'sd0;
            op = 1'b1;


            #1;



            check_outputs(result, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large Value Multiplication", test_num);
            a = 32'sd46340;
            b = 32'sd46340;
            op = 1'b0;
            #1;

            check_outputs(32'sd2147395600, 1'b1);
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
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: result=%h, valid=%b",
                         result, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, valid=%b",
                         expected_result, expected_valid);
                $display("  Got:      result=%h, valid=%b",
                         result, valid);
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
