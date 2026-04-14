`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg d;
    reg [3:0] deadtime;
    reg [3:0] hightime;
    reg reset;
    wire gate_closed;
    wire pulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .d(d),
        .deadtime(deadtime),
        .hightime(hightime),
        .reset(reset),
        .gate_closed(gate_closed),
        .pulse(pulse)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        reset = 1;
        d = 0;
        hightime = 4'd0;
        deadtime = 4'd0;
        #15;
        reset = 0;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        hightime = 4'd4;
        deadtime = 4'd2;
        @(posedge CLK);
        #1 d = 1;
        @(posedge CLK);
        #1 d = 0;
        #2;
        $display("Testcase 001: Checking pulse start...");
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        hightime = 4'd5;
        deadtime = 4'd2;
        @(posedge CLK);
        #1 d = 1;
        @(posedge CLK);
        #1 d = 0;
        repeat(3) @(posedge CLK);
        #2;
        $display("Testcase 002: Checking mid-pulse duration...");
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        hightime = 4'd2;
        deadtime = 4'd3;
        @(posedge CLK);
        #1 d = 1;
        @(posedge CLK);
        #1 d = 0;
        repeat(2) @(posedge CLK);
        #2;
        $display("Testcase 003: Checking deadtime phase...");
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        hightime = 4'd2;
        deadtime = 4'd2;
        @(posedge CLK);
        #1 d = 1;
        @(posedge CLK);
        #1 d = 0;
        repeat(4) @(posedge CLK);
        #2;
        $display("Testcase 004: Checking return to idle...");
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        hightime = 4'd8;
        deadtime = 4'd8;
        @(posedge CLK);
        #1 d = 1;
        @(posedge CLK);
        #1 d = 0;
        repeat(2) @(posedge CLK);
        #5 reset = 1;
        #2;
        $display("Testcase 005: Checking asynchronous reset...");
        #1;

        check_outputs(1'b0, 1'b0);
        #5 reset = 0;
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        hightime = 4'd3;
        deadtime = 4'd3;
        @(posedge CLK);
        #1 d = 1;
        @(posedge CLK);
        #1 d = 0;
        repeat(2) @(posedge CLK);
        #1 d = 1;
        @(posedge CLK);
        #1 d = 0;
        repeat(6) @(posedge CLK);
        #2;
        $display("Testcase 006: Checking re-triggering immunity...");

        #1;


        check_outputs(1'b0, 1'b0);
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
        input expected_gate_closed;
        input expected_pulse;
        begin
            if (expected_gate_closed === (expected_gate_closed ^ gate_closed ^ expected_gate_closed) &&
                expected_pulse === (expected_pulse ^ pulse ^ expected_pulse)) begin
                $display("PASS");
                $display("  Outputs: gate_closed=%b, pulse=%b",
                         gate_closed, pulse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gate_closed=%b, pulse=%b",
                         expected_gate_closed, expected_pulse);
                $display("  Got:      gate_closed=%b, pulse=%b",
                         gate_closed, pulse);
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
        $dumpvars(0,CLK, d, deadtime, hightime, reset, gate_closed, pulse);
    end

endmodule
