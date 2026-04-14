`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dime;
    reg nickel;
    reg quarter;
    reg rst;
    wire change;
    wire mms_dispense;
    wire reeses_dispense;
    wire skittles_dispense;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dime(dime),
        .nickel(nickel),
        .quarter(quarter),
        .rst(rst),
        .change(change),
        .mms_dispense(mms_dispense),
        .reeses_dispense(reeses_dispense),
        .skittles_dispense(skittles_dispense)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        quarter = 0;
        dime = 0;
        nickel = 0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task pulse_quarter;

    begin
        quarter = 1; @(posedge clk); #1;
        quarter = 0; @(posedge clk); #1;
    end
        endtask

    task pulse_dime;

    begin
        dime = 1; @(posedge clk); #1;
        dime = 0; @(posedge clk); #1;
    end
        endtask

    task pulse_nickel;

    begin
        nickel = 1; @(posedge clk); #1;
        nickel = 0; @(posedge clk); #1;
    end
        endtask

    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("\nTest Case %0d: 2 Quarters for Skittles", test_num);
        pulse_quarter();
        pulse_quarter();

        #1;


        check_outputs(0, 0, 0, 1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("\nTest Case %0d: 4 Quarters for Skittles then M&Ms", test_num);
        pulse_quarter();
        pulse_quarter();
        pulse_quarter();
        pulse_quarter();
        #1;

        check_outputs(0, 1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("\nTest Case %0d: Full sequence (7 Quarters) with Change", test_num);
        repeat(2) pulse_quarter();
        repeat(2) pulse_quarter();
        repeat(2) pulse_quarter();
        pulse_quarter();
        #1;

        check_outputs(1, 0, 1, 0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("\nTest Case %0d: 5 Dimes for Skittles", test_num);
        repeat(5) pulse_dime();
        #1;

        check_outputs(0, 0, 0, 1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("\nTest Case %0d: 10 Nickels for Skittles", test_num);
        repeat(10) pulse_nickel();
        #1;

        check_outputs(0, 0, 0, 1);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("\nTest Case %0d: Reset during transaction", test_num);
        pulse_quarter();
        rst = 1; @(posedge clk); #1 rst = 0;
        pulse_quarter();

        #1;


        check_outputs(0, 0, 0, 0);
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
        input expected_change;
        input expected_mms_dispense;
        input expected_reeses_dispense;
        input expected_skittles_dispense;
        begin
            if (expected_change === (expected_change ^ change ^ expected_change) &&
                expected_mms_dispense === (expected_mms_dispense ^ mms_dispense ^ expected_mms_dispense) &&
                expected_reeses_dispense === (expected_reeses_dispense ^ reeses_dispense ^ expected_reeses_dispense) &&
                expected_skittles_dispense === (expected_skittles_dispense ^ skittles_dispense ^ expected_skittles_dispense)) begin
                $display("PASS");
                $display("  Outputs: change=%b, mms_dispense=%b, reeses_dispense=%b, skittles_dispense=%b",
                         change, mms_dispense, reeses_dispense, skittles_dispense);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: change=%b, mms_dispense=%b, reeses_dispense=%b, skittles_dispense=%b",
                         expected_change, expected_mms_dispense, expected_reeses_dispense, expected_skittles_dispense);
                $display("  Got:      change=%b, mms_dispense=%b, reeses_dispense=%b, skittles_dispense=%b",
                         change, mms_dispense, reeses_dispense, skittles_dispense);
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
        $dumpvars(0,clk, dime, nickel, quarter, rst, change, mms_dispense, reeses_dispense, skittles_dispense);
    end

endmodule
