`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A_invert;
    reg B_invert;
    reg cin;
    reg less;
    reg [1:0] operation;
    reg src1;
    reg src2;
    wire g;
    wire p;
    wire result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A_invert(A_invert),
        .B_invert(B_invert),
        .cin(cin),
        .less(less),
        .operation(operation),
        .src1(src1),
        .src2(src2),
        .g(g),
        .p(p),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: AND Operation (1 AND 1)", test_num);
            src1 = 1; src2 = 1; A_invert = 0; B_invert = 0; cin = 0; less = 0; operation = 2'b00;

            #1;


            check_outputs(1, 1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: AND Operation (1 AND 0)", test_num);
            src1 = 1; src2 = 0; A_invert = 0; B_invert = 0; cin = 0; less = 0; operation = 2'b00;

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: OR Operation (0 OR 1)", test_num);
            src1 = 0; src2 = 1; A_invert = 0; B_invert = 0; cin = 0; less = 0; operation = 2'b01;

            #1;


            check_outputs(0, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Adder Operation (0 + 1 + cin=0)", test_num);
            src1 = 0; src2 = 1; A_invert = 0; B_invert = 0; cin = 0; less = 0; operation = 2'b10;

            #1;


            check_outputs(0, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Adder Operation (1 + 1 + cin=1)", test_num);
            src1 = 1; src2 = 1; A_invert = 0; B_invert = 0; cin = 1; less = 0; operation = 2'b10;

            #1;


            check_outputs(1, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Less Operation (Pass less=1)", test_num);
            src1 = 0; src2 = 0; A_invert = 0; B_invert = 0; cin = 0; less = 1; operation = 2'b11;

            #1;


            check_outputs(0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: A_invert Logic (Invert 1 to 0, then AND)", test_num);
            src1 = 1; src2 = 1; A_invert = 1; B_invert = 0; cin = 0; less = 0; operation = 2'b00;

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Subtraction (1 - 1 via B_invert and cin)", test_num);
            src1 = 1; src2 = 1; A_invert = 0; B_invert = 1; cin = 1; less = 0; operation = 2'b10;

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Both Invert (Invert 0,0 to 1,1 then OR)", test_num);
            src1 = 0; src2 = 0; A_invert = 1; B_invert = 1; cin = 0; less = 0; operation = 2'b01;

            #1;


            check_outputs(1, 1, 1);
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
        input expected_g;
        input expected_p;
        input expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_g === (expected_g ^ g ^ expected_g) &&
                expected_p === (expected_p ^ p ^ expected_p) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: g=%b, p=%b, result=%b",
                         g, p, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: g=%b, p=%b, result=%b",
                         expected_g, expected_p, expected_result);
                $display("  Got:      g=%b, p=%b, result=%b",
                         g, p, result);
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
