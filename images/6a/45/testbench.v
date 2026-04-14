`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg A2;
    reg B1;
    reg B2;
    reg C1;
    wire [1:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1(A1),
        .A2(A2),
        .B1(B1),
        .B2(B2),
        .C1(C1),
        .Z(Z)
    );
    task testcase001;

        begin
            $display("Testcase 001: All inputs zero (Expected Y=1)");
            A1 = 0; A2 = 0; B1 = 0; B2 = 0; C1 = 0;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: A branch active (A1=1, A2=1 -> Expected Y=0)");
            A1 = 1; A2 = 1; B1 = 0; B2 = 0; C1 = 0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: B branch active (B1=1, B2=1 -> Expected Y=0)");
            A1 = 0; A2 = 0; B1 = 1; B2 = 1; C1 = 0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: C branch active (C1=1 -> Expected Y=0)");
            A1 = 0; A2 = 0; B1 = 0; B2 = 0; C1 = 1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Partial branches (A1=1, B1=1 -> Expected Y=1)");
            A1 = 1; A2 = 0; B1 = 1; B2 = 0; C1 = 0;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Multiple branches active (Expected Y=0)");
            A1 = 1; A2 = 1; B1 = 0; B2 = 0; C1 = 1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Single bit from AND branch (A2 only -> Expected Y=1)");
            A1 = 0; A2 = 1; B1 = 0; B2 = 0; C1 = 0;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: All inputs active (Expected Y=0)");
            A1 = 1; A2 = 1; B1 = 1; B2 = 1; C1 = 1;
            #1;

            check_outputs(2'b00);
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
        input [1:0] expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
