`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg Data0;
    reg Data1;
    reg Data2;
    reg Data3;
    reg Enable;
    wire Q0;
    wire Q1;
    wire Q2;
    wire Q3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clock(Clock),
        .Data0(Data0),
        .Data1(Data1),
        .Data2(Data2),
        .Data3(Data3),
        .Enable(Enable),
        .Q0(Q0),
        .Q1(Q1),
        .Q2(Q2),
        .Q3(Q3)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            Data0 = 0; Data1 = 0; Data2 = 0; Data3 = 0;
            Enable = 1;
            @(posedge Clock);
            #1;
            Enable = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Load all ones (1111)");
            reset_dut();
            test_num = 1;
            Data0 = 1; Data1 = 1; Data2 = 1; Data3 = 1;
            Enable = 1;
            @(posedge Clock);
            #2;
            #1;

            check_outputs(1, 1, 1, 1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Load pattern (1010)");
            reset_dut();
            test_num = 2;
            Data0 = 1; Data1 = 0; Data2 = 1; Data3 = 0;
            Enable = 1;
            @(posedge Clock);
            #2;
            #1;

            check_outputs(1, 0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Hold value (Enable=0)");
            reset_dut();
            test_num = 3;

            Data0 = 0; Data1 = 1; Data2 = 1; Data3 = 0;
            Enable = 1;
            @(posedge Clock);
            #2;


            Enable = 0;
            Data0 = 1; Data1 = 1; Data2 = 1; Data3 = 1;
            @(posedge Clock);
            #2;


            #1;



            check_outputs(0, 1, 1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Individual bit toggle");
            reset_dut();
            test_num = 4;
            Data0 = 0; Data1 = 0; Data2 = 1; Data3 = 0;
            Enable = 1;
            @(posedge Clock);
            #2;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Synchronous behavior check");
            reset_dut();
            test_num = 5;
            Enable = 1;
            Data0 = 1; Data1 = 1; Data2 = 0; Data3 = 0;


            #2;



            @(posedge Clock);
            #2;
            #1;

            check_outputs(1, 1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Multiple sequential updates");
            reset_dut();
            test_num = 6;
            Enable = 1;

            Data0 = 1; Data1 = 0; Data2 = 0; Data3 = 1;
            @(posedge Clock);
            #1;

            Data0 = 0; Data1 = 1; Data2 = 1; Data3 = 0;
            @(posedge Clock);
            #2;

            #1;


            check_outputs(0, 1, 1, 0);
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
        input expected_Q0;
        input expected_Q1;
        input expected_Q2;
        input expected_Q3;
        begin
            if (expected_Q0 === (expected_Q0 ^ Q0 ^ expected_Q0) &&
                expected_Q1 === (expected_Q1 ^ Q1 ^ expected_Q1) &&
                expected_Q2 === (expected_Q2 ^ Q2 ^ expected_Q2) &&
                expected_Q3 === (expected_Q3 ^ Q3 ^ expected_Q3)) begin
                $display("PASS");
                $display("  Outputs: Q0=%b, Q1=%b, Q2=%b, Q3=%b",
                         Q0, Q1, Q2, Q3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q0=%b, Q1=%b, Q2=%b, Q3=%b",
                         expected_Q0, expected_Q1, expected_Q2, expected_Q3);
                $display("  Got:      Q0=%b, Q1=%b, Q2=%b, Q3=%b",
                         Q0, Q1, Q2, Q3);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,Clock, Data0, Data1, Data2, Data3, Enable, Q0, Q1, Q2, Q3);
    end

endmodule
