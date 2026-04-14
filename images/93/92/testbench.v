`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg din;
    reg sample_clk;
    wire sample_sig;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din(din),
        .sample_clk(sample_clk),
        .sample_sig(sample_sig)
    );

    // Clock generation (10ns period)
    initial begin
        sample_clk = 0;
        forever #5 sample_clk = ~sample_clk;
    end

        task reset_dut;

    begin
        din = 1'b1;
        repeat(5) @(posedge sample_clk);
        $display("\n--- Resetting DUT ---");
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Checking timing of the first sample pulse...", test_num);
        reset_dut();


        @(posedge sample_clk);
        #1 din = 1'b0;



        repeat(HALF_RATIO + RATIO) @(posedge sample_clk);
        #1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Checking timing of the second sample pulse...", test_num);
        reset_dut();


        @(posedge sample_clk);
        #1 din = 1'b0;


        repeat(HALF_RATIO + (2 * RATIO)) @(posedge sample_clk);
        #1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verifying return to STANDING_BY (idle) after %0d samples...", test_num, TOTAL_SAMPLES);
        reset_dut();


        @(posedge sample_clk);
        #1 din = 1'b0;


        repeat(HALF_RATIO + (TOTAL_SAMPLES + 1) * RATIO) @(posedge sample_clk);
        #1;


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verifying no sample_sig without din transition...", test_num);
        reset_dut();


        din = 1'b1;
        repeat(RATIO * 3) @(posedge sample_clk);
        #1;

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
        input expected_sample_sig;
        begin
            if (expected_sample_sig === (expected_sample_sig ^ sample_sig ^ expected_sample_sig)) begin
                $display("PASS");
                $display("  Outputs: sample_sig=%b",
                         sample_sig);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sample_sig=%b",
                         expected_sample_sig);
                $display("  Got:      sample_sig=%b",
                         sample_sig);
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
        $dumpvars(0,din, sample_clk, sample_sig);
    end

endmodule
