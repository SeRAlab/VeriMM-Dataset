`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    wire Z1;
    wire Z2;
    wire Z3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .Z1(Z1),
        .Z2(Z2),
        .Z3(Z3)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: a=0, b=0, c=0");
            a = 0; b = 0; c = 0;

            #1;


            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: a=0, b=0, c=1");
            a = 0; b = 0; c = 1;

            #1;


            check_outputs(0, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: a=0, b=1, c=0");
            a = 0; b = 1; c = 0;

            #1;


            check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: a=0, b=1, c=1");
            a = 0; b = 1; c = 1;

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: a=1, b=0, c=0");
            a = 1; b = 0; c = 0;

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: a=1, b=0, c=1");
            a = 1; b = 0; c = 1;

            #1;


            check_outputs(0, 1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: a=1, b=1, c=0");
            a = 1; b = 1; c = 0;

            #1;


            check_outputs(1, 1, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: a=1, b=1, c=1");
            a = 1; b = 1; c = 1;

            #1;


            check_outputs(1, 1, 0);
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
        input expected_Z1;
        input expected_Z2;
        input expected_Z3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z1 === (expected_Z1 ^ Z1 ^ expected_Z1) &&
                expected_Z2 === (expected_Z2 ^ Z2 ^ expected_Z2) &&
                expected_Z3 === (expected_Z3 ^ Z3 ^ expected_Z3)) begin
                $display("PASS");
                $display("  Outputs: Z1=%b, Z2=%b, Z3=%b",
                         Z1, Z2, Z3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z1=%b, Z2=%b, Z3=%b",
                         expected_Z1, expected_Z2, expected_Z3);
                $display("  Got:      Z1=%b, Z2=%b, Z3=%b",
                         Z1, Z2, Z3);
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
