`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg rst;
    reg [3:0] shift_direction;
    wire [3:0] count_out;
    wire [15:0] shifted_data_out;
    wire xor_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .shift_direction(shift_direction),
        .count_out(count_out),
        .shifted_data_out(shifted_data_out),
        .xor_out(xor_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            shift_direction = 4'b0000;
            data_in = 16'h0000;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset Verification");
            reset_dut();

            #1;


            check_outputs(4'h0, 16'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Direct Pass-through (No Shift)");
            reset_dut();
            data_in = 16'hAAAA;
            shift_direction = 4'b0000;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h0, 16'hAAAA, calc_xor(16'hAAAA, 4'h0));
        end
        endtask

    task testcase003;

        reg [15:0] expected_data;
        begin
            $display("Running Testcase 003: Left Shift (1 bit)");
            reset_dut();

            data_in = 16'hAAAA;
            shift_direction = 4'b0000;
            @(posedge clk);

            data_in = 16'h8000;
            shift_direction = 4'b0001;
            expected_data = (16'hAAAA << 1) | 1'b1;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h1, expected_data, calc_xor(expected_data, 4'h1));
        end
        endtask

    task testcase004;

        reg [15:0] expected_data;
        begin
            $display("Running Testcase 004: Right Shift (1 bit)");
            reset_dut();

            data_in = 16'h5555;
            shift_direction = 4'b0000;
            @(posedge clk);

            data_in = 16'hFFFE;
            shift_direction = 4'b0010;
            expected_data = (16'h5555 >> 1) | (1'b0 << 15);
            @(posedge clk);
            #1 #1;
 check_outputs(4'hF, expected_data, calc_xor(expected_data, 4'hF));
        end
        endtask

    task testcase005;

        reg [15:0] expected_data;
        integer i;
        begin
            $display("Running Testcase 005: Accumulative Left Shifts (4 bits)");
            reset_dut();
            expected_data = 16'h0000;
            shift_direction = 4'b0001;
            data_in = 16'h8000;

            for(i=0; i<4; i=i+1) begin
                expected_data = (expected_data << 1) | 1'b1;
                @(posedge clk);
            end

            #1 #1;
 check_outputs(4'h4, expected_data, calc_xor(expected_data, 4'h4));
        end
        endtask

    task testcase006;

        reg [15:0] expected_data;
        integer i;
        begin
            $display("Running Testcase 006: Multiple Right Shifts");
            reset_dut();
            expected_data = 16'hFFFF;
            data_in = 16'hFFFF;
            shift_direction = 4'b0000;
            @(posedge clk);

            shift_direction = 4'b0010;
            data_in = 16'h0000;
            for(i=0; i<3; i=i+1) begin
                expected_data = (expected_data >> 1);
                @(posedge clk);
            end

            #1 #1;
 check_outputs(4'hD, expected_data, calc_xor(expected_data, 4'hD));
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
        input [3:0] expected_count_out;
        input [15:0] expected_shifted_data_out;
        input expected_xor_out;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out) &&
                expected_shifted_data_out === (expected_shifted_data_out ^ shifted_data_out ^ expected_shifted_data_out) &&
                expected_xor_out === (expected_xor_out ^ xor_out ^ expected_xor_out)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h, shifted_data_out=%h, xor_out=%b",
                         count_out, shifted_data_out, xor_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h, shifted_data_out=%h, xor_out=%b",
                         expected_count_out, expected_shifted_data_out, expected_xor_out);
                $display("  Got:      count_out=%h, shifted_data_out=%h, xor_out=%b",
                         count_out, shifted_data_out, xor_out);
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
        $dumpvars(0,clk, data_in, rst, shift_direction, count_out, shifted_data_out, xor_out);
    end

endmodule
