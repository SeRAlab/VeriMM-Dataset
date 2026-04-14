`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg d;
    reg rxClk;
    reg rxReset;
    reg s;
    wire [1:0] dq;
    wire dqValid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .rxClk(rxClk),
        .rxReset(rxReset),
        .s(s),
        .dq(dq),
        .dqValid(dqValid)
    );

    // Clock generation (10ns period)
    initial begin
        rxClk = 0;
        forever #5 rxClk = ~rxClk;
    end

        task reset_dut;

    begin
        rxReset = 1;
        d = 0;
        s = 0;
        @(posedge rxClk);
        #2;
        rxReset = 0;
        @(posedge rxClk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(2'b00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        d = 1;
        @(posedge rxClk); #1;
        s = 1;
        @(posedge rxClk); #1;
        s = 0;
        @(posedge rxClk); #1;
        repeat(2) @(posedge rxClk);
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        d = 0;
        @(posedge rxClk); #1;
        s = 1;
        @(posedge rxClk); #1;
        s = 0;
        @(posedge rxClk); #1;
        repeat(2) @(posedge rxClk);
        #1;

        check_outputs(2'b00, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        d = 0;
        @(posedge rxClk); #1;
        s = 1;
        @(posedge rxClk); #1;
        d = 1;
        @(posedge rxClk); #1;
        s = 0;
        @(posedge rxClk); #1;
        repeat(2) @(posedge rxClk);


        #1;



        check_outputs(2'b10, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        d = 1;
        @(posedge rxClk); #1;
        s = 1;
        @(posedge rxClk); #1;
        d = 0;
        @(posedge rxClk); #1;
        s = 0;
        @(posedge rxClk); #1;
        repeat(2) @(posedge rxClk);
        #1;

        check_outputs(2'b01, 1'b1);
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
        input [1:0] expected_dq;
        input expected_dqValid;
        begin
            if (expected_dq === (expected_dq ^ dq ^ expected_dq) &&
                expected_dqValid === (expected_dqValid ^ dqValid ^ expected_dqValid)) begin
                $display("PASS");
                $display("  Outputs: dq=%h, dqValid=%b",
                         dq, dqValid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dq=%h, dqValid=%b",
                         expected_dq, expected_dqValid);
                $display("  Got:      dq=%h, dqValid=%b",
                         dq, dqValid);
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
        $dumpvars(0,d, rxClk, rxReset, s, dq, dqValid);
    end

endmodule
