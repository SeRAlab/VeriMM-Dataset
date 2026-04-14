`timescale 1ns/1ps

module five_input_module_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg A2;
    reg A3;
    reg B1;
    reg B2;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    five_input_module dut (
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .B1(B1),
        .B2(B2),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Condition (A1 & A2) - High", test_num);
        A1 = 1; A2 = 1; A3 = 0; B1 = 0; B2 = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Condition (A1 & A3) - High", test_num);
        A1 = 1; A2 = 0; A3 = 1; B1 = 0; B2 = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Condition (B1 & B2) - High", test_num);
        A1 = 0; A2 = 0; A3 = 0; B1 = 1; B2 = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Only A1 is High - Low", test_num);
        A1 = 1; A2 = 0; A3 = 0; B1 = 0; B2 = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: A2 and A3 High, but A1 is Low - Low", test_num);
        A1 = 0; A2 = 1; A3 = 1; B1 = 0; B2 = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Only B1 is High - Low", test_num);
        A1 = 0; A2 = 0; A3 = 0; B1 = 1; B2 = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: All inputs Low - Low", test_num);
        A1 = 0; A2 = 0; A3 = 0; B1 = 0; B2 = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: All inputs High - High", test_num);
        A1 = 1; A2 = 1; A3 = 1; B1 = 1; B2 = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: A1, A2, and B1 are High (Overlapping A and B) - High", test_num);
        A1 = 1; A2 = 1; A3 = 0; B1 = 1; B2 = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Partial conditions (A1, A2, B2) - High", test_num);
        A1 = 1; A2 = 1; A3 = 0; B1 = 0; B2 = 1;
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
        $display("five_input_module Testbench");
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
