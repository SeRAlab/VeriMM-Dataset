`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a_imag;
    reg [15:0] a_real;
    reg [15:0] b_imag;
    reg [15:0] b_real;
    reg clk;
    reg reset;
    reg start;
    wire done;
    wire [31:0] result_imag;
    wire [31:0] result_real;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_imag(a_imag),
        .a_real(a_real),
        .b_imag(b_imag),
        .b_real(b_real),
        .clk(clk),
        .reset(reset),
        .start(start),
        .done(done),
        .result_imag(result_imag),
        .result_real(result_real)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            a_real = 0;
            a_imag = 0;
            b_real = 0;
            b_imag = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task run_computation;

        input signed [15:0] ar;
        input signed [15:0] ai;
        input signed [15:0] br;
        input signed [15:0] bi;
        begin
            a_real = ar;
            a_imag = ai;
            b_real = br;
            b_imag = bi;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            while (!done) @(posedge clk);

        end
        endtask

    task testcase001;

        begin
            $display("Test Case 001: Zero Inputs");
            reset_dut();
            run_computation(16'sd0, 16'sd0, 16'sd0, 16'sd0);
            #1;

            check_outputs(1'b1, 32'sd0, 32'sd0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Simple Real Multiplication");
            reset_dut();
            run_computation(16'sd10, 16'sd0, 16'sd5, 16'sd0);
            #1;

            check_outputs(1'b1, 32'sd0, 32'sd50);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Simple Complex Multiplication");
            reset_dut();
            run_computation(16'sd2, 16'sd3, 16'sd4, 16'sd5);
            #1;

            check_outputs(1'b1, 32'sd22, -32'sd7);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Negative Numbers");
            reset_dut();
            run_computation(-16'sd10, 16'sd5, 16'sd2, -16'sd3);
            #1;

            check_outputs(1'b1, 32'sd40, -32'sd5);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Pure Imaginary");
            reset_dut();
            run_computation(16'sd0, 16'sd10, 16'sd0, 16'sd10);
            #1;

            check_outputs(1'b1, 32'sd0, -32'sd100);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Max Positive Range");
            reset_dut();
            run_computation(16'sh7FFF, 16'sd0, 16'sd2, 16'sd0);
            #1;

            check_outputs(1'b1, 32'sd0, 32'sd65534);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Large Values with Cross Terms");
            reset_dut();
            run_computation(16'sd1000, 16'sd1000, 16'sd1000, -16'sd1000);
            #1;

            check_outputs(1'b1, 32'sd0, 32'sd2000000);
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
        input expected_done;
        input [31:0] expected_result_imag;
        input [31:0] expected_result_real;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_result_imag === (expected_result_imag ^ result_imag ^ expected_result_imag) &&
                expected_result_real === (expected_result_real ^ result_real ^ expected_result_real)) begin
                $display("PASS");
                $display("  Outputs: done=%b, result_imag=%h, result_real=%h",
                         done, result_imag, result_real);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, result_imag=%h, result_real=%h",
                         expected_done, expected_result_imag, expected_result_real);
                $display("  Got:      done=%b, result_imag=%h, result_real=%h",
                         done, result_imag, result_real);
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
        $dumpvars(0,a_imag, a_real, b_imag, b_real, clk, reset, start, done, result_imag, result_real);
    end

endmodule
