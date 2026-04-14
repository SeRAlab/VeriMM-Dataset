`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg R;
    reg S;
    wire Q;
    wire Qbar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .R(R),
        .S(S),
        .Q(Q),
        .Qbar(Qbar)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Checking Reset state (R=1, S=0)");

        R = 1; S = 0;
        #5;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Checking Set state (R=0, S=1)");

        R = 1; S = 0;
        #5;

        R = 0; S = 1;
        #5;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Checking Hold state after Set (R=0, S=0)");

        R = 1; S = 0;
        #5;

        R = 0; S = 1;
        #5;

        R = 0; S = 0;
        #5;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Checking Hold state after Reset (R=0, S=0)");

        R = 1; S = 0;
        #5;

        R = 0; S = 0;
        #5;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Checking Invalid/Both High state (R=1, S=1)");

        R = 1; S = 0;
        #5;

        R = 1; S = 1;
        #5;

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Transition from Both High to Set");

        R = 1; S = 0;
        #5;

        R = 1; S = 1;
        #5;

        R = 0; S = 1;
        #5;
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
        input expected_Q;
        input expected_Qbar;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Qbar === (expected_Qbar ^ Qbar ^ expected_Qbar)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Qbar=%b",
                         Q, Qbar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Qbar=%b",
                         expected_Q, expected_Qbar);
                $display("  Got:      Q=%b, Qbar=%b",
                         Q, Qbar);
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
