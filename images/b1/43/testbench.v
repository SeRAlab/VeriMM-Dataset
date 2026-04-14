`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    reg rst;
    wire [3:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .rst(rst),
        .res(res)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        rst = 1;
        A = 0;
        B = 0;
        @(negedge clk);
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Reset verification");
        reset_dut();
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Single accumulation (A=2, B=3 -> 6)");
        reset_dut();
        A = 4'd2;
        B = 4'd3;
        @(negedge clk);
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Sequence of accumulations (2*2 + 3*1 + 1*1 = 8)");
        reset_dut();
        A = 4'd2; B = 4'd2; @(negedge clk);
        A = 4'd3; B = 4'd1; @(negedge clk);
        A = 4'd1; B = 4'd1; @(negedge clk);
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Accumulation with overflow (8 + 3*4 = 20 -> 4)");
        reset_dut();
        A = 4'd2; B = 4'd4; @(negedge clk);
        A = 4'd3; B = 4'd4; @(negedge clk);
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Accumulating with zero inputs");
        reset_dut();
        A = 4'd5; B = 4'd2; @(negedge clk);
        A = 4'd0; B = 4'd9; @(negedge clk);
        A = 4'd7; B = 4'd0; @(negedge clk);
        #1;

        check_outputs(4'd10);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Max input values (15 * 1 = 15, then + 1*1 = 16 -> 0)");
        reset_dut();
        A = 4'hf; B = 4'h1; @(negedge clk);
        A = 4'h1; B = 4'h1; @(negedge clk);
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Asserting reset after accumulation");
        reset_dut();
        A = 4'd3; B = 4'd3; @(negedge clk);
        @(negedge clk);
        rst = 1;
        @(negedge clk);
        rst = 0;
        #1;

        check_outputs(4'h0);
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
        input [3:0] expected_res;
        begin
            if (expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: res=%h",
                         res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res=%h",
                         expected_res);
                $display("  Got:      res=%h",
                         res);
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
        $dumpvars(0,A, B, clk, rst, res);
    end

endmodule
