`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg D;
    reg S0;
    reg S1;
    wire Q0;
    wire Q1;
    wire Q2;
    wire Q3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .S0(S0),
        .S1(S1),
        .Q0(Q0),
        .Q1(Q1),
        .Q2(Q2),
        .Q3(Q3)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Select Q0, D=0", test_num);
        S1 = 0; S0 = 0; D = 0;
        #1;

        check_outputs(1'b0, 1'bz, 1'bz, 1'bz);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Select Q0, D=1", test_num);
        S1 = 0; S0 = 0; D = 1;
        #1;

        check_outputs(1'b1, 1'bz, 1'bz, 1'bz);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Select Q1, D=0", test_num);
        S1 = 0; S0 = 1; D = 0;
        #1;

        check_outputs(1'bz, 1'b0, 1'bz, 1'bz);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Select Q1, D=1", test_num);
        S1 = 0; S0 = 1; D = 1;
        #1;

        check_outputs(1'bz, 1'b1, 1'bz, 1'bz);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Select Q2, D=0", test_num);
        S1 = 1; S0 = 0; D = 0;
        #1;

        check_outputs(1'bz, 1'bz, 1'b0, 1'bz);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Select Q2, D=1", test_num);
        S1 = 1; S0 = 0; D = 1;
        #1;

        check_outputs(1'bz, 1'bz, 1'b1, 1'bz);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Select Q3, D=0", test_num);
        S1 = 1; S0 = 1; D = 0;
        #1;

        check_outputs(1'bz, 1'bz, 1'bz, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Select Q3, D=1", test_num);
        S1 = 1; S0 = 1; D = 1;
        #1;

        check_outputs(1'bz, 1'bz, 1'bz, 1'b1);
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
        input expected_Q0;
        input expected_Q1;
        input expected_Q2;
        input expected_Q3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q0 === (expected_Q0 ^ Q0 ^ expected_Q0) &&
                expected_Q1 === (expected_Q1 ^ Q1 ^ expected_Q1) &&
                expected_Q2 === (expected_Q2 ^ Q2 ^ expected_Q2) &&
                expected_Q3 === (expected_Q3 ^ Q3 ^ expected_Q3)) begin
                $display("PASS");
                $display("  Outputs: Q0=%b, Q1=%b, Q2=%b, Q3=%b",
                         Q0, Q1, Q2, Q3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q0=%b, Q1=%b, Q2=%b, Q3=%b",
                         expected_Q0, expected_Q1, expected_Q2, expected_Q3);
                $display("  Got:      Q0=%b, Q1=%b, Q2=%b, Q3=%b",
                         Q0, Q1, Q2, Q3);
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
