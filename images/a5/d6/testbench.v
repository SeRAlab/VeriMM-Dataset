`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CK;
    reg D;
    reg SET;
    wire Q;
    wire QN;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CK(CK),
        .D(D),
        .SET(SET),
        .Q(Q),
        .QN(QN)
    );

    // Clock generation (10ns period)
    initial begin
        CK = 0;
        forever #5 CK = ~CK;
    end

        task reset_dut;

    begin
        SET = 1;
        D = 0;
        #12;
        SET = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Asynchronous SET");
        reset_dut();

        SET = 1;
        #2;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Synchronous capture D=0");
        reset_dut();
        @(negedge CK);
        D = 0;
        SET = 0;
        @(posedge CK);
        #2;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Synchronous capture D=1");
        reset_dut();

        @(negedge CK);
        D = 0;
        @(posedge CK);
        #2;

        @(negedge CK);
        D = 1;
        @(posedge CK);
        #2;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: SET override during Clock Edge");
        reset_dut();
        @(negedge CK);
        D = 0;
        SET = 1;
        @(posedge CK);
        #2;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Data stability without clock edge");
        reset_dut();
        @(negedge CK);
        D = 0;
        #2;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Asynchronous SET mid-clock cycle");
        reset_dut();
        @(negedge CK);
        D = 0;
        @(posedge CK);
        #2;
        #3;
        SET = 1;
        #1;
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
        $dumpvars(0,CK, D, SET, Q, QN);
    end

endmodule
