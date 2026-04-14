`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg r;
    reg [2:0] u;
    wire U2;
    wire U3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .r(r),
        .u(u),
        .U2(U2),
        .U3(U3)
    );
    task testcase001;

    begin
        u = 3'b001;
        r = 1'b1;
        $display("Executing Testcase 001: State X, r=1 -> Expecting U2=1, U3=0 (Transition to Y)");
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        u = 3'b001;
        r = 1'b0;
        $display("Executing Testcase 002: State X, r=0 -> Expecting U2=0, U3=1 (Transition to Z)");
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        u = 3'b010;
        r = 1'b1;
        $display("Executing Testcase 003: State Y, r=1 -> Expecting U2=0, U3=1 (Transition to Z)");
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        u = 3'b010;
        r = 1'b0;
        $display("Executing Testcase 004: State Y, r=0 -> Expecting U2=0, U3=0 (Transition to X)");
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        u = 3'b100;
        r = 1'b1;
        $display("Executing Testcase 005: State Z, r=1 -> Expecting U2=0, U3=0 (Transition to X)");
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        u = 3'b100;
        r = 1'b0;
        $display("Executing Testcase 006: State Z, r=0 -> Expecting U2=1, U3=0 (Transition to Y)");
        #1;

        check_outputs(1'b1, 1'b0);
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
        input expected_U2;
        input expected_U3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_U2 === (expected_U2 ^ U2 ^ expected_U2) &&
                expected_U3 === (expected_U3 ^ U3 ^ expected_U3)) begin
                $display("PASS");
                $display("  Outputs: U2=%b, U3=%b",
                         U2, U3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: U2=%b, U3=%b",
                         expected_U2, expected_U3);
                $display("  Got:      U2=%b, U3=%b",
                         U2, U3);
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
