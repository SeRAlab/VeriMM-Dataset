`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clken;
    reg clock;
    reg [1:0] denom;
    reg [63:0] numer;
    wire [63:0] quotient;
    wire [1:0] remain;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clken(clken),
        .clock(clock),
        .denom(denom),
        .numer(numer),
        .quotient(quotient),
        .remain(remain)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            clken = 0;
            denom = 0;
            numer = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Division by 1");
            reset_dut();
            numer = 64'hA5A5A5A5A5A5A5A5;
            denom = 2'd1;
            clken = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(64'hA5A5A5A5A5A5A5A5, 2'd0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Division by 2 (Even number)");
            reset_dut();
            numer = 64'd1000;
            denom = 2'd2;
            clken = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(64'd500, 2'd0);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Division by 2 (Odd number)");
            reset_dut();
            numer = 64'hFFFFFFFFFFFFFFFF;
            denom = 2'd2;
            clken = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(64'h7FFFFFFFFFFFFFFF, 2'd1);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Division by 3 (Remainder 1)");
            reset_dut();
            numer = 64'd10;
            denom = 2'd3;
            clken = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(64'd3, 2'd1);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Division by 3 (Remainder 2)");
            reset_dut();
            numer = 64'd11;
            denom = 2'd3;
            clken = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(64'd3, 2'd2);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Numerator is 0");
            reset_dut();
            numer = 64'd0;
            denom = 2'd3;
            clken = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(64'd0, 2'd0);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: Max value divided by 3");
            reset_dut();

            numer = 64'hFFFFFFFFFFFFFFFF;
            denom = 2'd3;
            clken = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(64'h5555555555555555, 2'd0);
        end
        endtask

    task testcase008;

        begin
            $display("\nTestcase 008: Small numerator, large denominator");
            reset_dut();
            numer = 64'd1;
            denom = 2'd3;
            clken = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(64'd0, 2'd1);
        end
        endtask

    task testcase009;

        reg [63:0] prev_q;
        reg [1:0] prev_r;
        begin
            $display("\nTestcase 009: Clock Enable validation");

            reset_dut();
            numer = 64'd20;
            denom = 2'd2;
            clken = 1;
            @(posedge clock);
            #2;
            prev_q = quotient;
            prev_r = remain;


            clken = 0;
            numer = 64'd50;
            denom = 2'd1;
            @(posedge clock);
            #2;

            #1;


            check_outputs(prev_q, prev_r);
        end
        endtask

    task testcase010;

        begin
            $display("\nTestcase 010: Boundary value (2^63)");
            reset_dut();
            numer = 64'h8000000000000000;
            denom = 2'd2;
            clken = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(64'h4000000000000000, 2'd0);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [63:0] expected_quotient;
        input [1:0] expected_remain;
        begin
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remain === (expected_remain ^ remain ^ expected_remain)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h, remain=%h",
                         quotient, remain);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h, remain=%h",
                         expected_quotient, expected_remain);
                $display("  Got:      quotient=%h, remain=%h",
                         quotient, remain);
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
        $dumpvars(0,clken, clock, denom, numer, quotient, remain);
    end

endmodule
