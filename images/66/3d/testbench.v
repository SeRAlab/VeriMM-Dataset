`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] if_din;
    reg if_read;
    reg if_read_ce;
    reg if_write;
    reg if_write_ce;
    reg reset;
    wire [7:0] if_dout;
    wire if_empty_n;
    wire if_full_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .if_din(if_din),
        .if_read(if_read),
        .if_read_ce(if_read_ce),
        .if_write(if_write),
        .if_write_ce(if_write_ce),
        .reset(reset),
        .if_dout(if_dout),
        .if_empty_n(if_empty_n),
        .if_full_n(if_full_n)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            if_din = 8'h0;
            if_read = 0;
            if_read_ce = 0;
            if_write = 0;
            if_write_ce = 0;
            @(posedge clk);
            @(posedge clk);
            reset = 0;
            @(posedge clk);
            $display("Reset complete.");
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial state after reset");
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(if_dout, 0, 1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Write and Single Read");
            test_num = 2;
            reset_dut();

            if_din = 8'hAA; if_write = 1; if_write_ce = 1;
            @(posedge clk);
            if_write = 0; if_write_ce = 0;
            @(posedge clk);

            if_read = 1; if_read_ce = 1;
            @(posedge clk);
            if_read = 0; if_read_ce = 0;
            @(posedge clk);
            #1;

            check_outputs(8'hAA, 0, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Fill FIFO to full");
            test_num = 3;
            reset_dut();

            if_din = 8'h11; if_write = 1; if_write_ce = 1;
            @(posedge clk);

            if_din = 8'h22;
            @(posedge clk);
            if_write = 0;
            @(posedge clk);

            #1;


            check_outputs(if_dout, 1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Write 2 items, Read 2 items sequence");
            test_num = 4;
            reset_dut();

            if_din = 8'h11; if_write = 1; if_write_ce = 1;
            @(posedge clk);
            if_din = 8'h22;
            @(posedge clk);
            if_write = 0;

            if_read = 1; if_read_ce = 1;
            @(posedge clk);

            @(posedge clk);
            if_read = 0;
            @(posedge clk);

            #1;


            check_outputs(8'h22, 0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Write Chip Enable (ce) Check");
            test_num = 5;
            reset_dut();

            if_din = 8'hFF; if_write = 1; if_write_ce = 0;
            @(posedge clk);

            if_din = 8'h55; if_write_ce = 1;
            @(posedge clk);
            if_write = 0;

            if_read = 1; if_read_ce = 1;
            @(posedge clk);
            if_read = 0;
            @(posedge clk);

            #1;


            check_outputs(8'h55, 0, 1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Overflow Check");
            test_num = 6;
            reset_dut();
            if_write = 1; if_write_ce = 1;
            if_din = 8'h01; @(posedge clk);
            if_din = 8'h02; @(posedge clk);
            if_din = 8'h03; @(posedge clk);
            if_write = 0;

            if_read = 1; if_read_ce = 1;
            @(posedge clk);
            @(posedge clk);
            if_read = 0;
            @(posedge clk);

            #1;


            check_outputs(8'h02, 0, 1);
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
        input [7:0] expected_if_dout;
        input expected_if_empty_n;
        input expected_if_full_n;
        begin
            if (expected_if_dout === (expected_if_dout ^ if_dout ^ expected_if_dout) &&
                expected_if_empty_n === (expected_if_empty_n ^ if_empty_n ^ expected_if_empty_n) &&
                expected_if_full_n === (expected_if_full_n ^ if_full_n ^ expected_if_full_n)) begin
                $display("PASS");
                $display("  Outputs: if_dout=%h, if_empty_n=%b, if_full_n=%b",
                         if_dout, if_empty_n, if_full_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: if_dout=%h, if_empty_n=%b, if_full_n=%b",
                         expected_if_dout, expected_if_empty_n, expected_if_full_n);
                $display("  Got:      if_dout=%h, if_empty_n=%b, if_full_n=%b",
                         if_dout, if_empty_n, if_full_n);
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
        $dumpvars(0,clk, if_din, if_read, if_read_ce, if_write, if_write_ce, reset, if_dout, if_empty_n, if_full_n);
    end

endmodule
