`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] a;
    reg [13:0] b;
    reg ce;
    reg clk;
    wire [32:0] p;
    wire [47:0] pcasc;
    wire [1:0] zero_detect;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ce(ce),
        .clk(clk),
        .p(p),
        .pcasc(pcasc),
        .zero_detect(zero_detect)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: a=0, b=50");
            a = 12'd0;
            b = 14'd50;
            ce = 1'b1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(33'd0, 48'd0, 2'b11);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: a=100, b=0");
            a = 12'd100;
            b = 14'd0;
            ce = 1'b1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(33'd0, 48'd0, 2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: a=10, b=20 (p=800)");
            a = 12'd10;
            b = 14'd20;
            ce = 1'b1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(33'd800, 48'd800, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Maximum values");
            a = 12'hFFF;
            b = 14'h3FFF;
            ce = 1'b1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(33'd268353540, 48'd268353540, 2'b00);
        end
        endtask

    task testcase005;

        reg [32:0] prev_p;
        begin
            test_num = 5;
            $display("Test Case 005: Clock Enable Test");

            a = 12'd5;
            b = 14'd5;
            ce = 1'b1;
            repeat(2) @(posedge clk);
            prev_p = p;


            ce = 1'b0;
            a = 12'd100;
            b = 14'd100;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(33'd100, 48'd100, 2'b00);
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
        input [32:0] expected_p;
        input [47:0] expected_pcasc;
        input [1:0] expected_zero_detect;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_p === (expected_p ^ p ^ expected_p) &&
                expected_pcasc === (expected_pcasc ^ pcasc ^ expected_pcasc) &&
                expected_zero_detect === (expected_zero_detect ^ zero_detect ^ expected_zero_detect)) begin
                $display("PASS");
                $display("  Outputs: p=%h, pcasc=%h, zero_detect=%h",
                         p, pcasc, zero_detect);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h, pcasc=%h, zero_detect=%h",
                         expected_p, expected_pcasc, expected_zero_detect);
                $display("  Got:      p=%h, pcasc=%h, zero_detect=%h",
                         p, pcasc, zero_detect);
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

endmodule
