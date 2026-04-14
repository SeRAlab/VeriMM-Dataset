`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] ALU_out;
    reg [2:0] EX_WB_Rd_in;
    reg [7:0] EX_WB_Rsdata_in;
    reg EX_WB_regWrite_in;
    reg EX_WB_write_mux_in;
    reg clock;
    reg reset;
    wire [7:0] ALU_WB_out;
    wire [2:0] EX_WB_Rd_out;
    wire [7:0] EX_WB_Rsdata_out;
    wire EX_WB_regWrite_out;
    wire EX_WB_write_mux_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_out(ALU_out),
        .EX_WB_Rd_in(EX_WB_Rd_in),
        .EX_WB_Rsdata_in(EX_WB_Rsdata_in),
        .EX_WB_regWrite_in(EX_WB_regWrite_in),
        .EX_WB_write_mux_in(EX_WB_write_mux_in),
        .clock(clock),
        .reset(reset),
        .ALU_WB_out(ALU_WB_out),
        .EX_WB_Rd_out(EX_WB_Rd_out),
        .EX_WB_Rsdata_out(EX_WB_Rsdata_out),
        .EX_WB_regWrite_out(EX_WB_regWrite_out),
        .EX_WB_write_mux_out(EX_WB_write_mux_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 0;
        ALU_out = 0;
        EX_WB_Rsdata_in = 0;
        EX_WB_Rd_in = 0;
        EX_WB_regWrite_in = 0;
        EX_WB_write_mux_in = 0;
        @(posedge clock);
        #2;
        reset = 1;
        @(posedge clock);
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Testcase 001: Basic Data Capture");
        ALU_out = 8'hA5;
        EX_WB_Rsdata_in = 8'h5A;
        EX_WB_Rd_in = 3'h3;
        EX_WB_regWrite_in = 1'b1;
        EX_WB_write_mux_in = 1'b0;
        @(posedge clock);
        #2;
        #1;

        check_outputs(8'hA5, 3'h3, 8'h5A, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Testcase 002: Verification of Reset to Zero");

        ALU_out = 8'hFF;
        EX_WB_Rsdata_in = 8'hFF;
        EX_WB_Rd_in = 3'h7;
        EX_WB_regWrite_in = 1'b1;
        EX_WB_write_mux_in = 1'b1;
        @(posedge clock);
        #1;
        reset = 0;
        @(posedge clock);
        #2;
        #1;

        check_outputs(8'h00, 3'h0, 8'h00, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Testcase 003: Maximum values (All 1s)");
        ALU_out = 8'hFF;
        EX_WB_Rsdata_in = 8'hFF;
        EX_WB_Rd_in = 3'h7;
        EX_WB_regWrite_in = 1'b1;
        EX_WB_write_mux_in = 1'b1;
        @(posedge clock);
        #2;
        #1;

        check_outputs(8'hFF, 3'h7, 8'hFF, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Testcase 004: Control Signal Toggling");
        ALU_out = 8'h12;
        EX_WB_Rsdata_in = 8'h34;
        EX_WB_Rd_in = 3'h1;
        EX_WB_regWrite_in = 1'b0;
        EX_WB_write_mux_in = 1'b1;
        @(posedge clock);
        #2;
        #1;

        check_outputs(8'h12, 3'h1, 8'h34, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Testcase 005: Consecutive Cycles Update");

        ALU_out = 8'h11;
        EX_WB_Rsdata_in = 8'h22;
        EX_WB_Rd_in = 3'h4;
        @(posedge clock);

        #1;
        ALU_out = 8'hCC;
        EX_WB_Rsdata_in = 8'hDD;
        EX_WB_Rd_in = 3'h6;
        EX_WB_regWrite_in = 1'b1;
        EX_WB_write_mux_in = 1'b0;
        @(posedge clock);
        #2;
        #1;

        check_outputs(8'hCC, 3'h6, 8'hDD, 1'b1, 1'b0);
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
        input [7:0] expected_ALU_WB_out;
        input [2:0] expected_EX_WB_Rd_out;
        input [7:0] expected_EX_WB_Rsdata_out;
        input expected_EX_WB_regWrite_out;
        input expected_EX_WB_write_mux_out;
        begin
            if (expected_ALU_WB_out === (expected_ALU_WB_out ^ ALU_WB_out ^ expected_ALU_WB_out) &&
                expected_EX_WB_Rd_out === (expected_EX_WB_Rd_out ^ EX_WB_Rd_out ^ expected_EX_WB_Rd_out) &&
                expected_EX_WB_Rsdata_out === (expected_EX_WB_Rsdata_out ^ EX_WB_Rsdata_out ^ expected_EX_WB_Rsdata_out) &&
                expected_EX_WB_regWrite_out === (expected_EX_WB_regWrite_out ^ EX_WB_regWrite_out ^ expected_EX_WB_regWrite_out) &&
                expected_EX_WB_write_mux_out === (expected_EX_WB_write_mux_out ^ EX_WB_write_mux_out ^ expected_EX_WB_write_mux_out)) begin
                $display("PASS");
                $display("  Outputs: ALU_WB_out=%h, EX_WB_Rd_out=%h, EX_WB_Rsdata_out=%h, EX_WB_regWrite_out=%b, EX_WB_write_mux_out=%b",
                         ALU_WB_out, EX_WB_Rd_out, EX_WB_Rsdata_out, EX_WB_regWrite_out, EX_WB_write_mux_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_WB_out=%h, EX_WB_Rd_out=%h, EX_WB_Rsdata_out=%h, EX_WB_regWrite_out=%b, EX_WB_write_mux_out=%b",
                         expected_ALU_WB_out, expected_EX_WB_Rd_out, expected_EX_WB_Rsdata_out, expected_EX_WB_regWrite_out, expected_EX_WB_write_mux_out);
                $display("  Got:      ALU_WB_out=%h, EX_WB_Rd_out=%h, EX_WB_Rsdata_out=%h, EX_WB_regWrite_out=%b, EX_WB_write_mux_out=%b",
                         ALU_WB_out, EX_WB_Rd_out, EX_WB_Rsdata_out, EX_WB_regWrite_out, EX_WB_write_mux_out);
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
        $dumpvars(0,ALU_out, EX_WB_Rd_in, EX_WB_Rsdata_in, EX_WB_regWrite_in, EX_WB_write_mux_in, clock, reset, ALU_WB_out, EX_WB_Rd_out, EX_WB_Rsdata_out, EX_WB_regWrite_out, EX_WB_write_mux_out);
    end

endmodule
