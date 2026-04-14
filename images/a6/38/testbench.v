`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg IN1;
    reg IN2;
    reg IN3;
    reg IN4;
    reg S0;
    reg S1;
    reg VDD;
    reg VSS;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IN1(IN1),
        .IN2(IN2),
        .IN3(IN3),
        .IN4(IN4),
        .S0(S0),
        .S1(S1),
        .VDD(VDD),
        .VSS(VSS),
        .Q(Q)
    );
    task testcase001;

    begin
        $display("Test Case 001: Select IN1 (S1=0, S0=0), IN1=0");
        test_num = 1;
        VDD = 1; VSS = 0;
        S1 = 0; S0 = 0;
        IN1 = 0; IN2 = 1; IN3 = 1; IN4 = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Select IN1 (S1=0, S0=0), IN1=1");
        test_num = 2;
        VDD = 1; VSS = 0;
        S1 = 0; S0 = 0;
        IN1 = 1; IN2 = 0; IN3 = 0; IN4 = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Select IN2 (S1=1, S0=0), IN2=0");
        test_num = 3;
        VDD = 1; VSS = 0;
        S1 = 1; S0 = 0;
        IN1 = 1; IN2 = 0; IN3 = 1; IN4 = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Select IN2 (S1=1, S0=0), IN2=1");
        test_num = 4;
        VDD = 1; VSS = 0;
        S1 = 1; S0 = 0;
        IN1 = 0; IN2 = 1; IN3 = 0; IN4 = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Select IN3 (S1=0, S0=1), IN3=0");
        test_num = 5;
        VDD = 1; VSS = 0;
        S1 = 0; S0 = 1;
        IN1 = 1; IN2 = 1; IN3 = 0; IN4 = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Select IN3 (S1=0, S0=1), IN3=1");
        test_num = 6;
        VDD = 1; VSS = 0;
        S1 = 0; S0 = 1;
        IN1 = 0; IN2 = 0; IN3 = 1; IN4 = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: Select IN4 (S1=1, S0=1), IN4=0");
        test_num = 7;
        VDD = 1; VSS = 0;
        S1 = 1; S0 = 1;
        IN1 = 1; IN2 = 1; IN3 = 1; IN4 = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: Select IN4 (S1=1, S0=1), IN4=1");
        test_num = 8;
        VDD = 1; VSS = 0;
        S1 = 1; S0 = 1;
        IN1 = 0; IN2 = 0; IN3 = 0; IN4 = 1;
        #1;

        check_outputs(1);
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
        input expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
                         Q);
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
