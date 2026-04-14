`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] InsTag_NormaliseSum;
    reg NatLogFlagout_NormaliseSum;
    reg clock;
    reg [1:0] idle_NormaliseSum;
    reg [1:0] modeout_NormaliseSum;
    reg operationout_NormaliseSum;
    reg [31:0] sout_NormaliseSum;
    reg [27:0] sum_NormaliseSum;
    wire [7:0] InsTag_PackSum;
    wire NatLogFlagout_PackSum;
    wire [1:0] modeout_PackSum;
    wire operationout_PackSum;
    wire [31:0] sout_PackSum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .InsTag_NormaliseSum(InsTag_NormaliseSum),
        .NatLogFlagout_NormaliseSum(NatLogFlagout_NormaliseSum),
        .clock(clock),
        .idle_NormaliseSum(idle_NormaliseSum),
        .modeout_NormaliseSum(modeout_NormaliseSum),
        .operationout_NormaliseSum(operationout_NormaliseSum),
        .sout_NormaliseSum(sout_NormaliseSum),
        .sum_NormaliseSum(sum_NormaliseSum),
        .InsTag_PackSum(InsTag_PackSum),
        .NatLogFlagout_PackSum(NatLogFlagout_PackSum),
        .modeout_PackSum(modeout_PackSum),
        .operationout_PackSum(operationout_PackSum),
        .sout_PackSum(sout_PackSum)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            idle_NormaliseSum = 0;
            sout_NormaliseSum = 0;
            modeout_NormaliseSum = 0;
            operationout_NormaliseSum = 0;
            NatLogFlagout_NormaliseSum = 0;
            sum_NormaliseSum = 0;
            InsTag_NormaliseSum = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case 001: Basic Data Pass-through");
            idle_NormaliseSum = 2'b01;
            sout_NormaliseSum = 32'h3F800000;
            modeout_NormaliseSum = 2'b11;
            operationout_NormaliseSum = 1'b0;
            NatLogFlagout_NormaliseSum = 1'b1;
            sum_NormaliseSum = 28'h0000000;
            InsTag_NormaliseSum = 8'hA5;

            @(posedge clock);
            #2;


            #1;



            check_outputs(8'hA5, 1'b1, 2'b11, 1'b0, 32'h3F800000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case 002: Maximum Values");
            idle_NormaliseSum = 2'b11;
            sout_NormaliseSum = 32'hFFFFFFFF;
            modeout_NormaliseSum = 2'b11;
            operationout_NormaliseSum = 1'b1;
            NatLogFlagout_NormaliseSum = 1'b1;
            sum_NormaliseSum = 28'hFFFFFFF;
            InsTag_NormaliseSum = 8'hFF;

            @(posedge clock);
            #2;
            #1;

            check_outputs(8'hFF, 1'b1, 2'b11, 1'b1, 32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case 003: Minimum Values");
            idle_NormaliseSum = 2'b00;
            sout_NormaliseSum = 32'h00000000;
            modeout_NormaliseSum = 2'b00;
            operationout_NormaliseSum = 1'b0;
            NatLogFlagout_NormaliseSum = 1'b0;
            sum_NormaliseSum = 28'h0000000;
            InsTag_NormaliseSum = 8'h00;

            @(posedge clock);
            #2;
            #1;

            check_outputs(8'h00, 1'b0, 2'b00, 1'b0, 32'h00000000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case 004: Alternating Patterns");
            idle_NormaliseSum = 2'b10;
            sout_NormaliseSum = 32'hAAAAAAAA;
            modeout_NormaliseSum = 2'b01;
            operationout_NormaliseSum = 1'b1;
            NatLogFlagout_NormaliseSum = 1'b0;
            sum_NormaliseSum = 28'h5555555;
            InsTag_NormaliseSum = 8'h5A;

            @(posedge clock);
            #2;
            #1;

            check_outputs(8'h5A, 1'b0, 2'b01, 1'b1, 32'hAAAAAAAA);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case 005: Control Signal Toggles");
            idle_NormaliseSum = 2'b10;
            sout_NormaliseSum = 32'h12345678;
            modeout_NormaliseSum = 2'b10;
            operationout_NormaliseSum = 1'b1;
            NatLogFlagout_NormaliseSum = 1'b1;
            sum_NormaliseSum = 28'h7654321;
            InsTag_NormaliseSum = 8'h42;

            @(posedge clock);
            #2;
            #1;

            check_outputs(8'h42, 1'b1, 2'b10, 1'b1, 32'h12345678);
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
        input [7:0] expected_InsTag_PackSum;
        input expected_NatLogFlagout_PackSum;
        input [1:0] expected_modeout_PackSum;
        input expected_operationout_PackSum;
        input [31:0] expected_sout_PackSum;
        begin
            if (expected_InsTag_PackSum === (expected_InsTag_PackSum ^ InsTag_PackSum ^ expected_InsTag_PackSum) &&
                expected_NatLogFlagout_PackSum === (expected_NatLogFlagout_PackSum ^ NatLogFlagout_PackSum ^ expected_NatLogFlagout_PackSum) &&
                expected_modeout_PackSum === (expected_modeout_PackSum ^ modeout_PackSum ^ expected_modeout_PackSum) &&
                expected_operationout_PackSum === (expected_operationout_PackSum ^ operationout_PackSum ^ expected_operationout_PackSum) &&
                expected_sout_PackSum === (expected_sout_PackSum ^ sout_PackSum ^ expected_sout_PackSum)) begin
                $display("PASS");
                $display("  Outputs: InsTag_PackSum=%h, NatLogFlagout_PackSum=%b, modeout_PackSum=%h, operationout_PackSum=%b, sout_PackSum=%h",
                         InsTag_PackSum, NatLogFlagout_PackSum, modeout_PackSum, operationout_PackSum, sout_PackSum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: InsTag_PackSum=%h, NatLogFlagout_PackSum=%b, modeout_PackSum=%h, operationout_PackSum=%b, sout_PackSum=%h",
                         expected_InsTag_PackSum, expected_NatLogFlagout_PackSum, expected_modeout_PackSum, expected_operationout_PackSum, expected_sout_PackSum);
                $display("  Got:      InsTag_PackSum=%h, NatLogFlagout_PackSum=%b, modeout_PackSum=%h, operationout_PackSum=%b, sout_PackSum=%h",
                         InsTag_PackSum, NatLogFlagout_PackSum, modeout_PackSum, operationout_PackSum, sout_PackSum);
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
        $dumpvars(0,InsTag_NormaliseSum, NatLogFlagout_NormaliseSum, clock, idle_NormaliseSum, modeout_NormaliseSum, operationout_NormaliseSum, sout_NormaliseSum, sum_NormaliseSum, InsTag_PackSum, NatLogFlagout_PackSum, modeout_PackSum, operationout_PackSum, sout_PackSum);
    end

endmodule
