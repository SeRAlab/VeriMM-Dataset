`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg S0;
    reg S1;
    reg X0;
    reg X1;
    reg X2;
    reg X3;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .S0(S0),
        .S1(S1),
        .X0(X0),
        .X1(X1),
        .X2(X2),
        .X3(X3),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        S1 = 0; S0 = 0;
        X0 = 0; X1 = 1; X2 = 1; X3 = 1;
        $display("Test %0d: S1S0=00 (Select X0), X0=0", test_num);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        S1 = 0; S0 = 0;
        X0 = 1; X1 = 0; X2 = 0; X3 = 0;
        $display("Test %0d: S1S0=00 (Select X0), X0=1", test_num);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        S1 = 0; S0 = 1;
        X0 = 1; X1 = 0; X2 = 1; X3 = 1;
        $display("Test %0d: S1S0=01 (Select X1), X1=0", test_num);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        S1 = 0; S0 = 1;
        X0 = 0; X1 = 1; X2 = 0; X3 = 0;
        $display("Test %0d: S1S0=01 (Select X1), X1=1", test_num);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        S1 = 1; S0 = 0;
        X0 = 1; X1 = 1; X2 = 0; X3 = 1;
        $display("Test %0d: S1S0=10 (Select X2), X2=0", test_num);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        S1 = 1; S0 = 0;
        X0 = 0; X1 = 0; X2 = 1; X3 = 0;
        $display("Test %0d: S1S0=10 (Select X2), X2=1", test_num);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        S1 = 1; S0 = 1;
        X0 = 1; X1 = 1; X2 = 1; X3 = 0;
        $display("Test %0d: S1S0=11 (Select X3), X3=0", test_num);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        S1 = 1; S0 = 1;
        X0 = 0; X1 = 0; X2 = 0; X3 = 1;
        $display("Test %0d: S1S0=11 (Select X3), X3=1", test_num);
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
