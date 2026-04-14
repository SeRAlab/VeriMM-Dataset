`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg preset;
    reg reset;
    wire q;
    wire q_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .preset(preset),
        .reset(reset),
        .q(q),
        .q_n(q_n)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            preset = 0;
            d = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Active");
            reset_dut();
            reset = 1;
            preset = 0;
            d = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Preset Active");
            reset_dut();
            reset = 0;
            preset = 1;
            d = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Load D=1");
            reset_dut();
            reset = 0;
            preset = 0;
            d = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Load D=0");
            reset_dut();

            reset = 0;
            preset = 0;
            d = 1;
            @(posedge clk);
            #1;

            d = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Reset priority over Preset");
            reset_dut();
            reset = 1;
            preset = 1;
            d = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Output stability between edges");
            reset_dut();
            reset = 0;
            preset = 0;
            d = 1;
            @(posedge clk);
            #1;
            d = 0;
            #2;
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
        input expected_q_n;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_q_n === (expected_q_n ^ q_n ^ expected_q_n)) begin
                $display("PASS");
                $display("  Outputs: q=%b, q_n=%b",
                         q, q_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, q_n=%b",
                         expected_q, expected_q_n);
                $display("  Got:      q=%b, q_n=%b",
                         q, q_n);
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
        $dumpvars(0,clk, d, preset, reset, q, q_n);
    end

endmodule
