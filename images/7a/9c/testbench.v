`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ain;
    reg clk;
    reg reset;
    wire [3:0] count;
    wire yout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ain(ain),
        .clk(clk),
        .reset(reset),
        .count(count),
        .yout(yout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ain = 0;
            @(posedge clk);
            #1;
            reset = 0;

            ain = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            ain = 1;
            #1;
            $display("Testcase 001: Initial State (S0) after Reset");
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            ain = 1;
            @(posedge clk);
            #1;
            $display("Testcase 002: Transition to S1 (Count 1)");
            #1;

            check_outputs(4'd1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            ain = 1;
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase 003: Transition to S2 (Count 2)");
            #1;

            check_outputs(4'd2, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            ain = 1;
            repeat(3) @(posedge clk);
            #1;
            $display("Testcase 004: Transition to S3 (Count 3)");
            #1;

            check_outputs(4'd3, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            ain = 1;
            repeat(4) @(posedge clk);
            #1;
            $display("Testcase 005: Rollover back to S0 (Count 4)");
            #1;

            check_outputs(4'd4, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            ain = 0;
            @(posedge clk);
            #1;
            $display("Testcase 006: S1 logic with ain=0");
            #1;

            check_outputs(4'd1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            ain = 1;
            repeat(16) @(posedge clk);
            #1;
            $display("Testcase 007: 4-bit Counter Full Rollover (Count 0)");
            #1;

            check_outputs(4'd0, 1'b1);
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
        input [3:0] expected_count;
        input expected_yout;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_yout === (expected_yout ^ yout ^ expected_yout)) begin
                $display("PASS");
                $display("  Outputs: count=%h, yout=%b",
                         count, yout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, yout=%b",
                         expected_count, expected_yout);
                $display("  Got:      count=%h, yout=%b",
                         count, yout);
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
        $dumpvars(0,ain, clk, reset, count, yout);
    end

endmodule
