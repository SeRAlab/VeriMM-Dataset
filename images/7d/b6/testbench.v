`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    reg PRESET;
    reg RESET;
    wire Q;
    wire Q_BAR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .PRESET(PRESET),
        .RESET(RESET),
        .Q(Q),
        .Q_BAR(Q_BAR)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RESET = 1;
        PRESET = 0;
        D = 0;
        #12;
        RESET = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Asynchronous Reset");
        reset_dut();

        D = 1;
        @(posedge CLK);
        #2;

        RESET = 1;
        #2;
        #1;

        check_outputs(1'b0, 1'b1);
        RESET = 0;
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Asynchronous Preset");
        reset_dut();

        D = 0;
        @(posedge CLK);
        #2;

        PRESET = 1;
        #2;
        #1;

        check_outputs(1'b1, 1'b0);
        PRESET = 0;
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Clocked capture D=1");
        reset_dut();
        D = 1;
        PRESET = 0;
        RESET = 0;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Clocked capture D=0");
        reset_dut();

        D = 1;
        @(posedge CLK);
        #2;

        D = 0;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Reset priority over D capture");
        reset_dut();
        D = 1;
        RESET = 1;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(1'b0, 1'b1);
        RESET = 0;
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Preset priority over D capture");
        reset_dut();
        D = 0;
        PRESET = 1;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(1'b1, 1'b0);
        PRESET = 0;
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
        input expected_Q_BAR;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Q_BAR === (expected_Q_BAR ^ Q_BAR ^ expected_Q_BAR)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Q_BAR=%b",
                         Q, Q_BAR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Q_BAR=%b",
                         expected_Q, expected_Q_BAR);
                $display("  Got:      Q=%b, Q_BAR=%b",
                         Q, Q_BAR);
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
        $dumpvars(0,CLK, D, PRESET, RESET, Q, Q_BAR);
    end

endmodule
