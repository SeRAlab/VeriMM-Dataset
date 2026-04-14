`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg G;
    wire Q;
    wire QN;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .G(G),
        .Q(Q),
        .QN(QN)
    );

    // Clock generation (10ns period)
    initial begin
        G = 0;
        forever #5 G = ~G;
    end

        task reset_dut;

    begin
        G = 0;
        D = 4'b0000;
        #10;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        D = 4'b1010;
        #5;
        $display("Testcase 001: Checking Reset State (G=0)");
        #1;

        check_outputs(4'b0000, 4'b1111);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        G = 1;
        D = 4'b1010;
        #5;
        $display("Testcase 002: Checking Transparent Mode (D=1010, G=1)");
        #1;

        check_outputs(4'b1010, 4'b0101);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        G = 1;
        D = 4'b0101;
        #5;
        $display("Testcase 003: Checking Transparent Mode (D=0101, G=1)");
        #1;

        check_outputs(4'b0101, 4'b1010);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        G = 1;
        D = 4'b1111;
        #5;
        $display("Testcase 004: Checking All Bits High (D=1111, G=1)");
        #1;

        check_outputs(4'b1111, 4'b0000);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        G = 1;
        D = 4'b1100;
        #5;
        G = 0;
        #5;
        $display("Testcase 005: Checking Transition from G=1 to G=0 (Clear)");
        #1;

        check_outputs(4'b0000, 4'b1111);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        G = 0;
        D = 4'b1111;
        #5;
        D = 4'b0011;
        #5;
        $display("Testcase 006: Checking Data Change while Cleared (G=0)");
        #1;

        check_outputs(4'b0000, 4'b1111);
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
        input expected_QN;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_QN === (expected_QN ^ QN ^ expected_QN)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, QN=%b",
                         Q, QN);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, QN=%b",
                         expected_Q, expected_QN);
                $display("  Got:      Q=%b, QN=%b",
                         Q, QN);
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
        $dumpvars(0,D, G, Q, QN);
    end

endmodule
