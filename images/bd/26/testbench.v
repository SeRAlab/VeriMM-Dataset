`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] A;
    wire B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B)
    );
    task testcase001;

    begin
        $display("Test Case 001: Input A = 0");
        A = 6'b000000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Input A = 63 (All bits set)");
        A = 6'b111111;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Input A = 42 (Alternating bits 101010)");
        A = 6'b101010;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Input A = 21 (Alternating bits 010101)");
        A = 6'b010101;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Input A = 32 (Single bit set)");
        A = 6'b100000;
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
        input expected_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_B === (expected_B ^ B ^ expected_B)) begin
                $display("PASS");
                $display("  Outputs: B=%b",
                         B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B=%b",
                         expected_B);
                $display("  Got:      B=%b",
                         B);
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
