`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg active;
    reg clk_in;
    reg [15:0] int_a;
    reg [15:0] int_b;
    wire clk_out;
    wire match;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .active(active),
        .clk_in(clk_in),
        .int_a(int_a),
        .int_b(int_b),
        .clk_out(clk_out),
        .match(match)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            active = 0;
            int_a = 16'h0000;
            int_b = 16'hFFFF;

            @(negedge clk_in);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Active high, Mismatch (a!=b)");
            active = 1;
            int_a = 16'h1234;
            int_b = 16'hABCD;


            @(negedge clk_in);
            #2;


            wait(clk_in == 1'b1);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Active high, Match (a==b)");
            active = 1;
            int_a = 16'h5555;
            int_b = 16'h5555;


            @(negedge clk_in);
            #2;


            wait(clk_in == 1'b1);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: Inactive, Match (a==b)");
            active = 0;
            int_a = 16'hAAAA;
            int_b = 16'hAAAA;


            @(negedge clk_in);
            #2;


            wait(clk_in == 1'b1);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: Transition Match -> Mismatch");
            active = 1;
            int_a = 16'h7777;
            int_b = 16'h7777;

            @(negedge clk_in);
            #2;


            int_b = 16'h8888;

            @(negedge clk_in);
            #2;


            wait(clk_in == 1'b1);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: Boundary Values Match (0xFFFF)");
            active = 1;
            int_a = 16'hFFFF;
            int_b = 16'hFFFF;

            @(negedge clk_in);
            #2;

            wait(clk_in == 1'b1);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_clk_out;
        input expected_match;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out) &&
                expected_match === (expected_match ^ match ^ expected_match)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b, match=%b",
                         clk_out, match);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b, match=%b",
                         expected_clk_out, expected_match);
                $display("  Got:      clk_out=%b, match=%b",
                         clk_out, match);
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
        $dumpvars(0,active, clk_in, int_a, int_b, clk_out, match);
    end

endmodule
