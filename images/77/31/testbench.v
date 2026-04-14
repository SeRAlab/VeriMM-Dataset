`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] bin_in;
    reg clk;
    reg [3:0] shift_amt;
    reg [15:0] shift_in;
    wire [3:0] gray_out;
    wire [15:0] shift_out;
    wire [3:0] xor_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin_in(bin_in),
        .clk(clk),
        .shift_amt(shift_amt),
        .shift_in(shift_in),
        .gray_out(gray_out),
        .shift_out(shift_out),
        .xor_out(xor_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            bin_in = 4'b0;
            shift_in = 16'h0;
            shift_amt = 4'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: All Zeros");
            reset_dut();

            bin_in = 4'h0;
            shift_in = 16'h0000;
            shift_amt = 4'h0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(4'h0, 16'h0000, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Gray Code Conversion (bin 1100)");
            reset_dut();

            bin_in = 4'b1100;
            shift_in = 16'h0000;
            shift_amt = 4'h0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(4'hA, 16'h0000, 4'hA);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Barrel Shifter (Shift Left 4)");
            reset_dut();

            bin_in = 4'h0;
            shift_in = 16'h000F;
            shift_amt = 4'd4;

            @(posedge clk);
            #2;

            #1;


            check_outputs(4'h0, 16'h00F0, 4'h0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Combined Logic (Shifter Lower 4 bits)");
            reset_dut();

            bin_in = 4'h0;
            shift_in = 16'h000F;
            shift_amt = 4'd1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(4'h0, 16'h001E, 4'hE);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Full Functionality Check");
            reset_dut();

            bin_in = 4'b1111;
            shift_in = 16'h5555;
            shift_amt = 4'd0;

            @(posedge clk);
            #2;



            #1;




            check_outputs(4'h8, 16'h5555, 4'hD);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Max Shift (15)");
            reset_dut();

            bin_in = 4'b1010;
            shift_in = 16'h0001;
            shift_amt = 4'd15;

            @(posedge clk);
            #2;



            #1;




            check_outputs(4'hF, 16'h8000, 4'hF);
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
        input [3:0] expected_gray_out;
        input [15:0] expected_shift_out;
        input [3:0] expected_xor_out;
        begin
            if (expected_gray_out === (expected_gray_out ^ gray_out ^ expected_gray_out) &&
                expected_shift_out === (expected_shift_out ^ shift_out ^ expected_shift_out) &&
                expected_xor_out === (expected_xor_out ^ xor_out ^ expected_xor_out)) begin
                $display("PASS");
                $display("  Outputs: gray_out=%h, shift_out=%h, xor_out=%h",
                         gray_out, shift_out, xor_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray_out=%h, shift_out=%h, xor_out=%h",
                         expected_gray_out, expected_shift_out, expected_xor_out);
                $display("  Got:      gray_out=%h, shift_out=%h, xor_out=%h",
                         gray_out, shift_out, xor_out);
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
        $dumpvars(0,bin_in, clk, shift_amt, shift_in, gray_out, shift_out, xor_out);
    end

endmodule
