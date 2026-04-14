`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] num;
    wire [2:0] lognum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .num(num),
        .lognum(lognum)
    );
    task testcase001;

    begin
        $display("Testcase 001: num = 0");
        num = 6'd0;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: num = 1");
        num = 6'd1;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: num = 3");
        num = 6'd3;
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: num = 7");
        num = 6'd7;
        #1;

        check_outputs(3'd2);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: num = 15");
        num = 6'd15;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: num = 31");
        num = 6'd31;
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: num = 63");
        num = 6'd63;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: num = 2 (Unrecognized)");
        num = 6'd2;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: num = 32 (Unrecognized)");
        num = 6'd32;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: num = 60 (Unrecognized)");
        num = 6'd60;
        #1;

        check_outputs(3'd0);
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
        testcase010();
        
        
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
        input [2:0] expected_lognum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_lognum === (expected_lognum ^ lognum ^ expected_lognum)) begin
                $display("PASS");
                $display("  Outputs: lognum=%h",
                         lognum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lognum=%h",
                         expected_lognum);
                $display("  Got:      lognum=%h",
                         lognum);
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
