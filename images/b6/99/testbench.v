`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] wave0;
    reg [9:0] wave1;
    reg [9:0] wave10;
    reg [9:0] wave11;
    reg [9:0] wave12;
    reg [9:0] wave2;
    reg [9:0] wave3;
    reg [9:0] wave4;
    reg [9:0] wave5;
    reg [9:0] wave6;
    reg [9:0] wave7;
    reg [9:0] wave8;
    reg [9:0] wave9;
    wire [13:0] wave;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .wave0(wave0),
        .wave1(wave1),
        .wave10(wave10),
        .wave11(wave11),
        .wave12(wave12),
        .wave2(wave2),
        .wave3(wave3),
        .wave4(wave4),
        .wave5(wave5),
        .wave6(wave6),
        .wave7(wave7),
        .wave8(wave8),
        .wave9(wave9),
        .wave(wave)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: All inputs zero");
            wave0 = 10'd0; wave1 = 10'd0; wave2 = 10'd0; wave3 = 10'd0;
            wave4 = 10'd0; wave5 = 10'd0; wave6 = 10'd0; wave7 = 10'd0;
            wave8 = 10'd0; wave9 = 10'd0; wave10 = 10'd0; wave11 = 10'd0;
            wave12 = 10'd0;
            #1;

            check_outputs(14'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: All inputs maximum (1023)");
            wave0 = 10'd1023; wave1 = 10'd1023; wave2 = 10'd1023; wave3 = 10'd1023;
            wave4 = 10'd1023; wave5 = 10'd1023; wave6 = 10'd1023; wave7 = 10'd1023;
            wave8 = 10'd1023; wave9 = 10'd1023; wave10 = 10'd1023; wave11 = 10'd1023;
            wave12 = 10'd1023;

            #1;


            check_outputs(14'd13299);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Single input non-zero");
            wave0 = 10'd0; wave1 = 10'd0; wave2 = 10'd0; wave3 = 10'd0;
            wave4 = 10'd0; wave5 = 10'd0; wave6 = 10'd0; wave7 = 10'd0;
            wave8 = 10'd0; wave9 = 10'd0; wave10 = 10'd0; wave11 = 10'd0;
            wave12 = 10'd1023;
            #1;

            check_outputs(14'd1023);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Sequential values");
            wave0 = 10'd10; wave1 = 10'd20; wave2 = 10'd30; wave3 = 10'd40;
            wave4 = 10'd50; wave5 = 10'd60; wave6 = 10'd70; wave7 = 10'd80;
            wave8 = 10'd90; wave9 = 10'd100; wave10 = 10'd110; wave11 = 10'd120;
            wave12 = 10'd130;

            #1;


            check_outputs(14'd910);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Mid-point values");
            wave0 = 10'd512; wave1 = 10'd512; wave2 = 10'd512; wave3 = 10'd512;
            wave4 = 10'd512; wave5 = 10'd512; wave6 = 10'd512; wave7 = 10'd512;
            wave8 = 10'd512; wave9 = 10'd512; wave10 = 10'd512; wave11 = 10'd512;
            wave12 = 10'd512;

            #1;


            check_outputs(14'd6656);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Powers of 2 pattern");
            wave0 = 10'd1; wave1 = 10'd2; wave2 = 10'd4; wave3 = 10'd8;
            wave4 = 10'd16; wave5 = 10'd32; wave6 = 10'd64; wave7 = 10'd128;
            wave8 = 10'd256; wave9 = 10'd512; wave10 = 10'd1; wave11 = 10'd1;
            wave12 = 10'd1;

            #1;


            check_outputs(14'd1026);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Large sum check");
            wave0 = 10'd1000; wave1 = 10'd1000; wave2 = 10'd1000; wave3 = 10'd1000;
            wave4 = 10'd1000; wave5 = 10'd1000; wave6 = 10'd1000; wave7 = 10'd1000;
            wave8 = 10'd1000; wave9 = 10'd1000; wave10 = 10'd500; wave11 = 10'd500;
            wave12 = 10'd500;

            #1;


            check_outputs(14'd11500);
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
        input [13:0] expected_wave;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_wave === (expected_wave ^ wave ^ expected_wave)) begin
                $display("PASS");
                $display("  Outputs: wave=%h",
                         wave);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wave=%h",
                         expected_wave);
                $display("  Got:      wave=%h",
                         wave);
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
