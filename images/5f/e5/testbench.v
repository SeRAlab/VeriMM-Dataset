`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg cin;
    wire c;
    wire cout;
    wire d;
    wire e;
    wire f;
    wire g;
    wire h;
    wire i;
    wire j;
    wire sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .cin(cin),
        .c(c),
        .cout(cout),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .h(h),
        .i(i),
        .j(j),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 0; b = 0; cin = 0;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 0; b = 0; cin = 1;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 0; b = 1; cin = 0;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 0; b = 1; cin = 1;
            #1;

            check_outputs(0, 1, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 1; b = 0; cin = 0;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 1; b = 0; cin = 1;
            #1;

            check_outputs(0, 1, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 1; b = 1; cin = 0;
            #1;

            check_outputs(0, 1, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 1; b = 1; cin = 1;
            #1;

            check_outputs(0, 1, 0, 0, 0, 0, 0, 0, 0, 1);
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
        input expected_c;
        input expected_cout;
        input expected_d;
        input expected_e;
        input expected_f;
        input expected_g;
        input expected_h;
        input expected_i;
        input expected_j;
        input expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c) &&
                expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_d === (expected_d ^ d ^ expected_d) &&
                expected_e === (expected_e ^ e ^ expected_e) &&
                expected_f === (expected_f ^ f ^ expected_f) &&
                expected_g === (expected_g ^ g ^ expected_g) &&
                expected_h === (expected_h ^ h ^ expected_h) &&
                expected_i === (expected_i ^ i ^ expected_i) &&
                expected_j === (expected_j ^ j ^ expected_j) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: c=%b, cout=%b, d=%b, e=%b, f=%b, g=%b, h=%b, i=%b, j=%b, sum=%b",
                         c, cout, d, e, f, g, h, i, j, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%b, cout=%b, d=%b, e=%b, f=%b, g=%b, h=%b, i=%b, j=%b, sum=%b",
                         expected_c, expected_cout, expected_d, expected_e, expected_f, expected_g, expected_h, expected_i, expected_j, expected_sum);
                $display("  Got:      c=%b, cout=%b, d=%b, e=%b, f=%b, g=%b, h=%b, i=%b, j=%b, sum=%b",
                         c, cout, d, e, f, g, h, i, j, sum);
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
