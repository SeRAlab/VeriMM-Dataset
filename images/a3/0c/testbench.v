`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg input_1;
    reg input_2;
    wire nand_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_1(input_1),
        .input_2(input_2),
        .nand_result(nand_result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: input_1=0, input_2=0", test_num);
        input_1 = 1'b0;
        input_2 = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: input_1=0, input_2=1", test_num);
        input_1 = 1'b0;
        input_2 = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: input_1=1, input_2=0", test_num);
        input_1 = 1'b1;
        input_2 = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: input_1=1, input_2=1", test_num);
        input_1 = 1'b1;
        input_2 = 1'b1;
        #1;

        check_outputs(1'b0);
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
        input expected_nand_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_nand_result === (expected_nand_result ^ nand_result ^ expected_nand_result)) begin
                $display("PASS");
                $display("  Outputs: nand_result=%b",
                         nand_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nand_result=%b",
                         expected_nand_result);
                $display("  Got:      nand_result=%b",
                         nand_result);
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
