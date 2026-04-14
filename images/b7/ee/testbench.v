`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire clk_50mhz;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk_50mhz(clk_50mhz)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin

        @(negedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Checking first toggle...");
        reset_dut();
        @(posedge clk);
        #1;
        #1;

        check_outputs(global_count[0]);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Checking second toggle (return to 0)...");
        reset_dut();
        @(posedge clk);
        #1;
        #1;

        check_outputs(global_count[0]);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Checking output after 5 clock cycles...");
        reset_dut();
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(global_count[0]);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Checking output after 10 clock cycles...");
        reset_dut();
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(global_count[0]);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Checking output after 100 clock cycles...");
        reset_dut();
        repeat(100) @(posedge clk);
        #1;
        #1;

        check_outputs(global_count[0]);
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
        input expected_clk_50mhz;
        begin
            if (expected_clk_50mhz === (expected_clk_50mhz ^ clk_50mhz ^ expected_clk_50mhz)) begin
                $display("PASS");
                $display("  Outputs: clk_50mhz=%b",
                         clk_50mhz);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_50mhz=%b",
                         expected_clk_50mhz);
                $display("  Got:      clk_50mhz=%b",
                         clk_50mhz);
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
        $dumpvars(0,clk, clk_50mhz);
    end

endmodule
