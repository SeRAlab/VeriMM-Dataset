`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg n;
    wire k;
    wire l;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .n(n),
        .k(k),
        .l(l)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        n = 1;

        repeat(10) @(posedge clock);

        while (l !== 1'b1) @(posedge clock);

        @(posedge clock);
        n = 0;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Single toggle pulse (n=1 for 1 cycle)");
        reset_dut();
        n = 1;
        @(posedge clock);
        n = 0;
        @(posedge clock);
        #1;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Two toggle pulses (n=1 for 2 cycles)");
        reset_dut();
        n = 1;
        @(posedge clock);
        @(posedge clock);
        n = 0;
        @(posedge clock);
        #1;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Three toggle pulses (n=1 for 3 cycles)");
        reset_dut();
        n = 1;
        repeat(3) @(posedge clock);
        n = 0;
        @(posedge clock);
        #1;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: State holding (n=1 then n=0 for 2 cycles)");
        reset_dut();
        n = 1;
        @(posedge clock);
        n = 0;
        repeat(2) @(posedge clock);
        #1;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Long sequence (n=1 for 10 cycles)");
        reset_dut();
        n = 1;
        repeat(10) @(posedge clock);
        n = 0;
        @(posedge clock);
        #1;

        #1;


        check_outputs(1'b1, 1'b0);
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
        input expected_k;
        input expected_l;
        begin
            if (expected_k === (expected_k ^ k ^ expected_k) &&
                expected_l === (expected_l ^ l ^ expected_l)) begin
                $display("PASS");
                $display("  Outputs: k=%b, l=%b",
                         k, l);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: k=%b, l=%b",
                         expected_k, expected_l);
                $display("  Got:      k=%b, l=%b",
                         k, l);
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
        $dumpvars(0,clock, n, k, l);
    end

endmodule
