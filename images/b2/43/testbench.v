`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg input_1;
    reg input_2;
    reg input_3;
    reg input_4;
    wire output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_1(input_1),
        .input_2(input_2),
        .input_3(input_3),
        .input_4(input_4),
        .output_signal(output_signal)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: All inputs LOW");
        input_1 = 0; input_2 = 0; input_3 = 0; input_4 = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: One input HIGH (input_3)");
        input_1 = 0; input_2 = 0; input_3 = 1; input_4 = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Two inputs HIGH (1 and 2)");
        input_1 = 1; input_2 = 1; input_3 = 0; input_4 = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Three inputs HIGH (1, 2, and 3)");
        input_1 = 1; input_2 = 1; input_3 = 1; input_4 = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: All four inputs HIGH");
        input_1 = 1; input_2 = 1; input_3 = 1; input_4 = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Three inputs HIGH (2, 3, and 4)");
        input_1 = 0; input_2 = 1; input_3 = 1; input_4 = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Three inputs HIGH (1, 3, and 4)");
        input_1 = 1; input_2 = 0; input_3 = 1; input_4 = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Two inputs HIGH (1 and 4)");
        input_1 = 1; input_2 = 0; input_3 = 0; input_4 = 1;
        #1;

        check_outputs(0);
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
        input expected_output_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal)) begin
                $display("PASS");
                $display("  Outputs: output_signal=%b",
                         output_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal=%b",
                         expected_output_signal);
                $display("  Got:      output_signal=%b",
                         output_signal);
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
