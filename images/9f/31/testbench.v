`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk_in;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .clk_in(clk_in),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            #12;
            areset = 0;
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: 1 Clock Cycle Check...");
            reset_dut();
            @(posedge clk_in);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: 2 Clock Cycles Check...");
            reset_dut();
            repeat(2) @(posedge clk_in);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: 3 Clock Cycles Check...");
            reset_dut();
            repeat(3) @(posedge clk_in);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: 10 Clock Cycles Check...");
            reset_dut();
            repeat(10) @(posedge clk_in);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: 11 Clock Cycles Check...");
            reset_dut();
            repeat(11) @(posedge clk_in);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Asynchronous Reset Mid-Cycle Check...");
            reset_dut();
            repeat(5) @(posedge clk_in);
            #2;
            areset = 1;
            #1;
            #1;

            check_outputs(1'b0);
            areset = 0;
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
        input expected_clk_out;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b",
                         clk_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b",
                         expected_clk_out);
                $display("  Got:      clk_out=%b",
                         clk_out);
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
        $dumpvars(0,areset, clk_in, clk_out);
    end

endmodule
