`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [3:0] add;
    wire [3:0] div;
    wire [3:0] mul;
    wire [3:0] sub;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .add(add),
        .div(div),
        .mul(mul),
        .sub(sub)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple arithmetic (A=4, B=2)", test_num);
            A = 4'd4; B = 4'd2;
            #1;

            check_outputs(4'd6, 4'd2, 4'd8, 4'd2);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum and Minimum (A=15, B=1)", test_num);
            A = 4'd15; B = 4'd1;

            #1;


            check_outputs(4'd0, 4'd15, 4'd15, 4'd14);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition Overflow (A=10, B=7)", test_num);
            A = 4'd10; B = 4'd7;

            #1;


            check_outputs(4'd1, 4'd1, 4'd6, 4'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction Wrap-around (A=3, B=5)", test_num);
            A = 4'd3; B = 4'd5;

            #1;


            check_outputs(4'd8, 4'd0, 4'd15, 4'd14);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication Overflow (A=4, B=4)", test_num);
            A = 4'd4; B = 4'd4;

            #1;


            check_outputs(4'd8, 4'd1, 4'd0, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large values (A=15, B=15)", test_num);
            A = 4'd15; B = 4'd15;

            #1;


            check_outputs(4'd14, 4'd1, 4'd1, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Operand A (A=0, B=8)", test_num);
            A = 4'd0; B = 4'd8;

            #1;


            check_outputs(4'd8, 4'd0, 4'd0, 4'd8);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Exact Division (A=12, B=3)", test_num);
            A = 4'd12; B = 4'd3;

            #1;


            check_outputs(4'd15, 4'd4, 4'd4, 4'd9);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power of 2 (A=8, B=8)", test_num);
            A = 4'd8; B = 4'd8;

            #1;


            check_outputs(4'd0, 4'd1, 4'd0, 4'd0);
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
        input [3:0] expected_add;
        input [3:0] expected_div;
        input [3:0] expected_mul;
        input [3:0] expected_sub;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_add === (expected_add ^ add ^ expected_add) &&
                expected_div === (expected_div ^ div ^ expected_div) &&
                expected_mul === (expected_mul ^ mul ^ expected_mul) &&
                expected_sub === (expected_sub ^ sub ^ expected_sub)) begin
                $display("PASS");
                $display("  Outputs: add=%h, div=%h, mul=%h, sub=%h",
                         add, div, mul, sub);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: add=%h, div=%h, mul=%h, sub=%h",
                         expected_add, expected_div, expected_mul, expected_sub);
                $display("  Got:      add=%h, div=%h, mul=%h, sub=%h",
                         add, div, mul, sub);
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
