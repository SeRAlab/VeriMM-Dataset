`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ar;
    reg clk;
    reg d;
    reg s;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ar(ar),
        .clk(clk),
        .d(d),
        .s(s),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        ar = 0;
        forever #5 ar = ~ar;
    end

        task reset_dut;

        begin
            ar = 1;
            s = 0;
            d = 0;
            #12;
            ar = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            d = 1;
            s = 0;
            @(negedge clk);
            #2;
            $display("Testcase 001: Capture d=1 on negedge");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;

            d = 1;
            @(negedge clk);
            #2;

            d = 0;
            @(negedge clk);
            #2;
            $display("Testcase 002: Capture d=0 on negedge");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            d = 0;
            s = 1;
            @(negedge clk);
            #2;
            $display("Testcase 003: Set (s=1) overrides d=0 on negedge");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            d = 1;
            s = 1;
            @(negedge clk);
            #2;
            $display("Testcase 004: Set (s=1) with d=1 on negedge");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            s = 1;
            @(negedge clk);
            #2;

            ar = 1;
            #1;
            $display("Testcase 005: Asynchronous reset (ar=1) overrides current state");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            d = 1;
            s = 1;
            ar = 1;
            @(negedge clk);
            #2;
            $display("Testcase 006: Asynchronous reset (ar=1) overrides 's' and 'd' during edge");
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
        $dumpvars(0,ar, clk, d, s, q);
    end

endmodule
