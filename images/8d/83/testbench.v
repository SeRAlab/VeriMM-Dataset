`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    reg Reset;
    reg Set;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .Reset(Reset),
        .Set(Set),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        Reset = 0;
        Set = 1;
        D = 0;
        #12;
        Reset = 1;
        #5;
    end
        endtask
    task testcase001;

    begin
        reset_dut();

        D = 1;
        @(posedge CLK);
        #2;

        Reset = 0;
        #2;
        $display("Testcase 001: Asynchronous Reset");
        #1;

        check_outputs(0);
        Reset = 1;
    end
        endtask

    task testcase002;

    begin
        reset_dut();

        Set = 0;
        #2;
        $display("Testcase 002: Asynchronous Set");
        #1;

        check_outputs(1);
        Set = 1;
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        D = 1;
        Reset = 1;
        Set = 1;
        @(posedge CLK);
        #2;
        $display("Testcase 003: Capture D=1 on Rising Edge");
        #1;

        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();

        D = 1; @(posedge CLK); #2;

        D = 0;
        @(posedge CLK);
        #2;
        $display("Testcase 004: Capture D=0 on Rising Edge");
        #1;

        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();

        Reset = 0;
        Set = 0;
        #5;
        $display("Testcase 005: Reset Priority over Set");
        #1;

        check_outputs(0);
        Reset = 1;
        Set = 1;
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        Reset = 1;
        Set = 1;
        D = 1;
        #2;
        $display("Testcase 006: D changes, no clock edge");
        #1;

        check_outputs(0);
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
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,CLK, D, Reset, Set, Q);
    end

endmodule
