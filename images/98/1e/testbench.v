`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in1_0;
    reg in1_1;
    reg in2_0;
    reg in2_1;
    reg req;
    reg sel0;
    reg sel1;
    wire ack;
    wire q0;
    wire q1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in1_0(in1_0),
        .in1_1(in1_1),
        .in2_0(in2_0),
        .in2_1(in2_1),
        .req(req),
        .sel0(sel0),
        .sel1(sel1),
        .ack(ack),
        .q0(q0),
        .q1(q1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        in1_0 = 0;
        in1_1 = 0;
        in2_0 = 0;
        in2_1 = 0;
        sel0 = 0;
        sel1 = 0;
        req = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Test Case 001: Select bits from Source 1 (sel0=0, sel1=0)");
        in1_0 = 1; in1_1 = 1;
        in2_0 = 0; in2_1 = 0;
        sel0 = 0; sel1 = 0;
        req = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Test Case 002: Select bits from Source 2 (sel0=1, sel1=1)");
        in1_0 = 1; in1_1 = 1;
        in2_0 = 0; in2_1 = 0;
        sel0 = 1; sel1 = 1;
        req = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Test Case 003: Mixed Selection (sel0=0, sel1=1)");
        in1_0 = 1; in1_1 = 0;
        in2_0 = 0; in2_1 = 1;
        sel0 = 0; sel1 = 1;
        req = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Test Case 004: Mixed Selection (sel0=1, sel1=0)");
        in1_0 = 1; in1_1 = 0;
        in2_0 = 0; in2_1 = 1;
        sel0 = 1; sel1 = 0;
        req = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Test Case 005: No request (req=0)");
        in1_0 = 1; in1_1 = 1;
        in2_0 = 1; in2_1 = 1;
        sel0 = 0; sel1 = 0;
        req = 0;
        @(posedge clk);
        #2;


        #1;



        check_outputs(1'b0, q0, q1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        $display("Test Case 006: Data latching verification");
        in1_0 = 1; in1_1 = 0;
        sel0 = 0; sel1 = 0;
        req = 1;
        @(posedge clk);
        #1;

        in1_0 = 0; in1_1 = 1;
        #1;
        #1;

        check_outputs(1'b1, 1'b1, 1'b0);
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
        input expected_ack;
        input expected_q0;
        input expected_q1;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_q0 === (expected_q0 ^ q0 ^ expected_q0) &&
                expected_q1 === (expected_q1 ^ q1 ^ expected_q1)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, q0=%b, q1=%b",
                         ack, q0, q1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, q0=%b, q1=%b",
                         expected_ack, expected_q0, expected_q1);
                $display("  Got:      ack=%b, q0=%b, q1=%b",
                         ack, q0, q1);
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
        $dumpvars(0,clk, in1_0, in1_1, in2_0, in2_1, req, sel0, sel1, ack, q0, q1);
    end

endmodule
