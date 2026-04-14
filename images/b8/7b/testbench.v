`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg FADE_TIMER_TICK;
    reg LED_FULL_ON;
    reg [6:0] PWM_CHANNEL_SIGS;
    reg PWM_TIMER_TICK;
    wire LEDR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .FADE_TIMER_TICK(FADE_TIMER_TICK),
        .LED_FULL_ON(LED_FULL_ON),
        .PWM_CHANNEL_SIGS(PWM_CHANNEL_SIGS),
        .PWM_TIMER_TICK(PWM_TIMER_TICK),
        .LEDR(LEDR)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        LED_FULL_ON = 0;
        PWM_CHANNEL_SIGS = 7'b0000000;
        PWM_TIMER_TICK = 0;
        FADE_TIMER_TICK = 0;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %03d: LED_FULL_ON sets brightness to max", test_num);
        LED_FULL_ON = 1;
        PWM_CHANNEL_SIGS = 7'b1000000;
        PWM_TIMER_TICK = 1;
        repeat (2) @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %03d: Fade 1 step (Level 7 -> 6)", test_num);
        LED_FULL_ON = 1;
        @(posedge CLK);
        #1;
        LED_FULL_ON = 0;
        FADE_TIMER_TICK = 1;
        @(posedge CLK);
        #1;
        FADE_TIMER_TICK = 0;
        PWM_CHANNEL_SIGS = 7'b0100000;
        PWM_TIMER_TICK = 1;
        repeat (2) @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    integer i;
    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %03d: Fade to level 1", test_num);
        LED_FULL_ON = 1;
        @(posedge CLK);
        #1;
        LED_FULL_ON = 0;
        FADE_TIMER_TICK = 1;
        for (i = 0; i < 6; i = i + 1) @(posedge CLK);
        #1;
        FADE_TIMER_TICK = 0;
        PWM_CHANNEL_SIGS = 7'b0000001;
        PWM_TIMER_TICK = 1;
        repeat (2) @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    integer i;
    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %03d: Fade to Level 0 (Off)", test_num);
        LED_FULL_ON = 1;
        @(posedge CLK);
        #1;
        LED_FULL_ON = 0;
        FADE_TIMER_TICK = 1;
        for (i = 0; i < 8; i = i + 1) @(posedge CLK);
        #1;
        FADE_TIMER_TICK = 0;
        PWM_CHANNEL_SIGS = 7'b1111111;
        PWM_TIMER_TICK = 1;
        repeat (2) @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %03d: LED_FULL_ON priority over Fade", test_num);
        LED_FULL_ON = 1;
        FADE_TIMER_TICK = 1;
        PWM_CHANNEL_SIGS = 7'b1000000;
        PWM_TIMER_TICK = 1;
        repeat (5) @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %03d: PWM_TIMER_TICK update gating", test_num);

        LED_FULL_ON = 1;
        PWM_CHANNEL_SIGS = 7'b1000000;
        PWM_TIMER_TICK = 1;
        repeat (2) @(posedge CLK);
        #1;

        PWM_TIMER_TICK = 0;
        PWM_CHANNEL_SIGS = 7'b0000000;
        repeat (2) @(posedge CLK);
        #1;

        #1;


        check_outputs(1'b1);
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
        input expected_LEDR;
        begin
            if (expected_LEDR === (expected_LEDR ^ LEDR ^ expected_LEDR)) begin
                $display("PASS");
                $display("  Outputs: LEDR=%b",
                         LEDR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LEDR=%b",
                         expected_LEDR);
                $display("  Got:      LEDR=%b",
                         LEDR);
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
        $dumpvars(0,CLK, FADE_TIMER_TICK, LED_FULL_ON, PWM_CHANNEL_SIGS, PWM_TIMER_TICK, LEDR);
    end

endmodule
