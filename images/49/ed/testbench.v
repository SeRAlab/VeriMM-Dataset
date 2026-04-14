`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLOCKENABLE;
    reg INPUTCLK;
    reg LATCHINPUTVALUE;
    reg PARALLELLOAD;
    reg SERIALIN;
    wire [7:0] Q;
    wire SERIALOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLOCKENABLE(CLOCKENABLE),
        .INPUTCLK(INPUTCLK),
        .LATCHINPUTVALUE(LATCHINPUTVALUE),
        .PARALLELLOAD(PARALLELLOAD),
        .SERIALIN(SERIALIN),
        .Q(Q),
        .SERIALOUT(SERIALOUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLOCKENABLE = 0;
        forever #5 CLOCKENABLE = ~CLOCKENABLE;
    end

        task reset_dut;

    begin
        INPUTCLK = 0;
        LATCHINPUTVALUE = 0;
        PARALLELLOAD = 0;
        SERIALIN = 0;
        @(negedge CLOCKENABLE);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Testcase 001: Parallel Load High");
        PARALLELLOAD = 1;
        SERIALIN = 1;
        INPUTCLK = 1;
        @(posedge CLOCKENABLE);
        #1;


        #1;



        check_outputs(8'hFF, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Testcase 002: Parallel Load Low");
        PARALLELLOAD = 1;
        SERIALIN = 0;
        INPUTCLK = 1;
        @(posedge CLOCKENABLE);
        #1;
        #1;

        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Testcase 003: Latch Serial Input (Shift in 1)");
        LATCHINPUTVALUE = 1;
        SERIALIN = 1;
        INPUTCLK = 1;
        @(posedge CLOCKENABLE);
        #1;

        #1;


        check_outputs(8'h80, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Testcase 004: Multi-bit Serial Shift (101)");
        INPUTCLK = 1;
        LATCHINPUTVALUE = 1;

        SERIALIN = 1; @(posedge CLOCKENABLE); #1;
        SERIALIN = 0; @(posedge CLOCKENABLE); #1;
        SERIALIN = 1; @(posedge CLOCKENABLE); #1;


        #1;



        check_outputs(8'hA0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Testcase 005: Clock Gating (INPUTCLK=0)");


        PARALLELLOAD = 1; SERIALIN = 1; INPUTCLK = 1;
        @(posedge CLOCKENABLE); #1;


        INPUTCLK = 0;
        LATCHINPUTVALUE = 1;
        SERIALIN = 0;
        @(posedge CLOCKENABLE); #1;


        #1;



        check_outputs(8'hFF, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        $display("Testcase 006: Serial Out Check");


        PARALLELLOAD = 1; SERIALIN = 1; INPUTCLK = 1;
        @(posedge CLOCKENABLE); #1;


        PARALLELLOAD = 0;
        LATCHINPUTVALUE = 1;
        SERIALIN = 0;
        repeat (8) @(posedge CLOCKENABLE);
        #1;

        #1;


        check_outputs(8'h00, 1'b0);
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
        input [7:0] expected_Q;
        input expected_SERIALOUT;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_SERIALOUT === (expected_SERIALOUT ^ SERIALOUT ^ expected_SERIALOUT)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, SERIALOUT=%b",
                         Q, SERIALOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, SERIALOUT=%b",
                         expected_Q, expected_SERIALOUT);
                $display("  Got:      Q=%h, SERIALOUT=%b",
                         Q, SERIALOUT);
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
        $dumpvars(0,CLOCKENABLE, INPUTCLK, LATCHINPUTVALUE, PARALLELLOAD, SERIALIN, Q, SERIALOUT);
    end

endmodule
