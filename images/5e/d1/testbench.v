`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] bin_in;
    reg clk;
    reg rst;
    wire [3:0] dec_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin_in(bin_in),
        .clk(clk),
        .rst(rst),
        .dec_out(dec_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            bin_in = 4'b0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Input = 5");
            reset_dut();
            bin_in = 4'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Input = 15");
            reset_dut();
            bin_in = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Input = 0");
            reset_dut();
            bin_in = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Input = 10");
            reset_dut();
            bin_in = 4'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd10, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Input = 8");
            reset_dut();
            bin_in = 4'd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd8, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Reset State Check");
            rst = 1;
            bin_in = 4'd7;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'd0, 1'b0);
            rst = 0;
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
        input [3:0] expected_dec_out;
        input expected_valid_out;
        begin
            if (expected_dec_out === (expected_dec_out ^ dec_out ^ expected_dec_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: dec_out=%h, valid_out=%b",
                         dec_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dec_out=%h, valid_out=%b",
                         expected_dec_out, expected_valid_out);
                $display("  Got:      dec_out=%h, valid_out=%b",
                         dec_out, valid_out);
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
        $dumpvars(0,bin_in, clk, rst, dec_out, valid_out);
    end

endmodule
