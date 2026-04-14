`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A0;
    reg A1;
    reg S;
    wire X0;
    wire X1;
    wire X2;
    wire X3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A0(A0),
        .A1(A1),
        .S(S),
        .X0(X0),
        .X1(X1),
        .X2(X2),
        .X3(X3)
    );
    task testcase001;

        begin
            test_num = 1;
            S = 0; A1 = 0; A0 = 0;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            S = 0; A1 = 1; A0 = 1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            S = 1; A1 = 0; A0 = 0;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            S = 1; A1 = 0; A0 = 1;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            S = 1; A1 = 1; A0 = 0;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            S = 1; A1 = 1; A0 = 1;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            S = 1; A1 = 0; A0 = 0; #5;
            A0 = 1;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            S = 1; A1 = 0; A0 = 1; #5;
            A1 = 1;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A1 = 1; A0 = 0; S = 1; #5;
            S = 0;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            S = 0; A1 = 1; A0 = 0;
            #1;

            check_outputs(0, 0, 0, 0);
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
        input expected_X0;
        input expected_X1;
        input expected_X2;
        input expected_X3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X0 === (expected_X0 ^ X0 ^ expected_X0) &&
                expected_X1 === (expected_X1 ^ X1 ^ expected_X1) &&
                expected_X2 === (expected_X2 ^ X2 ^ expected_X2) &&
                expected_X3 === (expected_X3 ^ X3 ^ expected_X3)) begin
                $display("PASS");
                $display("  Outputs: X0=%b, X1=%b, X2=%b, X3=%b",
                         X0, X1, X2, X3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X0=%b, X1=%b, X2=%b, X3=%b",
                         expected_X0, expected_X1, expected_X2, expected_X3);
                $display("  Got:      X0=%b, X1=%b, X2=%b, X3=%b",
                         X0, X1, X2, X3);
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
