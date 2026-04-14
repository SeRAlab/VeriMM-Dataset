`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg i_inverse;
    reg i_valid;
    wire o_valid0;
    wire o_valid1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_inverse(i_inverse),
        .i_valid(i_valid),
        .o_valid0(o_valid0),
        .o_valid1(o_valid1)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: i_inverse=1, i_valid=1", test_num);
            i_inverse = 1'b1;
            i_valid = 1'b1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: i_inverse=1, i_valid=0", test_num);
            i_inverse = 1'b1;
            i_valid = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: i_inverse=0, i_valid=1", test_num);
            i_inverse = 1'b0;
            i_valid = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: i_inverse=0, i_valid=0", test_num);
            i_inverse = 1'b0;
            i_valid = 1'b0;
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
        input expected_o_valid0;
        input expected_o_valid1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_valid0 === (expected_o_valid0 ^ o_valid0 ^ expected_o_valid0) &&
                expected_o_valid1 === (expected_o_valid1 ^ o_valid1 ^ expected_o_valid1)) begin
                $display("PASS");
                $display("  Outputs: o_valid0=%b, o_valid1=%b",
                         o_valid0, o_valid1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_valid0=%b, o_valid1=%b",
                         expected_o_valid0, expected_o_valid1);
                $display("  Got:      o_valid0=%b, o_valid1=%b",
                         o_valid0, o_valid1);
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
