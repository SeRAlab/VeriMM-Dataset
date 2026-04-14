`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg i;
    reg rst_n;
    wire strobe;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i(i),
        .rst_n(rst_n),
        .strobe(strobe)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        rst_n = 0;
        i = 0;
        repeat(2) @(negedge clk);
        rst_n = 1;
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Initial state after reset");
        reset_dut();

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Stable low input");
        reset_dut();
        i = 0;

        repeat(4) @(negedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Stable high input");
        reset_dut();
        i = 1;

        repeat(4) @(negedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Frequent transitions (strobe should stay low)");
        reset_dut();

        repeat(10) begin
            i = ~i;
            repeat(2) @(negedge clk);
        end
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Transition resets active strobe");
        reset_dut();
        i = 0;
        repeat(4) @(negedge clk);
        i = 1;
        @(negedge clk);
        #1;

        check_outputs(1'b0);
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
        input expected_strobe;
        begin
            if (expected_strobe === (expected_strobe ^ strobe ^ expected_strobe)) begin
                $display("PASS");
                $display("  Outputs: strobe=%b",
                         strobe);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: strobe=%b",
                         expected_strobe);
                $display("  Got:      strobe=%b",
                         strobe);
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
        $dumpvars(0,clk, i, rst_n, strobe);
    end

endmodule
