`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [2:0] state;
    wire [3:0] BCD0;
    wire [3:0] BCD1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .state(state),
        .BCD0(BCD0),
        .BCD1(BCD1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        state = STATE_IDLE;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        state = STATE_IDLE;
        @(posedge clk);
        #1;
        $display("Test 001: Default output in IDLE state (Expect 10)");
        #1;

        check_outputs(4'h0, 4'h1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        state = STATE_GAME;
        @(posedge clk);
        #1;
        $display("Test 002: Start GAME, first decrement (Expect 59)");
        #1;

        check_outputs(4'h9, 4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        state = STATE_GAME;
        repeat(10) @(posedge clk);
        #1;
        $display("Test 003: Countdown 10 cycles (Expect 50)");
        #1;

        check_outputs(4'h0, 4'h5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        state = STATE_GAME;
        repeat(11) @(posedge clk);
        #1;
        $display("Test 004: BCD Rollover check 50 to 49 (Expect 49)");
        #1;

        check_outputs(4'h9, 4'h4);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        state = STATE_GAME;
        repeat(5) @(posedge clk);
        state = STATE_MENU;
        repeat(5) @(posedge clk);
        #1;
        $display("Test 005: MENU state hold check (Expect 55)");
        #1;

        check_outputs(4'h5, 4'h5);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        state = STATE_GAME;
        repeat(60) @(posedge clk);
        #1;
        $display("Test 006: Countdown to zero (Expect 00)");
        #1;

        check_outputs(4'h0, 4'h0);
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
        input [3:0] expected_BCD0;
        input [3:0] expected_BCD1;
        begin
            if (expected_BCD0 === (expected_BCD0 ^ BCD0 ^ expected_BCD0) &&
                expected_BCD1 === (expected_BCD1 ^ BCD1 ^ expected_BCD1)) begin
                $display("PASS");
                $display("  Outputs: BCD0=%h, BCD1=%h",
                         BCD0, BCD1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BCD0=%h, BCD1=%h",
                         expected_BCD0, expected_BCD1);
                $display("  Got:      BCD0=%h, BCD1=%h",
                         BCD0, BCD1);
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
        $dumpvars(0,clk, rst, state, BCD0, BCD1);
    end

endmodule
