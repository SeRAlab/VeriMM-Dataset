`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg IncB;
    reg Reset;
    reg clock;
    wire [1:0] AddrB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IncB(IncB),
        .Reset(Reset),
        .clock(clock),
        .AddrB(AddrB)
    );

    // Clock generation (10ns period)
    initial begin
        IncB = 0;
        forever #5 IncB = ~IncB;
    end

        task reset_dut;

    begin
        Reset = 1;
        @(negedge IncB);
        Reset = 1;
        @(negedge IncB);
        Reset = 0;
        @(negedge IncB);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase 001: Reset Check...");
        reset_dut();
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase 002: Increment to 1...");
        reset_dut();
        @(posedge IncB);
        #2;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase 003: Increment to 2...");
        reset_dut();
        repeat(2) @(posedge IncB);
        #2;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase 004: Increment to 3...");
        reset_dut();
        repeat(3) @(posedge IncB);
        #2;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase 005: Wrap-around Check (4 pulses)...");
        reset_dut();
        repeat(4) @(posedge IncB);
        #2;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running Testcase 006: Wrap-around Check (5 pulses)...");
        reset_dut();
        repeat(5) @(posedge IncB);
        #2;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Running Testcase 007: Mid-operation Reset...");
        reset_dut();
        repeat(2) @(posedge IncB);
        Reset = 1;
        @(posedge IncB);
        #2;
        #1;

        check_outputs(2'b00);
        Reset = 0;
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
        input [1:0] expected_AddrB;
        begin
            if (expected_AddrB === (expected_AddrB ^ AddrB ^ expected_AddrB)) begin
                $display("PASS");
                $display("  Outputs: AddrB=%h",
                         AddrB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AddrB=%h",
                         expected_AddrB);
                $display("  Got:      AddrB=%h",
                         AddrB);
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
        $dumpvars(0,IncB, Reset, clock, AddrB);
    end

endmodule
