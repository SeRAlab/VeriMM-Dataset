`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg reset;
    reg [15:0] x;
    wire [15:0] e;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .x(x),
        .e(e),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            x = 0;
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
            $display("Running testcase001: Initial State Check...");
            reset_dut();
            x = 16'h1000;
            d = 16'h2000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h2000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Zero Input Check...");
            reset_dut();

            x = 16'h0100;
            d = 16'h0500;
            @(posedge clk);
            #1;

            x = 16'h0000;
            d = 16'h1234;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h1234, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Error Signal Calculation...");
            reset_dut();
            x = 16'h7FFF;
            d = 16'hFFFD;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFFFD, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Reset Clearing Delay Line...");
            reset_dut();
            x = 16'h4000;
            d = 16'h4000;
            repeat(5) @(posedge clk);

            reset_dut();
            x = 16'h1111;
            d = 16'h2222;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h2222, 16'h0000);
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
        input [15:0] expected_e;
        input [15:0] expected_y;
        begin
            if (expected_e === (expected_e ^ e ^ expected_e) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: e=%h, y=%h",
                         e, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: e=%h, y=%h",
                         expected_e, expected_y);
                $display("  Got:      e=%h, y=%h",
                         e, y);
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
        $dumpvars(0,clk, d, reset, x, e, y);
    end

endmodule
