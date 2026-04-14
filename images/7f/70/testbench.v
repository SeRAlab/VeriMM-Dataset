`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg sig;
    wire sigsync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .sig(sig),
        .sigsync(sigsync)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        reset = 1;
        sig = 0;
        @(negedge clk);
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Verification of Reset State");
        test_num = 1;
        reset_dut();

        @(posedge clk);
        #1 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Signal High Propagation (2 Cycles)");
        test_num = 2;
        reset_dut();
        @(negedge clk);
        sig = 1;

        repeat(2) @(posedge clk);
        #1 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Signal Low Propagation");
        test_num = 3;
        reset_dut();

        @(negedge clk);
        sig = 1;
        repeat(2) @(posedge clk);

        @(negedge clk);
        sig = 0;
        repeat(2) @(posedge clk);
        #1 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Propagation of 1-cycle Pulse");
        test_num = 4;
        reset_dut();
        @(negedge clk);
        sig = 1;
        @(negedge clk);
        sig = 0;



        @(posedge clk);
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Reset Overriding Input");
        test_num = 5;
        reset_dut();
        @(negedge clk);
        sig = 1;
        @(posedge clk);
        @(negedge clk);
        reset = 1;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
        #1 #1;
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
        input expected_sigsync;
        begin
            if (expected_sigsync === (expected_sigsync ^ sigsync ^ expected_sigsync)) begin
                $display("PASS");
                $display("  Outputs: sigsync=%b",
                         sigsync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sigsync=%b",
                         expected_sigsync);
                $display("  Got:      sigsync=%b",
                         sigsync);
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
        $dumpvars(0,clk, reset, sig, sigsync);
    end

endmodule
