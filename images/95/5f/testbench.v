`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg reset;
    wire [15:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .reset(reset),
        .P(P)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            A = 0;
            B = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Positive multiplication (12 * 10)");
            reset_dut();
            A = 8'sd12;
            B = 8'sd10;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd120);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Negative * Positive (-10 * 8)");
            reset_dut();
            A = -8'sd10;
            B = 8'sd8;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(-16'sd80);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Positive * Negative (7 * -11)");
            reset_dut();
            A = 8'sd7;
            B = -8'sd11;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(-16'sd77);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Negative * Negative (-6 * -9)");
            reset_dut();
            A = -8'sd6;
            B = -8'sd9;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd54);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Multiply by Zero (0 * -50)");
            reset_dut();
            A = 8'sd0;
            B = -8'sd50;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Max Positive (127 * 127)");
            reset_dut();
            A = 8'sd127;
            B = 8'sd127;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd16129);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Max Negative (-128 * -128)");
            reset_dut();
            A = -8'sd128;
            B = -8'sd128;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd16384);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase 008: Mixed Extremes (-128 * 127)");
            reset_dut();
            A = -8'sd128;
            B = 8'sd127;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(-16'sd16256);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase 009: Identity Negative (-1 * -1)");
            reset_dut();
            A = -8'sd1;
            B = -8'sd1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase 010: Verify Reset behavior");

            A = 8'sd10; B = 8'sd10;
            @(posedge clk);

            reset = 1;
            @(posedge clk);
            @(posedge clk);
            reset = 0;
            #1;

            #1;


            check_outputs(16'h0);
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
        input [15:0] expected_P;
        begin
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
        $dumpvars(0,A, B, clk, reset, P);
    end

endmodule
