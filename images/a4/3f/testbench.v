`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in;
    reg reset;
    wire [6:0] seg_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .seg_out(seg_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 4'b0000;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Correct Sequence '1100'");
            reset_dut();
            in = 4'b1100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'h06);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Incorrect Sequence '0000'");
            reset_dut();
            in = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'h3F);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Incorrect Sequence '1111'");
            reset_dut();
            in = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'h3F);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Partial Match '1101'");
            reset_dut();
            in = 4'b1101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'h3F);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Incorrect Sequence '0110'");
            reset_dut();
            in = 4'b0110;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'h3F);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Detection immediately after Reset");
            reset_dut();
            in = 4'b1100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'h06);
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
        input [6:0] expected_seg_out;
        begin
            if (expected_seg_out === (expected_seg_out ^ seg_out ^ expected_seg_out)) begin
                $display("PASS");
                $display("  Outputs: seg_out=%h",
                         seg_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg_out=%h",
                         expected_seg_out);
                $display("  Got:      seg_out=%h",
                         seg_out);
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
        $dumpvars(0,clk, in, reset, seg_out);
    end

endmodule
