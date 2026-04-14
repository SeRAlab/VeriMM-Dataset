`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg IN1;
    reg IN2;
    reg IN3;
    reg IN4;
    wire QN;

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
        .QN(QN)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: All inputs LOW (Expected: QN=1)");
        IN1 = 0; IN2 = 0; IN3 = 0; IN4 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: IN1 HIGH (Expected: QN=0)");
        IN1 = 1; IN2 = 0; IN3 = 0; IN4 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: IN2 HIGH (Expected: QN=0)");
        IN1 = 0; IN2 = 1; IN3 = 0; IN4 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: IN3 HIGH (Expected: QN=0)");
        IN1 = 0; IN2 = 0; IN3 = 1; IN4 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: IN4 HIGH (Expected: QN=0)");
        IN1 = 0; IN2 = 0; IN3 = 0; IN4 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Multiple inputs HIGH (IN1, IN2) (Expected: QN=0)");
        IN1 = 1; IN2 = 1; IN3 = 0; IN4 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Multiple inputs HIGH (IN3, IN4) (Expected: QN=0)");
        IN1 = 0; IN2 = 0; IN3 = 1; IN4 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: All inputs HIGH (Expected: QN=0)");
        IN1 = 1; IN2 = 1; IN3 = 1; IN4 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: Mixed inputs (IN1, IN3 HIGH) (Expected: QN=0)");
        IN1 = 1; IN2 = 0; IN3 = 1; IN4 = 0;
        #1;

        check_outputs(1'b0);
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
        testcase009();
        
        
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
        input expected_QN;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_QN === (expected_QN ^ QN ^ expected_QN)) begin
                $display("PASS");
                $display("  Outputs: QN=%b",
                         QN);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: QN=%b",
                         expected_QN);
                $display("  Got:      QN=%b",
                         QN);
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
