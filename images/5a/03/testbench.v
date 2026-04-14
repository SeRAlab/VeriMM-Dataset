`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] wrdata;
    reg wrdata_en;
    wire dq;
    wire dq_oe_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .wrdata(wrdata),
        .wrdata_en(wrdata_en),
        .dq(dq),
        .dq_oe_n(dq_oe_n)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        wrdata_en = 0;
        wrdata = 2'b00;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Test Case 001: Idle State Check (wrdata_en=0)");


        #1;



        check_outputs(dq, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Test Case 002: Single Cycle Enable (Check wrdata[0])");
        wrdata = 2'b10;
        wrdata_en = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Test Case 003: Two Cycle Enable (Check wrdata[1])");
        wrdata = 2'b10;
        wrdata_en = 1;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Test Case 004: Three Cycle Enable (Check Toggle Back to bit 0)");
        wrdata = 2'b10;
        wrdata_en = 1;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Test Case 005: Pattern Verification (Check bit 1 of 2'b01)");
        wrdata = 2'b01;
        wrdata_en = 1;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        $display("Test Case 006: Reset Toggle State Check");
        wrdata = 2'b10;
        wrdata_en = 1;
        @(posedge clk);
        wrdata_en = 0;
        @(posedge clk);
        wrdata_en = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b0);
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
        input expected_dq;
        input expected_dq_oe_n;
        begin
            if (expected_dq === (expected_dq ^ dq ^ expected_dq) &&
                expected_dq_oe_n === (expected_dq_oe_n ^ dq_oe_n ^ expected_dq_oe_n)) begin
                $display("PASS");
                $display("  Outputs: dq=%b, dq_oe_n=%b",
                         dq, dq_oe_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dq=%b, dq_oe_n=%b",
                         expected_dq, expected_dq_oe_n);
                $display("  Got:      dq=%b, dq_oe_n=%b",
                         dq, dq_oe_n);
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
        $dumpvars(0,clk, wrdata, wrdata_en, dq, dq_oe_n);
    end

endmodule
