`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg en;
    reg reset;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .en(en),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        en = 0;
        d = 0;
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
        reset_dut();

        en = 1; d = 1;
        @(posedge clk); #1;


        reset = 1;
        @(posedge clk); #1;

        $display("Testcase 001: Synchronous Reset");
        #1;

        check_outputs(1'b0);
        reset = 0;
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        en = 1;
        d = 1;
        @(posedge clk); #1;

        $display("Testcase 002: Load 1 (en=1, d=1)");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        en = 1; d = 1;
        @(posedge clk); #1;

        d = 0;
        @(posedge clk); #1;

        $display("Testcase 003: Load 0 (en=1, d=0)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        en = 1; d = 1;
        @(posedge clk); #1;

        en = 0; d = 0;
        @(posedge clk); #1;

        $display("Testcase 004: Enable Hold (en=0, d=0, q should remain 1)");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        en = 1; d = 1;
        @(posedge clk); #1;


        reset = 1;
        en = 1;
        d = 1;
        @(posedge clk); #1;

        $display("Testcase 005: Reset Priority (reset=1, en=1, q should be 0)");
        #1;

        check_outputs(1'b0);
        reset = 0;
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        en = 1; d = 1; @(posedge clk); #1;
        en = 1; d = 0; @(posedge clk); #1;
        en = 0; d = 1; @(posedge clk); #1;
        en = 1; d = 1; @(posedge clk); #1;

        $display("Testcase 006: Multiple Transitions Check");
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
        input expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
                         q);
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
        $dumpvars(0,clk, d, en, reset, q);
    end

endmodule
