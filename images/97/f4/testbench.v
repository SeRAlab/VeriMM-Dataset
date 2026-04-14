`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in_data;
    reg [1:0] in_empty;
    reg in_endofpacket;
    reg [5:0] in_error;
    reg in_startofpacket;
    reg in_valid;
    reg out_ready;
    reg reset_n;
    wire in_ready;
    wire [31:0] out_data;
    wire [1:0] out_empty;
    wire out_endofpacket;
    wire [5:0] out_error;
    wire out_startofpacket;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_data(in_data),
        .in_empty(in_empty),
        .in_endofpacket(in_endofpacket),
        .in_error(in_error),
        .in_startofpacket(in_startofpacket),
        .in_valid(in_valid),
        .out_ready(out_ready),
        .reset_n(reset_n),
        .in_ready(in_ready),
        .out_data(out_data),
        .out_empty(out_empty),
        .out_endofpacket(out_endofpacket),
        .out_error(out_error),
        .out_startofpacket(out_startofpacket),
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
        in_empty = 0;
        in_endofpacket = 0;
        in_error = 0;
        in_startofpacket = 0;
        in_valid = 0;
        out_ready = 0;
        #20;
        reset_n = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Basic Data Transfer");
        reset_dut();
        in_data = 32'h12345678;
        in_valid = 1;
        out_ready = 1;
        in_startofpacket = 0;
        in_endofpacket = 0;
        in_empty = 0;
        in_error = 0;


        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1, 32'h12345678, 2'b00, 1'b0, 6'h00, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Start of Packet Propagation");
        reset_dut();
        in_data = 32'hAAAA_BBBB;
        in_valid = 1;
        out_ready = 1;
        in_startofpacket = 1;
        in_endofpacket = 0;
        in_empty = 0;
        in_error = 0;

        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 32'hAAAA_BBBB, 2'b00, 1'b0, 6'h00, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: End of Packet with Empty Bytes");
        reset_dut();
        in_data = 32'hCCCC_0000;
        in_valid = 1;
        out_ready = 1;
        in_startofpacket = 0;
        in_endofpacket = 1;
        in_empty = 2'b10;
        in_error = 0;

        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 32'hCCCC_0000, 2'b10, 1'b1, 6'h00, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Error Flag Propagation");
        reset_dut();
        in_data = 32'hEEEE_FFFF;
        in_valid = 1;
        out_ready = 1;
        in_startofpacket = 0;
        in_endofpacket = 0;
        in_empty = 0;
        in_error = 6'b101010;

        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 32'hEEEE_FFFF, 2'b00, 1'b0, 6'b101010, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Backpressure Handling (out_ready=0)");
        reset_dut();
        in_data = 32'h8888_8888;
        in_valid = 1;
        out_ready = 0;
        in_startofpacket = 0;
        in_endofpacket = 0;
        in_empty = 0;
        in_error = 0;

        @(posedge clk);
        #1;


        #1;



        check_outputs(1'b0, 32'h8888_8888, 2'b00, 1'b0, 6'h00, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Idle State (in_valid=0)");
        reset_dut();
        in_data = 32'h0000_0000;
        in_valid = 0;
        out_ready = 1;
        in_startofpacket = 0;
        in_endofpacket = 0;
        in_empty = 0;
        in_error = 0;

        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1, 32'h0000_0000, 2'b00, 1'b0, 6'h00, 1'b0, 1'b0);
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
        input expected_in_ready;
        input [31:0] expected_out_data;
        input [1:0] expected_out_empty;
        input expected_out_endofpacket;
        input [5:0] expected_out_error;
        input expected_out_startofpacket;
        input expected_out_valid;
        begin
            if (expected_in_ready === (expected_in_ready ^ in_ready ^ expected_in_ready) &&
                expected_out_data === (expected_out_data ^ out_data ^ expected_out_data) &&
                expected_out_empty === (expected_out_empty ^ out_empty ^ expected_out_empty) &&
                expected_out_endofpacket === (expected_out_endofpacket ^ out_endofpacket ^ expected_out_endofpacket) &&
                expected_out_error === (expected_out_error ^ out_error ^ expected_out_error) &&
                expected_out_startofpacket === (expected_out_startofpacket ^ out_startofpacket ^ expected_out_startofpacket) &&
                expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid)) begin
                $display("PASS");
                $display("  Outputs: in_ready=%b, out_data=%h, out_empty=%h, out_endofpacket=%b, out_error=%h, out_startofpacket=%b, out_valid=%b",
                         in_ready, out_data, out_empty, out_endofpacket, out_error, out_startofpacket, out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: in_ready=%b, out_data=%h, out_empty=%h, out_endofpacket=%b, out_error=%h, out_startofpacket=%b, out_valid=%b",
                         expected_in_ready, expected_out_data, expected_out_empty, expected_out_endofpacket, expected_out_error, expected_out_startofpacket, expected_out_valid);
                $display("  Got:      in_ready=%b, out_data=%h, out_empty=%h, out_endofpacket=%b, out_error=%h, out_startofpacket=%b, out_valid=%b",
                         in_ready, out_data, out_empty, out_endofpacket, out_error, out_startofpacket, out_valid);
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
        $dumpvars(0,clk, in_data, in_empty, in_endofpacket, in_error, in_startofpacket, in_valid, out_ready, reset_n, in_ready, out_data, out_empty, out_endofpacket, out_error, out_startofpacket, out_valid);
    end

endmodule
