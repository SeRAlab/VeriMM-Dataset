`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg X1;
    reg X2;
    reg X3;
    reg X4;
    reg X5;
    reg X6;
    reg X7;
    wire f;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .X1(X1),
        .X2(X2),
        .X3(X3),
        .X4(X4),
        .X5(X5),
        .X6(X6),
        .X7(X7),
        .f(f)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All sensors active (7 HIGHs)", test_num);
            X1 = 1; X2 = 1; X3 = 1; X4 = 1; X5 = 1; X6 = 1; X7 = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Exactly one sensor inactive (X1=0)", test_num);
            X1 = 0; X2 = 1; X3 = 1; X4 = 1; X5 = 1; X6 = 1; X7 = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Exactly one sensor inactive (X7=0)", test_num);
            X1 = 1; X2 = 1; X3 = 1; X4 = 1; X5 = 1; X6 = 1; X7 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Exactly two sensors inactive (X1, X2=0)", test_num);
            X1 = 0; X2 = 0; X3 = 1; X4 = 1; X5 = 1; X6 = 1; X7 = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Exactly two sensors inactive (X6, X7=0)", test_num);
            X1 = 1; X2 = 1; X3 = 1; X4 = 1; X5 = 1; X6 = 0; X7 = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Three sensors inactive (X1, X4, X7=0)", test_num);
            X1 = 0; X2 = 1; X3 = 1; X4 = 0; X5 = 1; X6 = 1; X7 = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: All sensors inactive (7 LOWs)", test_num);
            X1 = 0; X2 = 0; X3 = 0; X4 = 0; X5 = 0; X6 = 0; X7 = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Boundary - Five active, Two inactive (X3, X5=0)", test_num);
            X1 = 1; X2 = 1; X3 = 0; X4 = 1; X5 = 0; X6 = 1; X7 = 1;
            #1;

            check_outputs(1);
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
        input expected_f;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_f === (expected_f ^ f ^ expected_f)) begin
                $display("PASS");
                $display("  Outputs: f=%b",
                         f);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f=%b",
                         expected_f);
                $display("  Got:      f=%b",
                         f);
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
