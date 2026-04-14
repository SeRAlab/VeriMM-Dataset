`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    wire a;
    wire b;
    wire c;
    wire d;
    wire e;
    wire f;
    wire g;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: BCD Input 0 (0000)", test_num);
            A = 0; B = 0; C = 0; D = 0;

            #1;


            check_outputs(1, 1, 1, 1, 1, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: BCD Input 1 (0001)", test_num);
            A = 0; B = 0; C = 0; D = 1;

            #1;


            check_outputs(0, 1, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: BCD Input 2 (0010)", test_num);
            A = 0; B = 0; C = 1; D = 0;

            #1;


            check_outputs(1, 1, 0, 1, 1, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: BCD Input 3 (0011)", test_num);
            A = 0; B = 0; C = 1; D = 1;

            #1;


            check_outputs(1, 1, 1, 1, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: BCD Input 4 (0100)", test_num);
            A = 0; B = 1; C = 0; D = 0;

            #1;


            check_outputs(0, 1, 1, 0, 0, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: BCD Input 5 (0101)", test_num);
            A = 0; B = 1; C = 0; D = 1;

            #1;


            check_outputs(1, 0, 1, 1, 0, 1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: BCD Input 6 (0110)", test_num);
            A = 0; B = 1; C = 1; D = 0;

            #1;


            check_outputs(1, 0, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: BCD Input 7 (0111)", test_num);
            A = 0; B = 1; C = 1; D = 1;

            #1;


            check_outputs(1, 1, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: BCD Input 8 (1000)", test_num);
            A = 1; B = 0; C = 0; D = 0;

            #1;


            check_outputs(1, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: BCD Input 9 (1001)", test_num);
            A = 1; B = 0; C = 0; D = 1;

            #1;


            check_outputs(1, 1, 1, 1, 0, 1, 1);
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
        input expected_a;
        input expected_b;
        input expected_c;
        input expected_d;
        input expected_e;
        input expected_f;
        input expected_g;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a === (expected_a ^ a ^ expected_a) &&
                expected_b === (expected_b ^ b ^ expected_b) &&
                expected_c === (expected_c ^ c ^ expected_c) &&
                expected_d === (expected_d ^ d ^ expected_d) &&
                expected_e === (expected_e ^ e ^ expected_e) &&
                expected_f === (expected_f ^ f ^ expected_f) &&
                expected_g === (expected_g ^ g ^ expected_g)) begin
                $display("PASS");
                $display("  Outputs: a=%b, b=%b, c=%b, d=%b, e=%b, f=%b, g=%b",
                         a, b, c, d, e, f, g);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a=%b, b=%b, c=%b, d=%b, e=%b, f=%b, g=%b",
                         expected_a, expected_b, expected_c, expected_d, expected_e, expected_f, expected_g);
                $display("  Got:      a=%b, b=%b, c=%b, d=%b, e=%b, f=%b, g=%b",
                         a, b, c, d, e, f, g);
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
