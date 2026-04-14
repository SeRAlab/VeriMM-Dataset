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
    wire equal;
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
        .equal(equal),
        .g(g),
        .p(p),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        src1 = 1'b1; src2 = 1'b1; A_invert = 1'b0; B_invert = 1'b0;
        cin = 1'b0; operation = 2'b00; less = 1'b0;

        #1;


        check_outputs(1'b1, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        src1 = 1'b1; src2 = 1'b1; A_invert = 1'b1; B_invert = 1'b0;
        cin = 1'b0; operation = 2'b00; less = 1'b0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        src1 = 1'b1; src2 = 1'b0; A_invert = 1'b0; B_invert = 1'b0;
        cin = 1'b0; operation = 2'b01; less = 1'b0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        src1 = 1'b0; src2 = 1'b0; A_invert = 1'b1; B_invert = 1'b1;
        cin = 1'b0; operation = 2'b01; less = 1'b0;

        #1;


        check_outputs(1'b1, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        src1 = 1'b1; src2 = 1'b0; A_invert = 1'b0; B_invert = 1'b0;
        cin = 1'b0; operation = 2'b10; less = 1'b0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        src1 = 1'b1; src2 = 1'b1; A_invert = 1'b0; B_invert = 1'b0;
        cin = 1'b1; operation = 2'b10; less = 1'b0;

        #1;


        check_outputs(1'b1, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        src1 = 1'b1; src2 = 1'b1; A_invert = 1'b0; B_invert = 1'b1;
        cin = 1'b1; operation = 2'b10; less = 1'b0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        src1 = 1'b0; src2 = 1'b0; A_invert = 1'b0; B_invert = 1'b0;
        cin = 1'b0; operation = 2'b11; less = 1'b1;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        src1 = 1'b0; src2 = 1'b0; A_invert = 1'b0; B_invert = 1'b0;
        cin = 1'b0; operation = 2'b11; less = 1'b0;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        src1 = 1'b0; src2 = 1'b1; A_invert = 1'b1; B_invert = 1'b1;
        cin = 1'b0; operation = 2'b00; less = 1'b0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
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
        input expected_equal;
        input expected_g;
        input expected_p;
        input expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_equal === (expected_equal ^ equal ^ expected_equal) &&
                expected_g === (expected_g ^ g ^ expected_g) &&
                expected_p === (expected_p ^ p ^ expected_p) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: equal=%b, g=%b, p=%b, result=%b",
                         equal, g, p, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: equal=%b, g=%b, p=%b, result=%b",
                         expected_equal, expected_g, expected_p, expected_result);
                $display("  Got:      equal=%b, g=%b, p=%b, result=%b",
                         equal, g, p, result);
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
