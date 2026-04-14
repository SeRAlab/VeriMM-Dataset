`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_in_n;
    wire rst_out_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst_in_n(rst_in_n),
        .rst_out_n(rst_out_n)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_in_n = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Test Case 001: Verifying active reset state...");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Test Case 002: Verifying delay after release (2 cycles)...");
        rst_in_n = 1;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Test Case 003: Verifying release after 3 cycles...");
        rst_in_n = 1;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        rst_in_n = 1;
        repeat(3) @(posedge clk);
        #1;
        if (rst_out_n !== 1'b1) $display("Setup failed for Test Case 004");

        $display("Test Case 004: Verifying immediate reset assertion...");
        rst_in_n = 0;
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Test Case 005: Verifying interrupted sequence...");
        rst_in_n = 1;
        @(posedge clk);
        #1;
        rst_in_n = 0;
        @(posedge clk);
        #1;
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
        input expected_rst_out_n;
        begin
            if (expected_rst_out_n === (expected_rst_out_n ^ rst_out_n ^ expected_rst_out_n)) begin
                $display("PASS");
                $display("  Outputs: rst_out_n=%b",
                         rst_out_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rst_out_n=%b",
                         expected_rst_out_n);
                $display("  Got:      rst_out_n=%b",
                         rst_out_n);
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
        $dumpvars(0,clk, rst_in_n, rst_out_n);
    end

endmodule
