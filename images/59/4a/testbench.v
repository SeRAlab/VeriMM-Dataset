`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] input_data;
    wire segA;
    wire segB;
    wire segC;
    wire segD;
    wire segDP;
    wire segE;
    wire segF;
    wire segG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input_data(input_data),
        .segA(segA),
        .segB(segB),
        .segC(segC),
        .segD(segD),
        .segDP(segDP),
        .segE(segE),
        .segF(segF),
        .segG(segG)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            input_data = 4'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            input_data = 4'h0;
            @(posedge clk); #2;
            $display("Test Case 001: Input 0");
            #1;

            check_outputs(0, 0, 0, 0, 1, 0, 0, 1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            input_data = 4'h1;
            @(posedge clk); #2;
            $display("Test Case 002: Input 1");
            #1;

            check_outputs(1, 0, 0, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            input_data = 4'h2;
            @(posedge clk); #2;
            $display("Test Case 003: Input 2");
            #1;

            check_outputs(0, 0, 1, 0, 1, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            input_data = 4'h3;
            @(posedge clk); #2;
            $display("Test Case 004: Input 3");
            #1;

            check_outputs(0, 0, 0, 0, 1, 1, 1, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            input_data = 4'h4;
            @(posedge clk); #2;
            $display("Test Case 005: Input 4");
            #1;

            check_outputs(1, 0, 0, 1, 1, 1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            input_data = 4'h5;
            @(posedge clk); #2;
            $display("Test Case 006: Input 5");
            #1;

            check_outputs(0, 1, 0, 0, 1, 1, 0, 0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            input_data = 4'h6;
            @(posedge clk); #2;
            $display("Test Case 007: Input 6");
            #1;

            check_outputs(0, 1, 0, 0, 1, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            input_data = 4'h7;
            @(posedge clk); #2;
            $display("Test Case 008: Input 7");
            #1;

            check_outputs(0, 0, 0, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            input_data = 4'h8;
            @(posedge clk); #2;
            $display("Test Case 009: Input 8");
            #1;

            check_outputs(0, 0, 0, 0, 1, 0, 0, 0);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            input_data = 4'h9;
            @(posedge clk); #2;
            $display("Test Case 010: Input 9");
            #1;

            check_outputs(0, 0, 0, 0, 1, 1, 0, 0);
        end
        endtask

    task testcase011;

        begin
            reset_dut();
            input_data = 4'hA;
            @(posedge clk); #2;
            $display("Test Case 011: Input A");
            #1;

            check_outputs(0, 0, 0, 1, 1, 0, 0, 0);
        end
        endtask

    task testcase012;

        begin
            reset_dut();
            input_data = 4'hb;
            @(posedge clk); #2;
            $display("Test Case 012: Input B");
            #1;

            check_outputs(1, 1, 0, 0, 1, 0, 0, 0);
        end
        endtask

    task testcase013;

        begin
            reset_dut();
            input_data = 4'hC;
            @(posedge clk); #2;
            $display("Test Case 013: Input C");
            #1;

            check_outputs(0, 1, 1, 0, 1, 0, 0, 1);
        end
        endtask

    task testcase014;

        begin
            reset_dut();
            input_data = 4'hd;
            @(posedge clk); #2;
            $display("Test Case 014: Input D");
            #1;

            check_outputs(1, 0, 0, 0, 1, 0, 1, 0);
        end
        endtask

    task testcase015;

        begin
            reset_dut();
            input_data = 4'hE;
            @(posedge clk); #2;
            $display("Test Case 015: Input E");
            #1;

            check_outputs(0, 1, 1, 0, 1, 0, 0, 0);
        end
        endtask

    task testcase016;

        begin
            reset_dut();
            input_data = 4'hF;
            @(posedge clk); #2;
            $display("Test Case 016: Input F");
            #1;

            check_outputs(0, 1, 1, 1, 1, 0, 0, 0);
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_segA;
        input expected_segB;
        input expected_segC;
        input expected_segD;
        input expected_segDP;
        input expected_segE;
        input expected_segF;
        input expected_segG;
        begin
            if (expected_segA === (expected_segA ^ segA ^ expected_segA) &&
                expected_segB === (expected_segB ^ segB ^ expected_segB) &&
                expected_segC === (expected_segC ^ segC ^ expected_segC) &&
                expected_segD === (expected_segD ^ segD ^ expected_segD) &&
                expected_segDP === (expected_segDP ^ segDP ^ expected_segDP) &&
                expected_segE === (expected_segE ^ segE ^ expected_segE) &&
                expected_segF === (expected_segF ^ segF ^ expected_segF) &&
                expected_segG === (expected_segG ^ segG ^ expected_segG)) begin
                $display("PASS");
                $display("  Outputs: segA=%b, segB=%b, segC=%b, segD=%b, segDP=%b, segE=%b, segF=%b, segG=%b",
                         segA, segB, segC, segD, segDP, segE, segF, segG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: segA=%b, segB=%b, segC=%b, segD=%b, segDP=%b, segE=%b, segF=%b, segG=%b",
                         expected_segA, expected_segB, expected_segC, expected_segD, expected_segDP, expected_segE, expected_segF, expected_segG);
                $display("  Got:      segA=%b, segB=%b, segC=%b, segD=%b, segDP=%b, segE=%b, segF=%b, segG=%b",
                         segA, segB, segC, segD, segDP, segE, segF, segG);
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
        $dumpvars(0,clk, input_data, segA, segB, segC, segD, segDP, segE, segF, segG);
    end

endmodule
