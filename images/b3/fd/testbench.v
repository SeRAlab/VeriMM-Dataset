`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] inputbin;
    wire [6:0] displayout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inputbin(inputbin),
        .displayout(displayout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Testing Input 0 (Zero)");
            inputbin = 4'd0;
            #1;

            check_outputs(7'b1111110);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Testing Input 4 (Decimal 4)");
            inputbin = 4'd4;
            #1;

            check_outputs(7'b0110011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Testing Input 9 (Decimal 9)");
            inputbin = 4'd9;
            #1;

            check_outputs(7'b1111011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Testing Input 10 (Hex A)");
            inputbin = 4'd10;
            #1;

            check_outputs(7'b1110111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Testing Input 15 (Hex F)");
            inputbin = 4'd15;
            #1;

            check_outputs(7'b1000111);
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
        input [6:0] expected_displayout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_displayout === (expected_displayout ^ displayout ^ expected_displayout)) begin
                $display("PASS");
                $display("  Outputs: displayout=%h",
                         displayout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: displayout=%h",
                         expected_displayout);
                $display("  Got:      displayout=%h",
                         displayout);
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
