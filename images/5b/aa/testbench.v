`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg idle_NormaliseSum;
    reg [31:0] sout_NormaliseSum;
    reg [27:0] sum_NormaliseSum;
    wire [31:0] sout_PackSum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .idle_NormaliseSum(idle_NormaliseSum),
        .sout_NormaliseSum(sout_NormaliseSum),
        .sum_NormaliseSum(sum_NormaliseSum),
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
        sum_NormaliseSum = 0;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Running Testcase %0d: Idle Pass-through", test_num);
        idle_NormaliseSum = 1;
        sout_NormaliseSum = 32'hDEADBEEF;
        sum_NormaliseSum = 28'hFFFFFFF;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Running Testcase %0d: Normal Packing Positive", test_num);
        idle_NormaliseSum = 0;
        sout_NormaliseSum = 32'h40000000;
        sum_NormaliseSum = 28'h00000008;
        @(posedge clock);
        #1;

        #1;


        check_outputs(32'h40000001);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Running Testcase %0d: Normal Packing Negative", test_num);
        idle_NormaliseSum = 0;
        sout_NormaliseSum = 32'hC0800000;
        sum_NormaliseSum = 28'h00000010;
        @(posedge clock);
        #1;

        #1;


        check_outputs(32'hC0800002);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Running Testcase %0d: Overflow Handling", test_num);
        idle_NormaliseSum = 0;
        sout_NormaliseSum = 32'h7F800000;
        sum_NormaliseSum = 28'h01234560;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Running Testcase %0d: Underflow Handling", test_num);
        idle_NormaliseSum = 0;
        sout_NormaliseSum = 32'h00000000;
        sum_NormaliseSum = 28'h07FFFFF8;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Running Testcase %0d: Boundary Mantissa", test_num);
        idle_NormaliseSum = 0;
        sout_NormaliseSum = 32'h3F800000;
        sum_NormaliseSum = 28'h03FFFFFF;
        @(posedge clock);
        #1;

        #1;


        check_outputs(32'h3FFFFFFF);
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
        input [31:0] expected_sout_PackSum;
        begin
            if (expected_sout_PackSum === (expected_sout_PackSum ^ sout_PackSum ^ expected_sout_PackSum)) begin
                $display("PASS");
                $display("  Outputs: sout_PackSum=%h",
                         sout_PackSum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sout_PackSum=%h",
                         expected_sout_PackSum);
                $display("  Got:      sout_PackSum=%h",
                         sout_PackSum);
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
        $dumpvars(0,clock, idle_NormaliseSum, sout_NormaliseSum, sum_NormaliseSum, sout_PackSum);
    end

endmodule
