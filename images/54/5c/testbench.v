`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg A2;
    reg B1;
    reg B2;
    reg C1;
    reg C2;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1(A1),
        .A2(A2),
        .B1(B1),
        .B2(B2),
        .C1(C1),
        .C2(C2),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All inputs LOW", test_num);
        A1 = 0; A2 = 0; B1 = 0; B2 = 0; C1 = 0; C2 = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A pair HIGH (A1=1, A2=1), others LOW", test_num);
        A1 = 1; A2 = 1; B1 = 0; B2 = 0; C1 = 0; C2 = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: B pair HIGH (B1=1, B2=1), others LOW", test_num);
        A1 = 0; A2 = 0; B1 = 1; B2 = 1; C1 = 0; C2 = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: C pair HIGH (C1=1, C2=1), others LOW", test_num);
        A1 = 0; A2 = 0; B1 = 0; B2 = 0; C1 = 1; C2 = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Partial pairs (one from each pair), expect LOW", test_num);
        A1 = 1; A2 = 0; B1 = 1; B2 = 0; C1 = 1; C2 = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Crossed partial pairs, expect LOW", test_num);
        A1 = 0; A2 = 1; B1 = 1; B2 = 0; C1 = 0; C2 = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiple pairs HIGH (A and B)", test_num);
        A1 = 1; A2 = 1; B1 = 1; B2 = 1; C1 = 0; C2 = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All inputs HIGH", test_num);
        A1 = 1; A2 = 1; B1 = 1; B2 = 1; C1 = 1; C2 = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Only one input HIGH", test_num);
        A1 = 0; A2 = 1; B1 = 0; B2 = 0; C1 = 0; C2 = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: One full pair (C) and extra high signals", test_num);
        A1 = 1; A2 = 0; B1 = 0; B2 = 1; C1 = 1; C2 = 1;
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
