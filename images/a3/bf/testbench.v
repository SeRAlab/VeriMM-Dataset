`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire [9:0] result1;
    wire [9:0] result2;
    wire [9:0] result3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .result1(result1),
        .result2(result2),
        .result3(result3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Initial Output Check", test_num);





            #1;






            check_outputs(10'd0, 10'd1, 10'd2);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Stability Check", test_num);

            #10;
            #1;

            check_outputs(10'd0, 10'd1, 10'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Final Verification", test_num);

            #5;
            #1;

            check_outputs(10'd0, 10'd1, 10'd2);
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
        input [9:0] expected_result1;
        input [9:0] expected_result2;
        input [9:0] expected_result3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result1 === (expected_result1 ^ result1 ^ expected_result1) &&
                expected_result2 === (expected_result2 ^ result2 ^ expected_result2) &&
                expected_result3 === (expected_result3 ^ result3 ^ expected_result3)) begin
                $display("PASS");
                $display("  Outputs: result1=%h, result2=%h, result3=%h",
                         result1, result2, result3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result1=%h, result2=%h, result3=%h",
                         expected_result1, expected_result2, expected_result3);
                $display("  Got:      result1=%h, result2=%h, result3=%h",
                         result1, result2, result3);
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
