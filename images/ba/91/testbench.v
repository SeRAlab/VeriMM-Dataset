`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in_data;
    reg in_ready;
    reg in_valid;
    reg reset_n;
    wire out_data;
    wire out_error;
    wire out_ready;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_data(in_data),
        .in_ready(in_ready),
        .in_valid(in_valid),
        .reset_n(reset_n),
        .out_data(out_data),
        .out_error(out_error),
        .out_ready(out_ready),
        .out_valid(out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n = 0;
        in_data = 0;
        in_valid = 0;
        in_ready = 0;
        #15;
        reset_n = 1;
        #10;
    end
        endtask
    task testcase001;

    begin
        $display("\nTestcase 001: Checking Reset State...");
        test_num = 1;
        reset_dut();
        #2;
        #1;

        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        $display("\nTestcase 002: Transferring Data '1'...");
        test_num = 2;
        reset_dut();
        @(posedge clk);
        in_data = 1;
        in_valid = 1;
        in_ready = 1;

        @(posedge clk);
        #2;
        #1;

        check_outputs(1, 0, 1, 1);
    end
        endtask

    task testcase003;

    begin
        $display("\nTestcase 003: Transferring Data '0'...");
        test_num = 3;
        reset_dut();
        @(posedge clk);
        in_data = 0;
        in_valid = 1;
        in_ready = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 0, 1, 1);
    end
        endtask

    task testcase004;

    begin
        $display("\nTestcase 004: Input Data with in_valid=0...");
        test_num = 4;
        reset_dut();
        @(posedge clk);
        in_data = 1;
        in_valid = 0;
        in_ready = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 0, 1, 0);
    end
        endtask

    task testcase005;

    begin
        $display("\nTestcase 005: Testing Backpressure (in_ready=0)...");
        test_num = 5;
        reset_dut();
        @(posedge clk);
        in_data = 1;
        in_valid = 1;
        in_ready = 0;
        @(posedge clk);
        #2;


        if (out_data === 1'b1 && out_valid === 1'b1 && out_error === 1'b0) begin
             $display("PASS: Data stored and valid despite downstream stall.");
             pass_count = pass_count + 1;
        end else begin
             $display("FAIL: Module did not handle stall correctly.");
             fail_count = fail_count + 1;
        end
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
        input expected_out_data;
        input expected_out_error;
        input expected_out_ready;
        input expected_out_valid;
        begin
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data) &&
                expected_out_error === (expected_out_error ^ out_error ^ expected_out_error) &&
                expected_out_ready === (expected_out_ready ^ out_ready ^ expected_out_ready) &&
                expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid)) begin
                $display("PASS");
                $display("  Outputs: out_data=%b, out_error=%b, out_ready=%b, out_valid=%b",
                         out_data, out_error, out_ready, out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%b, out_error=%b, out_ready=%b, out_valid=%b",
                         expected_out_data, expected_out_error, expected_out_ready, expected_out_valid);
                $display("  Got:      out_data=%b, out_error=%b, out_ready=%b, out_valid=%b",
                         out_data, out_error, out_ready, out_valid);
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
        $dumpvars(0,clk, in_data, in_ready, in_valid, reset_n, out_data, out_error, out_ready, out_valid);
    end

endmodule
