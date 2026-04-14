`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg r;
    reg reset;
    reg s;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .r(r),
        .reset(reset),
        .s(s),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            s = 0;
            r = 0;
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Synchronous Reset");
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            s = 1; r = 0;
            @(posedge clk);
            #1;
            $display("Testcase 002: Set (S=1, R=0)");
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            s = 1; r = 0;
            @(posedge clk);

            s = 0; r = 1;
            @(posedge clk);
            #1;
            $display("Testcase 003: Reset (S=0, R=1)");
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            s = 1; r = 0;
            @(posedge clk);

            s = 0; r = 0;
            @(posedge clk);
            #1;
            $display("Testcase 004: Hold Logic (Previous state 1)");
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            s = 0; r = 0;
            @(posedge clk);
            #1;
            $display("Testcase 005: Hold Logic (Previous state 0)");
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            s = 1; r = 0; reset = 1;
            @(posedge clk);
            #1;
            $display("Testcase 006: Sync Reset Priority over S=1");
            #1;

            check_outputs(0);
            reset = 0;
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
        $dumpvars(0,clk, r, reset, s, q);
    end

endmodule
