`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg h1;
    reg h2;
    reg h3;
    reg p;
    reg sign;
    wire Q1H;
    wire Q1L;
    wire Q2H;
    wire Q2L;
    wire Q3H;
    wire Q3L;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .h1(h1),
        .h2(h2),
        .h3(h3),
        .p(p),
        .sign(sign),
        .Q1H(Q1H),
        .Q1L(Q1L),
        .Q2H(Q2H),
        .Q2L(Q2L),
        .Q3H(Q3H),
        .Q3L(Q3L)
    );
    task testcase001;

    begin
        test_num = 1;
        h1 = 0; h2 = 0; h3 = 0; p = 0; sign = 0;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        h1 = 1; h2 = 0; h3 = 1; p = 1; sign = 0;
        #1;

        check_outputs(1, 0, 0, 1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        h1 = 1; h2 = 0; h3 = 0; p = 1; sign = 0;
        #1;

        check_outputs(1, 0, 0, 0, 0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        h1 = 1; h2 = 1; h3 = 0; p = 1; sign = 0;
        #1;

        check_outputs(0, 0, 1, 0, 0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        h1 = 0; h2 = 1; h3 = 0; p = 1; sign = 0;
        #1;

        check_outputs(0, 1, 1, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        h1 = 0; h2 = 1; h3 = 1; p = 1; sign = 0;
        #1;

        check_outputs(0, 1, 0, 0, 1, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        h1 = 0; h2 = 0; h3 = 1; p = 1; sign = 0;
        #1;

        check_outputs(0, 0, 0, 1, 1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        h1 = 1; h2 = 0; h3 = 1; p = 0; sign = 0;
        #1;

        check_outputs(1, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        h1 = 1; h2 = 0; h3 = 1; p = 1; sign = 1;
        #1;

        check_outputs(0, 1, 1, 0, 0, 0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        h1 = 0; h2 = 0; h3 = 1; p = 1; sign = 1;
        #1;

        check_outputs(0, 0, 0, 0, 0, 1);


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
        input expected_Q1H;
        input expected_Q1L;
        input expected_Q2H;
        input expected_Q2L;
        input expected_Q3H;
        input expected_Q3L;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q1H === (expected_Q1H ^ Q1H ^ expected_Q1H) &&
                expected_Q1L === (expected_Q1L ^ Q1L ^ expected_Q1L) &&
                expected_Q2H === (expected_Q2H ^ Q2H ^ expected_Q2H) &&
                expected_Q2L === (expected_Q2L ^ Q2L ^ expected_Q2L) &&
                expected_Q3H === (expected_Q3H ^ Q3H ^ expected_Q3H) &&
                expected_Q3L === (expected_Q3L ^ Q3L ^ expected_Q3L)) begin
                $display("PASS");
                $display("  Outputs: Q1H=%b, Q1L=%b, Q2H=%b, Q2L=%b, Q3H=%b, Q3L=%b",
                         Q1H, Q1L, Q2H, Q2L, Q3H, Q3L);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q1H=%b, Q1L=%b, Q2H=%b, Q2L=%b, Q3H=%b, Q3L=%b",
                         expected_Q1H, expected_Q1L, expected_Q2H, expected_Q2L, expected_Q3H, expected_Q3L);
                $display("  Got:      Q1H=%b, Q1L=%b, Q2H=%b, Q2L=%b, Q3H=%b, Q3L=%b",
                         Q1H, Q1L, Q2H, Q2L, Q3H, Q3L);
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
