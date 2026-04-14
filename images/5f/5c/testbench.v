`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] a;
    reg [2:0] b;
    reg clock;
    reg reset;
    wire [3:0] c;
    wire [4:0] d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clock(clock),
        .reset(reset),
        .c(c),
        .d(d)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            a = 0;
            b = 0;
            @(posedge clock);
            #1;
            reset = 0;

            if (c !== 4'd0 || d !== 5'd0) begin
                $display("Error: Reset failed to clear outputs.");
            end
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Minimum values (a=0, b=0)");
            reset_dut();
            a = 2'd0; b = 3'd0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(4'd0, 5'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Maximum values (a=3, b=7)");
            reset_dut();
            a = 2'd3; b = 3'd7;
            @(posedge clock);
            #1;
            #1;

            check_outputs(4'd10, 5'd21);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Typical values (a=2, b=3)");
            reset_dut();
            a = 2'd2; b = 3'd3;
            @(posedge clock);
            #1;
            #1;

            check_outputs(4'd5, 5'd6);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Identity values (a=1, b=5)");
            reset_dut();
            a = 2'd1; b = 3'd5;
            @(posedge clock);
            #1;
            #1;

            check_outputs(4'd6, 5'd5);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Zero multiplier (a=3, b=0)");
            reset_dut();
            a = 2'd3; b = 3'd0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(4'd3, 5'd0);
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
        input [3:0] expected_c;
        input [4:0] expected_d;
        begin
            if (expected_c === (expected_c ^ c ^ expected_c) &&
                expected_d === (expected_d ^ d ^ expected_d)) begin
                $display("PASS");
                $display("  Outputs: c=%h, d=%h",
                         c, d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h, d=%h",
                         expected_c, expected_d);
                $display("  Got:      c=%h, d=%h",
                         c, d);
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
        $dumpvars(0,a, b, clock, reset, c, d);
    end

endmodule
