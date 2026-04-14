`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg C;
    reg D;
    reg R;
    reg S;
    wire RF;
    wire RI;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .C(C),
        .D(D),
        .R(R),
        .S(S),
        .RF(RF),
        .RI(RI)
    );

    // Clock generation (10ns period)
    initial begin
        C = 0;
        forever #5 C = ~C;
    end

        task reset_dut;

        begin
            R = 0;
            S = 1;
            D = 0;
            @(posedge C);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Reset (R=0, S=1)");

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Set (S=0) with D=1");
            R = 1;
            S = 0;
            D = 1;
            @(posedge C);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Set (S=0) with D=0");
            R = 1;
            S = 0;
            D = 0;
            @(posedge C);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Hold logic (R=1, S=1) maintaining HIGH");

            R = 1; S = 0; D = 1;
            @(posedge C);
            #1;

            S = 1; D = 0;
            @(posedge C);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Hold logic (R=1, S=1) maintaining LOW");

            R = 1; S = 1; D = 1;
            @(posedge C);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Reset Priority (R=0, S=0, D=1)");
            R = 0;
            S = 0;
            D = 1;
            @(posedge C);
            #1;

            #1;


            check_outputs(1'b0, 1'b1);
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
        input expected_RF;
        input expected_RI;
        begin
            if (expected_RF === (expected_RF ^ RF ^ expected_RF) &&
                expected_RI === (expected_RI ^ RI ^ expected_RI)) begin
                $display("PASS");
                $display("  Outputs: RF=%b, RI=%b",
                         RF, RI);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RF=%b, RI=%b",
                         expected_RF, expected_RI);
                $display("  Got:      RF=%b, RI=%b",
                         RF, RI);
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
        $dumpvars(0,C, D, R, S, RF, RI);
    end

endmodule
