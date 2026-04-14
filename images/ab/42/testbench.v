`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg AR;
    reg CLK;
    reg [22:0] D;
    reg Overflow_flag_A;
    reg Q;
    wire [45:0] Q_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AR(AR),
        .CLK(CLK),
        .D(D),
        .Overflow_flag_A(Overflow_flag_A),
        .Q(Q),
        .Q_reg(Q_reg)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        AR = 1;
        D = 0;
        Q = 0;
        Overflow_flag_A = 0;
        @(posedge CLK);
        #1;
        AR = 0;

        if (Q_reg !== 46'b0) begin
            $display("Reset Failed: Q_reg not cleared");
        end
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Reset Verification");
        reset_dut();
        test_num = 1;
        #1;

        check_outputs(46'h0);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Multiplication with Q=1");
        reset_dut();
        test_num = 2;
        D = 23'h123456;
        Q = 1'b1;
        Overflow_flag_A = 1'b0;
        @(posedge CLK);
        #1;

        #1;


        check_outputs({23'b0, 23'h123456});
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Multiplication with Q=0");
        reset_dut();
        test_num = 3;
        D = 23'h7FFFFF;
        Q = 1'b0;
        Overflow_flag_A = 1'b0;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(46'h0);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Overflow detection");
        reset_dut();
        test_num = 4;
        D = 23'hABCDEF;
        Q = 1'b1;
        Overflow_flag_A = 1'b1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(OVERFLOW_VAL);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Maximum input D value");
        reset_dut();
        test_num = 5;
        D = 23'h7FFFFF;
        Q = 1'b1;
        Overflow_flag_A = 1'b0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs({23'b0, 23'h7FFFFF});
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Reset priority");
        reset_dut();
        test_num = 6;
        D = 23'h111111;
        Q = 1'b1;
        Overflow_flag_A = 1'b1;
        AR = 1'b1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(46'h0);
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
        input [45:0] expected_Q_reg;
        begin
            if (expected_Q_reg === (expected_Q_reg ^ Q_reg ^ expected_Q_reg)) begin
                $display("PASS");
                $display("  Outputs: Q_reg=%h",
                         Q_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q_reg=%h",
                         expected_Q_reg);
                $display("  Got:      Q_reg=%h",
                         Q_reg);
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
        $dumpvars(0,AR, CLK, D, Overflow_flag_A, Q, Q_reg);
    end

endmodule
