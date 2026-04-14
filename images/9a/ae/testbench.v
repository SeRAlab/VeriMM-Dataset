`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg input1;
    reg input2;
    reg input3;
    reg input4;
    reg input5;
    wire output1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input1(input1),
        .input2(input2),
        .input3(input3),
        .input4(input4),
        .input5(input5),
        .output1(output1)
    );
    task testcase001;

    begin
        test_num = 1;
        input1 = 1'b0;
        input2 = 1'b0;
        input3 = 1'b0;
        input4 = 1'b0;
        input5 = 1'b0;
        $display("Test Case 001: All inputs 0");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        input1 = 1'b0;
        input2 = 1'b0;
        input3 = 1'b0;
        input4 = 1'b0;
        input5 = 1'b1;
        $display("Test Case 002: input5 (C1) is High");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        input1 = 1'b1;
        input2 = 1'b1;
        input3 = 1'b0;
        input4 = 1'b0;
        input5 = 1'b0;
        $display("Test Case 003: input1 and input2 (A1, A2) are High");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        input1 = 1'b0;
        input2 = 1'b0;
        input3 = 1'b1;
        input4 = 1'b1;
        input5 = 1'b0;
        $display("Test Case 004: input3 and input4 (B1, B2) are High");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        input1 = 1'b1;
        input2 = 1'b0;
        input3 = 1'b1;
        input4 = 1'b0;
        input5 = 1'b0;
        $display("Test Case 005: One from A, one from B are High");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        input1 = 1'b1;
        input2 = 1'b1;
        input3 = 1'b1;
        input4 = 1'b1;
        input5 = 1'b1;
        $display("Test Case 006: All inputs High");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        input1 = 1'b1;
        input2 = 1'b1;
        input3 = 1'b1;
        input4 = 1'b0;
        input5 = 1'b0;
        $display("Test Case 007: A pair is High, B1 is High");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        input1 = 1'b0;
        input2 = 1'b1;
        input3 = 1'b1;
        input4 = 1'b1;
        input5 = 1'b0;
        $display("Test Case 008: B pair is High, A2 is High");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        input1 = 1'b1;
        input2 = 1'b0;
        input3 = 1'b1;
        input4 = 1'b0;
        input5 = 1'b0;
        $display("Test Case 009: Only A1 and B1 High");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        input1 = 1'b0;
        input2 = 1'b1;
        input3 = 1'b1;
        input4 = 1'b0;
        input5 = 1'b1;
        $display("Test Case 010: C1 High, A/B partial");
        #1;

        check_outputs(1'b1);
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
        input expected_output1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output1 === (expected_output1 ^ output1 ^ expected_output1)) begin
                $display("PASS");
                $display("  Outputs: output1=%b",
                         output1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output1=%b",
                         expected_output1);
                $display("  Got:      output1=%b",
                         output1);
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
