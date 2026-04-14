`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] a;
    reg [2:0] b;
    reg [2:0] c;
    reg clk;
    wire [3:0] out_leds;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .out_leds(out_leds)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            c = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            a = 4; b = 4; c = 4;
            @(posedge clk);
            #2;
            $display("Testcase 001: Sum=12 (Threshold)");
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            a = 4; b = 4; c = 4; @(posedge clk); #2;

            a = 1; b = 1; c = 1;
            @(posedge clk);
            #2;
            $display("Testcase 002: Sum=3 (Below Threshold, retain previous)");
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            a = 5; b = 5; c = 5;
            @(posedge clk);
            #2;
            $display("Testcase 003: Sum=15 (Above Threshold)");
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            a = 7; b = 7; c = 7;
            @(posedge clk);
            #2;
            $display("Testcase 004: Sum=21 (Max Input Sum)");
            #1;

            check_outputs(4'b1101);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            a = 5; b = 5; c = 4;
            @(posedge clk); #2;
            a = 5; b = 4; c = 4;
            @(posedge clk);
            #2;
            $display("Testcase 005: Sequential update 14 -> 13");
            #1;

            check_outputs(4'b1101);
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
        input [3:0] expected_out_leds;
        begin
            if (expected_out_leds === (expected_out_leds ^ out_leds ^ expected_out_leds)) begin
                $display("PASS");
                $display("  Outputs: out_leds=%h",
                         out_leds);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_leds=%h",
                         expected_out_leds);
                $display("  Got:      out_leds=%h",
                         out_leds);
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
        $dumpvars(0,a, b, c, clk, out_leds);
    end

endmodule
