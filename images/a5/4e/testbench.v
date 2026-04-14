`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg button;
    reg clk;
    reg enable;
    reg reset;
    wire [2:0] counter_out;
    wire [2:0] led_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .button(button),
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .counter_out(counter_out),
        .led_out(led_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            button = 0;
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
            $display("Testcase 001: Reset Verification");
            reset_dut();
            #1;

            check_outputs(3'b000, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Single Increment on Release");
            reset_dut();
            enable = 1;
            @(posedge clk); #1;
            button = 1;
            repeat(2) @(posedge clk); #1;
            button = 0;
            repeat(2) @(posedge clk); #1;
            #1;

            check_outputs(3'b001, 3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Enable Check (Enable=0)");
            reset_dut();
            enable = 0;
            @(posedge clk); #1;
            button = 1;
            @(posedge clk); #1;
            button = 0;
            repeat(2) @(posedge clk); #1;
            #1;

            check_outputs(3'b000, 3'b000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Multi-cycle Button State Check");
            reset_dut();
            enable = 1;
            @(posedge clk); #1;
            button = 1;
            repeat(5) @(posedge clk);
            #1;
            button = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(3'b001, 3'b001);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase 005: Sequence of 3 Increments");
            reset_dut();
            enable = 1;
            for(i = 0; i < 3; i = i + 1) begin
                @(posedge clk); #1;
                button = 1;
                @(posedge clk); #1;
                button = 0;
            end
            repeat(2) @(posedge clk); #1;
            #1;

            check_outputs(3'b011, 3'b011);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase 006: 3-bit Counter Overflow (8 increments)");
            reset_dut();
            enable = 1;
            for(i = 0; i < 8; i = i + 1) begin
                @(posedge clk); #1;
                button = 1;
                @(posedge clk); #1;
                button = 0;
            end
            repeat(2) @(posedge clk); #1;

            #1;


            check_outputs(3'b000, 3'b000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Reset Priority mid-count");
            reset_dut();
            enable = 1;

            repeat(2) begin
                @(posedge clk); #1; button = 1;
                @(posedge clk); #1; button = 0;
            end
            @(posedge clk); #1;
            reset = 1;
            @(posedge clk); #1;
            reset = 0;
            #1;

            check_outputs(3'b000, 3'b000);
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
        testcase007();
        
        
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
        input [2:0] expected_counter_out;
        input [2:0] expected_led_out;
        begin
            if (expected_counter_out === (expected_counter_out ^ counter_out ^ expected_counter_out) &&
                expected_led_out === (expected_led_out ^ led_out ^ expected_led_out)) begin
                $display("PASS");
                $display("  Outputs: counter_out=%h, led_out=%h",
                         counter_out, led_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_out=%h, led_out=%h",
                         expected_counter_out, expected_led_out);
                $display("  Got:      counter_out=%h, led_out=%h",
                         counter_out, led_out);
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
        $dumpvars(0,button, clk, enable, reset, counter_out, led_out);
    end

endmodule
