`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
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
        A = 8'h00;
        B = 8'h00;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        A = 8'h00;
        B = 8'h00;
        @(posedge clk);
        #1;
        $display("Test Case 001: All Zeros (00 & 00)");
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        A = 8'hFF;
        B = 8'hFF;
        @(posedge clk);
        #1;
        $display("Test Case 002: All Ones (FF & FF)");
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        A = 8'hAA;
        B = 8'h55;
        @(posedge clk);
        #1;
        $display("Test Case 003: Complementary Bits (AA & 55)");
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        A = 8'hF0;
        B = 8'hCC;
        @(posedge clk);
        #1;
        $display("Test Case 004: High Nibble Mask (F0 & CC)");
        #1;

        check_outputs(8'hC0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        A = 8'h01;
        B = 8'h01;
        @(posedge clk);
        #1;
        $display("Test Case 005: LSB Match (01 & 01)");
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        A = 8'hA5;
        B = 8'hC3;
        @(posedge clk);
        #1;
        $display("Test Case 006: Random Pattern (A5 & C3)");
        #1;

        check_outputs(8'h81);
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
        input [7:0] expected_Y;
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
        $dumpvars(0,A, B, clk, Y);
    end

endmodule
