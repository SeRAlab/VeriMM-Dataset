`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [125:0] ai;
    reg [125:0] ar;
    reg [125:0] bi;
    reg [125:0] br;
    reg clk;
    reg in_valid;
    reg rst_n;
    wire [125:0] Ci;
    wire [125:0] Cr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ai(ai),
        .ar(ar),
        .bi(bi),
        .br(br),
        .clk(clk),
        .in_valid(in_valid),
        .rst_n(rst_n),
        .Ci(Ci),
        .Cr(Cr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            in_valid = 0;
            ar = 0;
            ai = 0;
            br = 0;
            bi = 0;
            repeat(5) @(posedge clk);
            #1 rst_n = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: All Zeros");
            reset_dut();
            ar = 0; ai = 0; br = 0; bi = 0;
            in_valid = 1;
            @(posedge clk);
            in_valid = 0;
            repeat(15) @(posedge clk);
            #1;

            check_outputs(126'd0, 126'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Real Identity Multiplication");
            reset_dut();
            ar = identity_matrix(14'd1);
            ai = 0;
            br = identity_matrix(14'd1);
            bi = 0;
            in_valid = 1;
            @(posedge clk);
            in_valid = 0;
            repeat(15) @(posedge clk);
            #1;

            check_outputs(126'd0, identity_matrix(14'd1));
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Pure Imaginary Identity Multiplication");
            reset_dut();
            ar = 0;
            ai = identity_matrix(14'd1);
            br = 0;
            bi = identity_matrix(14'd1);
            in_valid = 1;
            @(posedge clk);
            in_valid = 0;
            repeat(15) @(posedge clk);

            #1;


            check_outputs(126'd0, identity_matrix(14'h3FFF));
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Real Scalar Matrices (All 1s * All 2s)");
            reset_dut();
            ar = {9{14'd1}};
            ai = 0;
            br = {9{14'd2}};
            bi = 0;
            in_valid = 1;
            @(posedge clk);
            in_valid = 0;
            repeat(15) @(posedge clk);
            #1;

            check_outputs(126'd0, {9{14'd6}});
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Complex Scalar Matrices (1+i * 1-i)");
            reset_dut();
            ar = {9{14'd1}};
            ai = {9{14'd1}};
            br = {9{14'd1}};
            bi = {9{14'h3FFF}};
            in_valid = 1;
            @(posedge clk);
            in_valid = 0;
            repeat(15) @(posedge clk);
            #1;

            check_outputs({9{14'd0}}, {9{14'd6}});
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
        input [125:0] expected_Ci;
        input [125:0] expected_Cr;
        begin
            if (expected_Ci === (expected_Ci ^ Ci ^ expected_Ci) &&
                expected_Cr === (expected_Cr ^ Cr ^ expected_Cr)) begin
                $display("PASS");
                $display("  Outputs: Ci=%h, Cr=%h",
                         Ci, Cr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Ci=%h, Cr=%h",
                         expected_Ci, expected_Cr);
                $display("  Got:      Ci=%h, Cr=%h",
                         Ci, Cr);
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
        $dumpvars(0,ai, ar, bi, br, clk, in_valid, rst_n, Ci, Cr);
    end

endmodule
