`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLOCK;
    reg InputPulse;
    reg Reset;
    wire OneShot;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLOCK(CLOCK),
        .InputPulse(InputPulse),
        .Reset(Reset),
        .OneShot(OneShot)
    );

    // Clock generation (10ns period)
    initial begin
        CLOCK = 0;
        forever #5 CLOCK = ~CLOCK;
    end

        task reset_dut;

    begin
        Reset = 1;
        InputPulse = 0;
        @(negedge CLOCK);
        Reset = 0;
        @(negedge CLOCK);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase 001: Verifying pulse generation on falling edge...");
        @(negedge CLOCK) InputPulse = 1;
        @(negedge CLOCK) InputPulse = 0;
        @(posedge CLOCK);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase 002: Verifying pulse duration (low after 1 cycle)...");
        @(negedge CLOCK) InputPulse = 1;
        @(negedge CLOCK) InputPulse = 0;
        @(posedge CLOCK);
        @(posedge CLOCK);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase 003: Verifying no trigger while input is still high...");
        @(negedge CLOCK) InputPulse = 1;
        repeat(3) @(posedge CLOCK);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase 004: Verifying system recovery for a second pulse...");

        @(negedge CLOCK) InputPulse = 1;
        @(negedge CLOCK) InputPulse = 0;
        repeat(4) @(posedge CLOCK);

        @(negedge CLOCK) InputPulse = 1;
        @(negedge CLOCK) InputPulse = 0;
        @(posedge CLOCK);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase 005: Verifying Reset dominance during active pulse...");
        @(negedge CLOCK) InputPulse = 1;
        @(negedge CLOCK) InputPulse = 0;
        @(posedge CLOCK);
        #1 Reset = 1;
        #2;
        #1;

        check_outputs(1'b0);
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
        input expected_OneShot;
        begin
            if (expected_OneShot === (expected_OneShot ^ OneShot ^ expected_OneShot)) begin
                $display("PASS");
                $display("  Outputs: OneShot=%b",
                         OneShot);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OneShot=%b",
                         expected_OneShot);
                $display("  Got:      OneShot=%b",
                         OneShot);
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
        $dumpvars(0,CLOCK, InputPulse, Reset, OneShot);
    end

endmodule
