`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] input_a;
    reg [3:0] input_b;
    reg [1:0] input_c;
    reg input_d;
    reg reset;
    wire output_a;
    wire output_b;
    wire [1:0] output_c;
    wire [3:0] output_d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input_a(input_a),
        .input_b(input_b),
        .input_c(input_c),
        .input_d(input_d),
        .reset(reset),
        .output_a(output_a),
        .output_b(output_b),
        .output_c(output_c),
        .output_d(output_d)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        input_a = 0;
        input_b = 0;
        input_c = 0;
        input_d = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Testcase 001: Checking Reset state (outputs should be zero)");


        #1;



        check_outputs(1'b0, 1'b0, 2'b00, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Testcase 002: Testing input_a threshold (a=8)");
        input_a = 4'd8;
        input_b = 4'd10;
        input_c = 2'b00;
        input_d = 1'b0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1, 1'b0, 2'b00, 4'b0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Testcase 003: Testing input_b threshold (b=3)");
        input_a = 4'd5;
        input_b = 4'd3;
        input_c = 2'b10;
        input_d = 1'b0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 1'b1, 2'b10, 4'b0100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Testcase 004: Testing input_c and input_d combination");
        input_a = 4'd15;
        input_b = 4'd0;
        input_c = 2'b11;
        input_d = 1'b1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1, 1'b1, 2'b11, 4'b1111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Testcase 005: Mixed status monitoring");
        input_a = 4'd7;
        input_b = 4'd4;
        input_c = 2'b01;
        input_d = 1'b1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 1'b0, 2'b01, 4'b1010);
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
        input expected_output_a;
        input expected_output_b;
        input [1:0] expected_output_c;
        input [3:0] expected_output_d;
        begin
            if (expected_output_a === (expected_output_a ^ output_a ^ expected_output_a) &&
                expected_output_b === (expected_output_b ^ output_b ^ expected_output_b) &&
                expected_output_c === (expected_output_c ^ output_c ^ expected_output_c) &&
                expected_output_d === (expected_output_d ^ output_d ^ expected_output_d)) begin
                $display("PASS");
                $display("  Outputs: output_a=%b, output_b=%b, output_c=%h, output_d=%h",
                         output_a, output_b, output_c, output_d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_a=%b, output_b=%b, output_c=%h, output_d=%h",
                         expected_output_a, expected_output_b, expected_output_c, expected_output_d);
                $display("  Got:      output_a=%b, output_b=%b, output_c=%h, output_d=%h",
                         output_a, output_b, output_c, output_d);
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
        $dumpvars(0,clk, input_a, input_b, input_c, input_d, reset, output_a, output_b, output_c, output_d);
    end

endmodule
