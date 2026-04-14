`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg x;
    reg y;
    reg z;
    wire result_pos;
    wire result_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .z(z),
        .result_pos(result_pos),
        .result_sop(result_sop)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Binary value 0 (000)", test_num);
        x = 1'b0; y = 1'b0; z = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Binary value 1 (001)", test_num);
        x = 1'b0; y = 1'b0; z = 1'b1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Binary value 2 (010)", test_num);
        x = 1'b0; y = 1'b1; z = 1'b0;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Binary value 3 (011)", test_num);
        x = 1'b0; y = 1'b1; z = 1'b1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Binary value 4 (100)", test_num);
        x = 1'b1; y = 1'b0; z = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Binary value 5 (101)", test_num);
        x = 1'b1; y = 1'b0; z = 1'b1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Binary value 6 (110)", test_num);
        x = 1'b1; y = 1'b1; z = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
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
        input expected_result_pos;
        input expected_result_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result_pos === (expected_result_pos ^ result_pos ^ expected_result_pos) &&
                expected_result_sop === (expected_result_sop ^ result_sop ^ expected_result_sop)) begin
                $display("PASS");
                $display("  Outputs: result_pos=%b, result_sop=%b",
                         result_pos, result_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result_pos=%b, result_sop=%b",
                         expected_result_pos, expected_result_sop);
                $display("  Got:      result_pos=%b, result_sop=%b",
                         result_pos, result_sop);
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
