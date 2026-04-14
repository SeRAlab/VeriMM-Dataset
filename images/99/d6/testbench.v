`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    wire q0;
    wire q1;
    wire q2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .q0(q0),
        .q1(q1),
        .q2(q2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            #10;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset logic check");
            reset_dut();

            #1;


            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: First increment check (000 -> 001)");
            reset_dut();
            @(posedge clk);
            enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Three increments check (000 -> 010 Gray)");
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Full cycle increment check (7 steps)");
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat(7) @(posedge clk);
            #1;


            #1;



            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Wrap-around check (8 increments)");
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat(8) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Enable signal logic check");
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat(2) @(posedge clk);
            @(posedge clk);
            enable = 0;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(1, 1, 0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Asynchronous reset mid-count");
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat(4) @(posedge clk);
            #2;
            reset = 1;
            #2;

            #1;


            check_outputs(0, 0, 0);
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
        input expected_q0;
        input expected_q1;
        input expected_q2;
        begin
            if (expected_q0 === (expected_q0 ^ q0 ^ expected_q0) &&
                expected_q1 === (expected_q1 ^ q1 ^ expected_q1) &&
                expected_q2 === (expected_q2 ^ q2 ^ expected_q2)) begin
                $display("PASS");
                $display("  Outputs: q0=%b, q1=%b, q2=%b",
                         q0, q1, q2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q0=%b, q1=%b, q2=%b",
                         expected_q0, expected_q1, expected_q2);
                $display("  Got:      q0=%b, q1=%b, q2=%b",
                         q0, q1, q2);
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
        $dumpvars(0,clk, enable, reset, q0, q1, q2);
    end

endmodule
