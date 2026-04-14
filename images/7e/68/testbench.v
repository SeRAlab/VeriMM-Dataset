`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clken;
    reg j;
    reg rst_n;
    reg se0;
    wire sync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clken(clken),
        .j(j),
        .rst_n(rst_n),
        .se0(se0),
        .sync(sync)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        clken = 0;
        j = 0;
        se0 = 0;
        repeat(2) @(posedge clk);
        #1 rst_n = 1;
        repeat(1) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Valid Sync Pattern Detection");
        reset_dut();

        send_bit(0, 0, 1);
        send_bit(1, 0, 1);
        send_bit(0, 0, 1);
        send_bit(1, 0, 1);
        send_bit(0, 0, 1);
        send_bit(1, 0, 1);
        send_bit(0, 0, 1);


        j = 0;
        se0 = 0;
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: SR Matches but j=1 (Sync should be LOW)");
        reset_dut();
        send_bit(0, 0, 1);
        send_bit(1, 0, 1);
        send_bit(0, 0, 1);
        send_bit(1, 0, 1);
        send_bit(0, 0, 1);
        send_bit(1, 0, 1);
        send_bit(0, 0, 1);

        j = 1;
        se0 = 0;
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: SR Matches but se0=1 (Sync should be LOW)");
        reset_dut();
        send_bit(0, 0, 1);
        send_bit(1, 0, 1);
        send_bit(0, 0, 1);
        send_bit(1, 0, 1);
        send_bit(0, 0, 1);
        send_bit(1, 0, 1);
        send_bit(0, 0, 1);

        j = 0;
        se0 = 1;
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Pattern Mismatch (All 1s)");
        reset_dut();

        repeat(7) send_bit(1, 0, 1);
        j = 0;
        se0 = 0;
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Verify Clock Enable inhibits shifting");
        reset_dut();

        send_bit(0, 0, 1);
        send_bit(1, 0, 1);
        send_bit(0, 0, 1);

        send_bit(1, 0, 0);

        send_bit(1, 0, 1);
        send_bit(0, 0, 1);
        send_bit(1, 0, 1);
        send_bit(0, 0, 1);
        j = 0;
        se0 = 0;
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Reset mid-operation");
        reset_dut();
        send_bit(0, 0, 1);
        send_bit(1, 0, 1);
        send_bit(0, 0, 1);

        rst_n = 0;
        @(posedge clk);
        #1 rst_n = 1;

        send_bit(1, 0, 1);
        send_bit(0, 0, 1);
        send_bit(1, 0, 1);
        send_bit(0, 0, 1);
        j = 0;
        se0 = 0;
        #2;
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
        input expected_sync;
        begin
            if (expected_sync === (expected_sync ^ sync ^ expected_sync)) begin
                $display("PASS");
                $display("  Outputs: sync=%b",
                         sync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sync=%b",
                         expected_sync);
                $display("  Got:      sync=%b",
                         sync);
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
        $dumpvars(0,clk, clken, j, rst_n, se0, sync);
    end

endmodule
