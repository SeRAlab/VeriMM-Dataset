`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg C;
    reg S;
    wire C_out;
    wire [3:0] F;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .S(S),
        .C_out(C_out),
        .F(F)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (2 + 3 + 0)", test_num);
            A = 4'd2; B = 4'd3; S = 1'b0; C = 1'b0;
            #1;

            check_outputs(1'b0, 4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with Carry (2 + 3 + 1)", test_num);
            A = 4'd2; B = 4'd3; S = 1'b0; C = 1'b1;
            #1;

            check_outputs(1'b0, 4'd6);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Overflow (10 + 10 + 0)", test_num);
            A = 4'd10; B = 4'd10; S = 1'b0; C = 1'b0;
            #1;

            check_outputs(1'b1, 4'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Boundary (15 + 0 + 1)", test_num);
            A = 4'd15; B = 4'd0; S = 1'b0; C = 1'b1;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (10 - 4 - 0)", test_num);
            A = 4'd10; B = 4'd4; S = 1'b1; C = 1'b0;
            #1;

            check_outputs(1'b0, 4'd6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction with Borrow (10 - 4 - 1)", test_num);
            A = 4'd10; B = 4'd4; S = 1'b1; C = 1'b1;
            #1;

            check_outputs(1'b0, 4'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Underflow (4 - 10 - 0)", test_num);
            A = 4'd4; B = 4'd10; S = 1'b1; C = 1'b0;
            #1;

            check_outputs(1'b1, 4'd10);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Underflow with Borrow In (4 - 10 - 1)", test_num);
            A = 4'd4; B = 4'd10; S = 1'b1; C = 1'b1;
            #1;

            check_outputs(1'b1, 4'd9);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Zero (5 - 5 - 0)", test_num);
            A = 4'd5; B = 4'd5; S = 1'b1; C = 1'b0;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Addition (15 + 15 + 1)", test_num);
            A = 4'd15; B = 4'd15; S = 1'b0; C = 1'b1;
            #1;

            check_outputs(1'b1, 4'd15);
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
        input expected_C_out;
        input [3:0] expected_F;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C_out === (expected_C_out ^ C_out ^ expected_C_out) &&
                expected_F === (expected_F ^ F ^ expected_F)) begin
                $display("PASS");
                $display("  Outputs: C_out=%b, F=%h",
                         C_out, F);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C_out=%b, F=%h",
                         expected_C_out, expected_F);
                $display("  Got:      C_out=%b, F=%h",
                         C_out, F);
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
