`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire q1;
    wire q2;
    wire q3;
    wire q4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .q1(q1),
        .q2(q2),
        .q3(q3),
        .q4(q4)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial check of outputs", test_num);

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Check stability after short delay", test_num);
            #10;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Check stability after long delay", test_num);
            #100;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Final sanity check", test_num);
            #500;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
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
        input expected_q1;
        input expected_q2;
        input expected_q3;
        input expected_q4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q1 === (expected_q1 ^ q1 ^ expected_q1) &&
                expected_q2 === (expected_q2 ^ q2 ^ expected_q2) &&
                expected_q3 === (expected_q3 ^ q3 ^ expected_q3) &&
                expected_q4 === (expected_q4 ^ q4 ^ expected_q4)) begin
                $display("PASS");
                $display("  Outputs: q1=%b, q2=%b, q3=%b, q4=%b",
                         q1, q2, q3, q4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q1=%b, q2=%b, q3=%b, q4=%b",
                         expected_q1, expected_q2, expected_q3, expected_q4);
                $display("  Got:      q1=%b, q2=%b, q3=%b, q4=%b",
                         q1, q2, q3, q4);
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
