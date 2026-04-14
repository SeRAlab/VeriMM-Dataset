`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] io_in_bits;
    reg [4:0] io_in_tag;
    reg io_in_valid;
    reg io_out_0_ready;
    reg io_out_1_ready;
    reg reset;
    wire io_chosen;
    wire io_in_ready;
    wire [31:0] io_out_0_bits;
    wire [4:0] io_out_0_tag;
    wire io_out_0_valid;
    wire [31:0] io_out_1_bits;
    wire [4:0] io_out_1_tag;
    wire io_out_1_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .io_in_bits(io_in_bits),
        .io_in_tag(io_in_tag),
        .io_in_valid(io_in_valid),
        .io_out_0_ready(io_out_0_ready),
        .io_out_1_ready(io_out_1_ready),
        .reset(reset),
        .io_chosen(io_chosen),
        .io_in_ready(io_in_ready),
        .io_out_0_bits(io_out_0_bits),
        .io_out_0_tag(io_out_0_tag),
        .io_out_0_valid(io_out_0_valid),
        .io_out_1_bits(io_out_1_bits),
        .io_out_1_tag(io_out_1_tag),
        .io_out_1_valid(io_out_1_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            io_in_valid = 0;
            io_in_bits = 0;
            io_in_tag = 0;
            io_out_0_ready = 0;
            io_out_1_ready = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Check initial state after reset");
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Valid data distribution to Port 0");
            reset_dut();
            io_in_valid = 1;
            io_in_bits = 32'hDEADBEEF;
            io_in_tag = 5'h1F;
            io_out_0_ready = 1;
            io_out_1_ready = 0;
            #1;

            #1;


            check_outputs(0, 1, 32'hDEADBEEF, 5'h1F, 1, 32'hDEADBEEF, 5'h1F, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Sequential distribution to Port 1");
            reset_dut();


            io_in_valid = 1;
            io_out_0_ready = 1;
            io_in_bits = 32'h11111111;
            io_in_tag = 5'h01;
            @(posedge clk);
            #1;


            io_in_bits = 32'h22222222;
            io_in_tag = 5'h02;
            io_out_1_ready = 1;
            #1;

            #1;


            check_outputs(1, 1, 32'h22222222, 5'h02, 0, 32'h22222222, 5'h02, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Port 0 Backpressure");
            reset_dut();
            io_in_valid = 1;
            io_out_0_ready = 0;
            io_out_1_ready = 1;
            #1;

            #1;


            check_outputs(0, 0, 0, 0, 1, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Verify return to Port 0 after Port 1");
            reset_dut();


            io_in_valid = 1; io_out_0_ready = 1;
            @(posedge clk); #1;


            io_in_valid = 1; io_out_1_ready = 1;
            @(posedge clk); #1;


            io_in_bits = 32'h33333333;
            io_in_tag = 5'h03;
            io_out_0_ready = 1;
            #1;
            #1;

            check_outputs(0, 1, 32'h33333333, 5'h03, 1, 32'h33333333, 5'h03, 0);
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
        input expected_io_chosen;
        input expected_io_in_ready;
        input [31:0] expected_io_out_0_bits;
        input [4:0] expected_io_out_0_tag;
        input expected_io_out_0_valid;
        input [31:0] expected_io_out_1_bits;
        input [4:0] expected_io_out_1_tag;
        input expected_io_out_1_valid;
        begin
            if (expected_io_chosen === (expected_io_chosen ^ io_chosen ^ expected_io_chosen) &&
                expected_io_in_ready === (expected_io_in_ready ^ io_in_ready ^ expected_io_in_ready) &&
                expected_io_out_0_bits === (expected_io_out_0_bits ^ io_out_0_bits ^ expected_io_out_0_bits) &&
                expected_io_out_0_tag === (expected_io_out_0_tag ^ io_out_0_tag ^ expected_io_out_0_tag) &&
                expected_io_out_0_valid === (expected_io_out_0_valid ^ io_out_0_valid ^ expected_io_out_0_valid) &&
                expected_io_out_1_bits === (expected_io_out_1_bits ^ io_out_1_bits ^ expected_io_out_1_bits) &&
                expected_io_out_1_tag === (expected_io_out_1_tag ^ io_out_1_tag ^ expected_io_out_1_tag) &&
                expected_io_out_1_valid === (expected_io_out_1_valid ^ io_out_1_valid ^ expected_io_out_1_valid)) begin
                $display("PASS");
                $display("  Outputs: io_chosen=%b, io_in_ready=%b, io_out_0_bits=%h, io_out_0_tag=%h, io_out_0_valid=%b, io_out_1_bits=%h, io_out_1_tag=%h, io_out_1_valid=%b",
                         io_chosen, io_in_ready, io_out_0_bits, io_out_0_tag, io_out_0_valid, io_out_1_bits, io_out_1_tag, io_out_1_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_chosen=%b, io_in_ready=%b, io_out_0_bits=%h, io_out_0_tag=%h, io_out_0_valid=%b, io_out_1_bits=%h, io_out_1_tag=%h, io_out_1_valid=%b",
                         expected_io_chosen, expected_io_in_ready, expected_io_out_0_bits, expected_io_out_0_tag, expected_io_out_0_valid, expected_io_out_1_bits, expected_io_out_1_tag, expected_io_out_1_valid);
                $display("  Got:      io_chosen=%b, io_in_ready=%b, io_out_0_bits=%h, io_out_0_tag=%h, io_out_0_valid=%b, io_out_1_bits=%h, io_out_1_tag=%h, io_out_1_valid=%b",
                         io_chosen, io_in_ready, io_out_0_bits, io_out_0_tag, io_out_0_valid, io_out_1_bits, io_out_1_tag, io_out_1_valid);
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
        $dumpvars(0,clk, io_in_bits, io_in_tag, io_in_valid, io_out_0_ready, io_out_1_ready, reset, io_chosen, io_in_ready, io_out_0_bits, io_out_0_tag, io_out_0_valid, io_out_1_bits, io_out_1_tag, io_out_1_valid);
    end

endmodule
