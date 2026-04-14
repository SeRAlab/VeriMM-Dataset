`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] data_in;
    reg reset;
    reg valid_in;
    wire [15:0] checksum_16;
    wire [31:0] checksum_32;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .reset(reset),
        .valid_in(valid_in),
        .checksum_16(checksum_16),
        .checksum_32(checksum_32),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        reset = 0;
        forever #5 reset = ~reset;
    end

        task reset_dut;

        begin
            reset = 1;
            valid_in = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Single Byte 0x01");
            reset_dut();
            data_in = 8'h01;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFEFE, 32'hFFFEFFFE, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Multi-byte 0x01, 0x02");
            reset_dut();
            valid_in = 1;
            data_in = 8'h01; @(posedge clk);
            data_in = 8'h02; @(posedge clk);
            valid_in = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFBFC, 32'hFFFBFFFC, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: 8-bit Sum Overflow (0xFF, 0x01)");
            reset_dut();
            valid_in = 1;
            data_in = 8'hFF; @(posedge clk);
            data_in = 8'h01; @(posedge clk);
            valid_in = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h00FF, 32'hFE00FEFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Sequence 0x11, 0x22, 0x33");
            reset_dut();
            valid_in = 1;
            data_in = 8'h11; @(posedge clk);
            data_in = 8'h22; @(posedge clk);
            data_in = 8'h33; @(posedge clk);
            valid_in = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5599, 32'hFF55FF99, 1'b1);
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
        input [15:0] expected_checksum_16;
        input [31:0] expected_checksum_32;
        input expected_valid_out;
        begin
            if (expected_checksum_16 === (expected_checksum_16 ^ checksum_16 ^ expected_checksum_16) &&
                expected_checksum_32 === (expected_checksum_32 ^ checksum_32 ^ expected_checksum_32) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: checksum_16=%h, checksum_32=%h, valid_out=%b",
                         checksum_16, checksum_32, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_16=%h, checksum_32=%h, valid_out=%b",
                         expected_checksum_16, expected_checksum_32, expected_valid_out);
                $display("  Got:      checksum_16=%h, checksum_32=%h, valid_out=%b",
                         checksum_16, checksum_32, valid_out);
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
        $dumpvars(0,data_in, reset, valid_in, checksum_16, checksum_32, valid_out);
    end

endmodule
