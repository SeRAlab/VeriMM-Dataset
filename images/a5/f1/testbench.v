`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg clk;
    reg rst_n;
    wire down;
    wire rise;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .rst_n(rst_n),
        .down(down),
        .rise(rise)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            a = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset state...");
            reset_dut();

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Rising edge detection...");
            reset_dut();
            @(negedge clk) a = 0;
            repeat(2) @(posedge clk);
            @(negedge clk) a = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Falling edge detection...");
            reset_dut();
            @(negedge clk) a = 1;
            repeat(2) @(posedge clk);
            @(negedge clk) a = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Pulse duration check (Rising)...");
            reset_dut();
            @(negedge clk) a = 1;
            repeat(1) @(posedge clk);
            repeat(1) @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Pulse duration check (Falling)...");
            reset_dut();
            @(negedge clk) a = 1;
            repeat(2) @(posedge clk);
            @(negedge clk) a = 0;
            repeat(1) @(posedge clk);
            repeat(1) @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Back-to-back transitions...");
            reset_dut();
            @(negedge clk) a = 1;
            @(posedge clk);
            @(negedge clk) a = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0);
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
        input expected_down;
        input expected_rise;
        begin
            if (expected_down === (expected_down ^ down ^ expected_down) &&
                expected_rise === (expected_rise ^ rise ^ expected_rise)) begin
                $display("PASS");
                $display("  Outputs: down=%b, rise=%b",
                         down, rise);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: down=%b, rise=%b",
                         expected_down, expected_rise);
                $display("  Got:      down=%b, rise=%b",
                         down, rise);
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
        $dumpvars(0,a, clk, rst_n, down, rise);
    end

endmodule
