`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg SUB;
    reg clk;
    wire [3:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .SUB(SUB),
        .clk(clk),
        .SUM(SUM)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        A = 0;
        B = 0;
        SUB = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        A = 4'd5;
        B = 4'd3;
        SUB = 0;
        @(posedge clk);
        #1;
        $display("Test %0d: Simple Addition (5 + 3)", test_num);
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        A = 4'd10;
        B = 4'd4;
        SUB = 1;
        @(posedge clk);
        #1;
        $display("Test %0d: Simple Subtraction (10 - 4)", test_num);
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        A = 4'd12;
        B = 4'd6;
        SUB = 0;
        @(posedge clk);
        #1;
        $display("Test %0d: Addition with Overflow (12 + 6)", test_num);
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        A = 4'd2;
        B = 4'd5;
        SUB = 1;
        @(posedge clk);
        #1;
        $display("Test %0d: Subtraction with Underflow (2 - 5)", test_num);
        #1;

        check_outputs(4'd13);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        A = 4'hF;
        B = 4'h1;
        SUB = 0;
        @(posedge clk);
        #1;
        $display("Test %0d: Boundary Addition (15 + 1)", test_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        A = 4'h0;
        B = 4'h1;
        SUB = 1;
        @(posedge clk);
        #1;
        $display("Test %0d: Boundary Subtraction (0 - 1)", test_num);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        A = 4'hA;
        B = 4'hA;
        SUB = 1;
        @(posedge clk);
        #1;
        $display("Test %0d: Result Zero (10 - 10)", test_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = test_num + 1;
        A = 4'hF;
        B = 4'hF;
        SUB = 0;
        @(posedge clk);
        #1;
        $display("Test %0d: Max Values Addition (15 + 15)", test_num);
        #1;

        check_outputs(4'd14);
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
        testcase008();
        
        
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
        input [3:0] expected_SUM;
        begin
            if (expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: SUM=%h",
                         SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SUM=%h",
                         expected_SUM);
                $display("  Got:      SUM=%h",
                         SUM);
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
        $dumpvars(0,A, B, SUB, clk, SUM);
    end

endmodule
