`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg X;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .X(X),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            X = 0;
            repeat(3) @(negedge Clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic Sequence 1100");
            test_num = 1;
            reset_dut();
            @(negedge Clk) X = 1;
            @(negedge Clk) X = 1;
            @(negedge Clk) X = 0;
            @(negedge Clk) X = 0;
            @(posedge Clk); #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Incomplete Sequence 110");
            test_num = 2;
            reset_dut();
            @(negedge Clk) X = 1;
            @(negedge Clk) X = 1;
            @(negedge Clk) X = 0;
            @(posedge Clk); #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Leading Zeros 001100");
            test_num = 3;
            reset_dut();
            @(negedge Clk) X = 0;
            @(negedge Clk) X = 0;
            @(negedge Clk) X = 1;
            @(negedge Clk) X = 1;
            @(negedge Clk) X = 0;
            @(negedge Clk) X = 0;
            @(posedge Clk); #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Multiple 1s 111100");
            test_num = 4;
            reset_dut();
            @(negedge Clk) X = 1;
            @(negedge Clk) X = 1;
            @(negedge Clk) X = 1;
            @(negedge Clk) X = 1;
            @(negedge Clk) X = 0;
            @(negedge Clk) X = 0;
            @(posedge Clk); #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Broken Sequence and Recovery");
            test_num = 5;
            reset_dut();
            @(negedge Clk) X = 1;
            @(negedge Clk) X = 1;
            @(negedge Clk) X = 0;
            @(negedge Clk) X = 1;
            @(negedge Clk) X = 1;
            @(negedge Clk) X = 0;
            @(negedge Clk) X = 0;
            @(posedge Clk); #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Continuous Zeros");
            test_num = 6;
            reset_dut();
            @(negedge Clk) X = 0;
            @(negedge Clk) X = 0;
            @(negedge Clk) X = 0;
            @(negedge Clk) X = 0;
            @(posedge Clk); #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Alternating Bits 1010");
            test_num = 7;
            reset_dut();
            @(negedge Clk) X = 1;
            @(negedge Clk) X = 0;
            @(negedge Clk) X = 1;
            @(negedge Clk) X = 0;
            @(posedge Clk); #1;
            #1;

            check_outputs(0);
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
        input expected_Y;
        begin
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
        $dumpvars(0,Clk, X, Y);
    end

endmodule
