`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg S;
    wire [6:0] H;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .S(S),
        .H(H)
    );
    task testcase001;

        begin
            test_num = 1;


            S = 1'b0;
            #10;
            #1;

            check_outputs(7'b0000110);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;

            S = 1'b1;
            #10;
            #1;

            check_outputs(7'b0000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;

            S = 1'b0;
            #10;
            #1;

            check_outputs(7'b0000110);
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
        input [6:0] expected_H;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_H === (expected_H ^ H ^ expected_H)) begin
                $display("PASS");
                $display("  Outputs: H=%h",
                         H);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: H=%h",
                         expected_H);
                $display("  Got:      H=%h",
                         H);
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
