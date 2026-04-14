`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLOCK;
    wire NEWCLOCK;
    wire clk;
    wire clk298;
    wire clk381;
    wire clkShine;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLOCK(CLOCK),
        .NEWCLOCK(NEWCLOCK),
        .clk(clk),
        .clk298(clk298),
        .clk381(clk381),
        .clkShine(clkShine)
    );

    // Clock generation (10ns period)
    initial begin
        CLOCK = 0;
        forever #5 CLOCK = ~CLOCK;
    end

        task reset_dut;

        begin

            @(negedge CLOCK);
        end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Checking NEWCLOCK (Ratio 1/4)", test_num);
        reset_dut();
        repeat(2) @(posedge CLOCK);
        #1;
        #1;

        check_outputs(1'b1, 1'bx, 1'bx, 1'bx, 1'bx);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Checking clk (Ratio 1/8)", test_num);
        reset_dut();
        repeat(4) @(posedge CLOCK);
        #1;
        #1;

        check_outputs(1'bx, 1'b1, 1'bx, 1'bx, 1'bx);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Checking clk381 (Ratio 1/44)", test_num);
        reset_dut();
        repeat(22) @(posedge CLOCK);
        #1;
        #1;

        check_outputs(1'bx, 1'bx, 1'bx, 1'b1, 1'bx);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Checking clkShine (Ratio 1/48)", test_num);
        reset_dut();
        repeat(24) @(posedge CLOCK);
        #1;
        #1;

        check_outputs(1'bx, 1'bx, 1'bx, 1'bx, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Checking clk298 (Ratio 1/53)", test_num);
        reset_dut();
        repeat(27) @(posedge CLOCK);
        #1;
        #1;

        check_outputs(1'bx, 1'bx, 1'b1, 1'bx, 1'bx);
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
        input expected_NEWCLOCK;
        input expected_clk;
        input expected_clk298;
        input expected_clk381;
        input expected_clkShine;
        begin
            if (expected_NEWCLOCK === (expected_NEWCLOCK ^ NEWCLOCK ^ expected_NEWCLOCK) &&
                expected_clk === (expected_clk ^ clk ^ expected_clk) &&
                expected_clk298 === (expected_clk298 ^ clk298 ^ expected_clk298) &&
                expected_clk381 === (expected_clk381 ^ clk381 ^ expected_clk381) &&
                expected_clkShine === (expected_clkShine ^ clkShine ^ expected_clkShine)) begin
                $display("PASS");
                $display("  Outputs: NEWCLOCK=%b, clk=%b, clk298=%b, clk381=%b, clkShine=%b",
                         NEWCLOCK, clk, clk298, clk381, clkShine);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: NEWCLOCK=%b, clk=%b, clk298=%b, clk381=%b, clkShine=%b",
                         expected_NEWCLOCK, expected_clk, expected_clk298, expected_clk381, expected_clkShine);
                $display("  Got:      NEWCLOCK=%b, clk=%b, clk298=%b, clk381=%b, clkShine=%b",
                         NEWCLOCK, clk, clk298, clk381, clkShine);
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
        $dumpvars(0,CLOCK, NEWCLOCK, clk, clk298, clk381, clkShine);
    end

endmodule
