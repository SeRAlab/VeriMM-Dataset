`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [1:0] op;
    wire [3:0] add_out;
    wire [3:0] div_out;
    wire [3:0] mul_out;
    wire [3:0] sub_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .add_out(add_out),
        .div_out(div_out),
        .mul_out(mul_out),
        .sub_out(sub_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (5 + 3)", test_num);
            a = 4'd5; b = 4'd3; op = 2'b00;

            #1;


            check_outputs(4'd8, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition Overflow (12 + 7)", test_num);
            a = 4'd12; b = 4'd7; op = 2'b00;

            #1;


            check_outputs(4'd3, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (10 - 4)", test_num);
            a = 4'd10; b = 4'd4; op = 2'b01;

            #1;


            check_outputs(4'd0, 4'd0, 4'd0, 4'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction Underflow (3 - 5)", test_num);
            a = 4'd3; b = 4'd5; op = 2'b01;

            #1;


            check_outputs(4'd0, 4'd0, 4'd0, 4'd14);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication (3 * 4)", test_num);
            a = 4'd3; b = 4'd4; op = 2'b10;

            #1;


            check_outputs(4'd0, 4'd0, 4'd12, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication Overflow (8 * 2)", test_num);
            a = 4'd8; b = 4'd2; op = 2'b10;

            #1;


            check_outputs(4'd0, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division (12 / 3)", test_num);
            a = 4'd12; b = 4'd3; op = 2'b11;

            #1;


            check_outputs(4'd0, 4'd4, 4'd0, 4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Integer Division (7 / 2)", test_num);
            a = 4'd7; b = 4'd2; op = 2'b11;

            #1;


            check_outputs(4'd0, 4'd3, 4'd0, 4'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division by Zero", test_num);
            a = 4'd10; b = 4'd0; op = 2'b11;

            #1;


            check_outputs(4'd0, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Value Multiplication (15 * 15)", test_num);
            a = 4'd15; b = 4'd15; op = 2'b10;

            #1;


            check_outputs(4'd0, 4'd0, 4'd1, 4'd0);
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
        input [3:0] expected_add_out;
        input [3:0] expected_div_out;
        input [3:0] expected_mul_out;
        input [3:0] expected_sub_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_add_out === (expected_add_out ^ add_out ^ expected_add_out) &&
                expected_div_out === (expected_div_out ^ div_out ^ expected_div_out) &&
                expected_mul_out === (expected_mul_out ^ mul_out ^ expected_mul_out) &&
                expected_sub_out === (expected_sub_out ^ sub_out ^ expected_sub_out)) begin
                $display("PASS");
                $display("  Outputs: add_out=%h, div_out=%h, mul_out=%h, sub_out=%h",
                         add_out, div_out, mul_out, sub_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: add_out=%h, div_out=%h, mul_out=%h, sub_out=%h",
                         expected_add_out, expected_div_out, expected_mul_out, expected_sub_out);
                $display("  Got:      add_out=%h, div_out=%h, mul_out=%h, sub_out=%h",
                         add_out, div_out, mul_out, sub_out);
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
