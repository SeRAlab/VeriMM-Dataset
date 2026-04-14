`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CE;
    reg CLK;
    reg CLR;
    wire Semnal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CE(CE),
        .CLK(CLK),
        .CLR(CLR),
        .Semnal(Semnal)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        CE = 0;
        CLR = 1;
        @(posedge CLK);
        #1;
        CLR = 0;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running Testcase 001: Reach count 11 from reset");
        reset_dut();
        CE = 1;

        repeat (10) @(posedge CLK);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: Verify CLR behavior");
        reset_dut();
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: Verify Clock Enable (CE) functionality");
        reset_dut();
        CE = 0;
        repeat (20) @(posedge CLK);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: Gated counting with CE");
        reset_dut();
        CE = 1;
        repeat (5) @(posedge CLK);
        CE = 0;
        repeat (5) @(posedge CLK);
        CE = 1;
        repeat (5) @(posedge CLK);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Running Testcase 005: Verify rollover logic");
        reset_dut();
        CE = 1;
        repeat (10) @(posedge CLK);
        @(posedge CLK);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("Running Testcase 006: Reset while Semnal is high");
        reset_dut();
        CE = 1;
        repeat (10) @(posedge CLK);
        CLR = 1;
        @(posedge CLK);
        #2;
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
        input expected_Semnal;
        begin
            if (expected_Semnal === (expected_Semnal ^ Semnal ^ expected_Semnal)) begin
                $display("PASS");
                $display("  Outputs: Semnal=%b",
                         Semnal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Semnal=%b",
                         expected_Semnal);
                $display("  Got:      Semnal=%b",
                         Semnal);
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
        $dumpvars(0,CE, CLK, CLR, Semnal);
    end

endmodule
