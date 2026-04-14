`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] in;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst = 1;
            in = 2'b00;
            repeat (2) @(negedge clk);
            rst = 0;
            $display("\n--- Resetting DUT ---");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            $display("Testcase 001: Checking Initial State (S0)");
            #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge clk);
            in = 2'b01;
            @(negedge clk);
            $display("Testcase 002: Checking Transition S0 -> S1");
            #1;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(negedge clk);
            in = 2'b01;
            @(negedge clk);
            in = 2'b10;
            @(negedge clk);
            $display("Testcase 003: Checking Transition S1 -> S2");
            #1;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(negedge clk);
            in = 2'b01;
            @(negedge clk);
            in = 2'b10;
            @(negedge clk);
            in = 2'b11;
            @(negedge clk);
            $display("Testcase 004: Checking Transition S2 -> S3");
            #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(negedge clk);
            in = 2'b01;
            @(negedge clk);
            in = 2'b00;
            @(negedge clk);
            $display("Testcase 005: Checking State Retention (Hold in S1)");
            #1;
            #1;

            check_outputs(4'b0010);
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
        input [3:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in, out);
    end

endmodule
