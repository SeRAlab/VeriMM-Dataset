`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [6:0] gain;
    reg [15:0] mixerIn;
    reg [1:0] oflowMode;
    wire [15:0] dout;
    wire overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .gain(gain),
        .mixerIn(mixerIn),
        .oflowMode(oflowMode),
        .dout(dout),
        .overflow(overflow)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        mixerIn = 16'sd0;
        gain = 7'sd0;
        oflowMode = 2'b00;
        repeat(2) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Testcase 001: Normal multiplication (100 * 5)");
        mixerIn = 16'sd100;
        gain = 7'sd5;
        oflowMode = 2'b00;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(16'sd500, 1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Testcase 002: Normal multiplication (-100 * 5)");
        mixerIn = -16'sd100;
        gain = 7'sd5;
        oflowMode = 2'b00;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(-16'sd500, 1'b0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Testcase 003: Positive Overflow - Saturation Mode (1000 * 40)");
        mixerIn = 16'sd1000;
        gain = 7'sd40;
        oflowMode = 2'b10;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(16'sd32767, 1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Testcase 004: Negative Overflow - Saturation Mode (-1000 * 40)");
        mixerIn = -16'sd1000;
        gain = 7'sd40;
        oflowMode = 2'b10;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(-16'sd32768, 1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Testcase 005: Positive Overflow - Zero Mode (1000 * 50)");
        mixerIn = 16'sd1000;
        gain = 7'sd50;
        oflowMode = 2'b01;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(16'sd0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        $display("Testcase 006: Positive Overflow - Portion/Wrap Mode (1000 * 40)");
        mixerIn = 16'sd1000;
        gain = 7'sd40;
        oflowMode = 2'b00;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(-16'sd25536, 1'b1);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        $display("Testcase 007: Multiply by Zero");
        mixerIn = 16'sd32767;
        gain = 7'sd0;
        oflowMode = 2'b00;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(16'sd0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        $display("Testcase 008: Boundary Max Positive (32767 * 1)");
        mixerIn = 16'sd32767;
        gain = 7'sd1;
        oflowMode = 2'b10;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(16'sd32767, 1'b0);
    end
        endtask

    task testcase009;

    begin
        reset_dut();
        $display("Testcase 009: Boundary Max Negative (-32768 * 1)");
        mixerIn = -16'sd32768;
        gain = 7'sd1;
        oflowMode = 2'b10;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(-16'sd32768, 1'b0);
    end
        endtask

    task testcase010;

    begin
        reset_dut();
        $display("Testcase 010: Negative Gain (100 * -10)");
        mixerIn = 16'sd100;
        gain = -7'sd10;
        oflowMode = 2'b00;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(-16'sd1000, 1'b0);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [15:0] expected_dout;
        input expected_overflow;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, overflow=%b",
                         dout, overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, overflow=%b",
                         expected_dout, expected_overflow);
                $display("  Got:      dout=%h, overflow=%b",
                         dout, overflow);
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
        $dumpvars(0,clk, gain, mixerIn, oflowMode, dout, overflow);
    end

endmodule
