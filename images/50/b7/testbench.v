`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg enable;
    reg [8:0] exponent;
    reg [26:0] mantissa;
    reg resetn;
    reg sign;
    reg stall_in;
    reg valid_in;
    wire [31:0] result;
    wire stall_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enable(enable),
        .exponent(exponent),
        .mantissa(mantissa),
        .resetn(resetn),
        .sign(sign),
        .stall_in(stall_in),
        .valid_in(valid_in),
        .result(result),
        .stall_out(stall_out),
        .valid_out(valid_out)
    );
    task testcase001;

    begin
        $display("Test 001: Positive 1.0");
        reset_dut();
        @(posedge clock);
        enable = 1;
        valid_in = 1;
        stall_in = 0;
        sign = 0;
        exponent = 9'd127;
        mantissa = 27'h4000000;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'h3f800000, 0, 1);
    end
        endtask

    task testcase002;

    begin
        $display("Test 002: Negative 2.0");
        reset_dut();
        @(posedge clock);
        enable = 1;
        valid_in = 1;
        stall_in = 0;
        sign = 1;
        exponent = 9'd128;
        mantissa = 27'h4000000;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'hc0000000, 0, 1);
    end
        endtask

    task testcase003;

    begin
        $display("Test 003: Positive 1.5");
        reset_dut();
        @(posedge clock);
        enable = 1;
        valid_in = 1;
        stall_in = 0;
        sign = 0;
        exponent = 9'd127;
        mantissa = 27'h6000000;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'h3fc00000, 0, 1);
    end
        endtask

    task testcase004;

    begin
        $display("Test 004: Zero Value");
        reset_dut();
        @(posedge clock);
        enable = 1;
        valid_in = 1;
        stall_in = 0;
        sign = 0;
        exponent = 9'd0;
        mantissa = 27'h0;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'h00000000, 0, 1);
    end
        endtask

    task testcase005;

    begin
        $display("Test 005: Valid signal flow");
        reset_dut();
        @(posedge clock);
        enable = 1;
        valid_in = 0;
        stall_in = 0;
        sign = 0;
        exponent = 9'd127;
        mantissa = 27'h4000000;
        @(posedge clock);
        #1;

        if (valid_out === 1'b0) begin
            $display("PASS: valid_out is 0");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: valid_out is 1");
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
        input [31:0] expected_result;
        input expected_stall_out;
        input expected_valid_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_stall_out === (expected_stall_out ^ stall_out ^ expected_stall_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: result=%h, stall_out=%b, valid_out=%b",
                         result, stall_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, stall_out=%b, valid_out=%b",
                         expected_result, expected_stall_out, expected_valid_out);
                $display("  Got:      result=%h, stall_out=%b, valid_out=%b",
                         result, stall_out, valid_out);
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

endmodule
