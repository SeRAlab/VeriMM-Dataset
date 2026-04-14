`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] A_mul_src1;
    reg [31:0] A_mul_src2;
    reg clk;
    reg reset_n;
    wire [31:0] A_mul_cell_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A_mul_src1(A_mul_src1),
        .A_mul_src2(A_mul_src2),
        .clk(clk),
        .reset_n(reset_n),
        .A_mul_cell_result(A_mul_cell_result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n = 0;
        A_mul_src1 = 0;
        A_mul_src2 = 0;
        @(posedge clk);
        #1;
        reset_n = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("\nRunning Testcase 001: Zero inputs...");
        reset_dut();
        A_mul_src1 = 32'h0000_0000;
        A_mul_src2 = 32'h0000_0000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning Testcase 002: Lower half 1*1, Upper half 0...");
        reset_dut();
        A_mul_src1 = 32'h0000_0001;
        A_mul_src2 = 32'h0000_0001;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h0000_0001);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning Testcase 003: Lower half 0, Upper half 1*1...");
        reset_dut();
        A_mul_src1 = 32'h0001_0000;
        A_mul_src2 = 32'h0001_0000;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h0000_0001);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning Testcase 004: Mixed halves (2,3) * (4,5)...");
        reset_dut();
        A_mul_src1 = 32'h0002_0003;
        A_mul_src2 = 32'h0004_0005;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h0000_0017);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning Testcase 005: Max 16-bit values multiplied by 1...");
        reset_dut();
        A_mul_src1 = 32'hFFFF_FFFF;
        A_mul_src2 = 32'h0001_0001;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h0001_FFFE);
    end
        endtask

    task testcase006;

    begin
        $display("\nRunning Testcase 006: Max 16-bit product overflow...");
        reset_dut();
        A_mul_src1 = 32'hFFFF_FFFF;
        A_mul_src2 = 32'hFFFF_FFFF;
        @(posedge clk);
        #1;




        #1;





        check_outputs(32'hFFFC0002);
    end
        endtask

    task testcase007;

    begin
        $display("\nRunning Testcase 007: Reset check during operation...");
        reset_dut();
        A_mul_src1 = 32'h1234_5678;
        A_mul_src2 = 32'h1111_1111;
        @(posedge clk);
        #1;

        if (A_mul_cell_result == 0) $display("Warning: Output should be non-zero before reset test.");


        reset_n = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0000_0000);
        reset_n = 1;
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
        input [31:0] expected_A_mul_cell_result;
        begin
            if (expected_A_mul_cell_result === (expected_A_mul_cell_result ^ A_mul_cell_result ^ expected_A_mul_cell_result)) begin
                $display("PASS");
                $display("  Outputs: A_mul_cell_result=%h",
                         A_mul_cell_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_mul_cell_result=%h",
                         expected_A_mul_cell_result);
                $display("  Got:      A_mul_cell_result=%h",
                         A_mul_cell_result);
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
        $dumpvars(0,A_mul_src1, A_mul_src2, clk, reset_n, A_mul_cell_result);
    end

endmodule
