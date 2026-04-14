`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg reset;
    reg [4:0] shift_amount;
    wire [31:0] data_out;
    wire zero_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .shift_amount(shift_amount),
        .data_out(data_out),
        .zero_flag(zero_flag)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 0;
            shift_amount = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task wait_cycles;

        input integer n;
        begin
            repeat(n) @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: Basic shift left by 1");
            reset_dut();
            data_in = 32'h0000_0001;
            shift_amount = 5'd1;
            wait_cycles(STAGES);
            #1;

            check_outputs(32'h0000_0002, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Shift by 0 (Identity)");
            reset_dut();
            data_in = 32'hA5A5_A5A5;
            shift_amount = 5'd0;
            wait_cycles(STAGES);
            #1;

            check_outputs(32'hA5A5_A5A5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Max shift amount (31)");
            reset_dut();
            data_in = 32'h0000_0001;
            shift_amount = 5'd31;
            wait_cycles(STAGES);
            #1;

            check_outputs(32'h8000_0000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Shift MSB out (Zero Flag check)");
            reset_dut();
            data_in = 32'h8000_0000;
            shift_amount = 5'd1;
            wait_cycles(STAGES);
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Intermediate shift (16 bits)");
            reset_dut();
            data_in = 32'h0000_FFFF;
            shift_amount = 5'd16;
            wait_cycles(STAGES);
            #1;

            check_outputs(32'hFFFF_0000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Shift zero input");
            reset_dut();
            data_in = 32'h0000_0000;
            shift_amount = 5'd10;
            wait_cycles(STAGES);
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Shift alternating bit pattern");
            reset_dut();
            data_in = 32'h5555_5555;
            shift_amount = 5'd4;
            wait_cycles(STAGES);
            #1;

            check_outputs(32'h5555_5550, 1'b0);
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
        testcase007();
        
        
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
        input [31:0] expected_data_out;
        input expected_zero_flag;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_zero_flag === (expected_zero_flag ^ zero_flag ^ expected_zero_flag)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, zero_flag=%b",
                         data_out, zero_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, zero_flag=%b",
                         expected_data_out, expected_zero_flag);
                $display("  Got:      data_out=%h, zero_flag=%b",
                         data_out, zero_flag);
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
        $dumpvars(0,clk, data_in, reset, shift_amount, data_out, zero_flag);
    end

endmodule
