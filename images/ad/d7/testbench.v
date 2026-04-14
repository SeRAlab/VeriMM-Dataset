`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg EN;
    reg [3:0] R;
    reg clk;
    wire [6:0] H;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EN(EN),
        .R(R),
        .clk(clk),
        .H(H)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            EN = 0;
            R = 4'b0000;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Test 001: EN=0, Expecting All Segments Off");
            reset_dut();
            test_num = 1;
            EN = 0;
            R = 4'b1111;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(SEG_OFF);
        end
        endtask

    task testcase002;

        begin
            $display("Test 002: EN=1, R=0000, Expecting All Segments Off");
            reset_dut();
            test_num = 2;
            EN = 1;
            R = 4'b0000;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(SEG_OFF);
        end
        endtask

    task testcase003;

        begin
            $display("Test 003: EN=1, R=0001, Expecting Digit 0 (3F)");
            reset_dut();
            test_num = 3;
            EN = 1;
            R = 4'b0001;


            @(posedge clk);
            #1;
            #1;

            check_outputs(SEG_0);
        end
        endtask

    task testcase004;

        begin
            $display("Test 004: EN=1, R=0010, Expecting Digit 1 (06) after skipping 0");
            reset_dut();
            test_num = 4;
            EN = 1;
            R = 4'b0010;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(SEG_1);
        end
        endtask

    task testcase005;

        begin
            $display("Test 005: EN=1, R=0100, Expecting Digit 2 (5B)");
            reset_dut();
            test_num = 5;
            EN = 1;
            R = 4'b0100;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(SEG_2);
        end
        endtask

    task testcase006;

        begin
            $display("Test 006: EN=1, R=1000, Expecting Digit 3 (4F)");
            reset_dut();
            test_num = 6;
            EN = 1;
            R = 4'b1000;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(SEG_3);
        end
        endtask

    task testcase007;

        begin
            $display("Test 007: EN=1, R=1111, Check looping after 4+ cycles");
            reset_dut();
            test_num = 7;
            EN = 1;
            R = 4'b1111;


            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(SEG_0);
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
        input [6:0] expected_H;
        begin
            if (expected_H === (expected_H ^ H ^ expected_H)) begin
                $display("PASS");
                $display("  Outputs: H=%h",
                         H);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: H=%h",
                         expected_H);
                $display("  Got:      H=%h",
                         H);
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
        $dumpvars(0,EN, R, clk, H);
    end

endmodule
