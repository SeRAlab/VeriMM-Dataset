`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] D;
    reg LD;
    reg SH;
    reg clk;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .LD(LD),
        .SH(SH),
        .clk(clk),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            LD <= 1;
            SH <= 0;
            D  <= 4'b0000;
            @(posedge clk);
            #1;
            LD <= 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Parallel Load 4'b1010");
            reset_dut();
            D  <= 4'b1010;
            LD <= 1;
            SH <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Shift Right (1000 -> 0100)");
            reset_dut();

            D  <= 4'b1000;
            LD <= 1;
            SH <= 0;
            @(posedge clk);
            #1;

            LD <= 0;
            SH <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Double Shift (1111 -> 0111 -> 0011)");
            reset_dut();
            D <= 4'b1111;
            LD <= 1; @(posedge clk); #1;
            LD <= 0; SH <= 1; @(posedge clk); #1;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Hold State");
            reset_dut();
            D <= 4'b0110;
            LD <= 1; @(posedge clk); #1;
            LD <= 0; SH <= 0;
            @(posedge clk); #1;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Shift until empty (0001 -> 0000)");
            reset_dut();
            D <= 4'b0001;
            LD <= 1; @(posedge clk); #1;
            LD <= 0; SH <= 1; @(posedge clk); #1;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Priority (LD and SH both high)");
            reset_dut();
            D <= 4'b1100;
            LD <= 1;
            SH <= 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1100);
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, LD, SH, clk, Q);
    end

endmodule
