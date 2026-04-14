`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg cascade;
    reg clk;
    reg countDown;
    reg reset;
    reg resetButton;
    reg start;
    reg stop;
    wire blink;
    wire enable;
    wire resetCount;
    wire up;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cascade(cascade),
        .clk(clk),
        .countDown(countDown),
        .reset(reset),
        .resetButton(resetButton),
        .start(start),
        .stop(stop),
        .blink(blink),
        .enable(enable),
        .resetCount(resetCount),
        .up(up)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        cascade = 0;
        countDown = 0;
        resetButton = 0;
        start = 0;
        stop = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Check IDLE state after reset", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Transition STOPPED -> COUNTING", test_num);
        reset_dut();
        start = 1;
        @(posedge clk);
        #1;
        start = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Transition COUNTING -> STOPPED", test_num);
        reset_dut();

        start = 1;
        @(posedge clk);
        #1 start = 0;
        @(posedge clk);

        #1 stop = 1;
        @(posedge clk);
        #1 stop = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Transition COUNTING -> BLINK", test_num);
        reset_dut();

        start = 1;
        @(posedge clk);
        #1 start = 0;
        @(posedge clk);

        #1 cascade = 1;
        @(posedge clk);
        #1 cascade = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Test resetButton functionality", test_num);
        reset_dut();
        resetButton = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: COUNTING state with countDown active", test_num);
        reset_dut();
        countDown = 1;
        start = 1;
        @(posedge clk);
        #1 start = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 1'b0);
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
        input expected_blink;
        input expected_enable;
        input expected_resetCount;
        input expected_up;
        begin
            if (expected_blink === (expected_blink ^ blink ^ expected_blink) &&
                expected_enable === (expected_enable ^ enable ^ expected_enable) &&
                expected_resetCount === (expected_resetCount ^ resetCount ^ expected_resetCount) &&
                expected_up === (expected_up ^ up ^ expected_up)) begin
                $display("PASS");
                $display("  Outputs: blink=%b, enable=%b, resetCount=%b, up=%b",
                         blink, enable, resetCount, up);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: blink=%b, enable=%b, resetCount=%b, up=%b",
                         expected_blink, expected_enable, expected_resetCount, expected_up);
                $display("  Got:      blink=%b, enable=%b, resetCount=%b, up=%b",
                         blink, enable, resetCount, up);
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
        $dumpvars(0,cascade, clk, countDown, reset, resetButton, start, stop, blink, enable, resetCount, up);
    end

endmodule
