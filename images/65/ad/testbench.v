`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg clk;
    wire [15:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .clk(clk),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        A = 4'd0;


        repeat(5) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Input A = 0 (Expected bit 0 is LOW)");
        reset_dut();
        A = 4'd0;

        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Input A = 15 (Expected bit 15 is LOW)");
        reset_dut();
        A = 4'd15;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(16'h7FFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Input A = 8 (Expected bit 8 is LOW)");
        reset_dut();
        A = 4'd8;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFEFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Input A = 4 (Expected bit 4 is LOW)");
        reset_dut();
        A = 4'd4;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFFEF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Input A = 1 (Expected bit 1 is LOW)");
        reset_dut();
        A = 4'd1;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFFFD);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Input A = 10 (Expected bit 10 is LOW)");
        reset_dut();
        A = 4'd10;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFBFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Input A = 7 (Expected bit 7 is LOW)");
        reset_dut();
        A = 4'd7;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFF7F);
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
        input [15:0] expected_Y;
        begin
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
        $dumpvars(0,A, clk, Y);
    end

endmodule
