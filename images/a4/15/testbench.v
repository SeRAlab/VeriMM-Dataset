`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in;
    wire falling_edge;
    wire rising_edge;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .falling_edge(falling_edge),
        .rising_edge(rising_edge)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 0;
            @(posedge clk);
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            in = 1;
            @(posedge clk);
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            in = 1;
            @(posedge clk);
            in = 0;
            @(posedge clk);
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            in = 0;
            @(posedge clk);
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            in = 1;
            @(posedge clk);
            in = 1;
            @(posedge clk);
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            in = 1;
            @(posedge clk);
            in = 0;
            @(posedge clk);
            in = 1;
            @(posedge clk);
            #1;

            check_outputs(0, 1);
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
        input expected_falling_edge;
        input expected_rising_edge;
        begin
            if (expected_falling_edge === (expected_falling_edge ^ falling_edge ^ expected_falling_edge) &&
                expected_rising_edge === (expected_rising_edge ^ rising_edge ^ expected_rising_edge)) begin
                $display("PASS");
                $display("  Outputs: falling_edge=%b, rising_edge=%b",
                         falling_edge, rising_edge);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: falling_edge=%b, rising_edge=%b",
                         expected_falling_edge, expected_rising_edge);
                $display("  Got:      falling_edge=%b, rising_edge=%b",
                         falling_edge, rising_edge);
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
        $dumpvars(0,clk, in, falling_edge, rising_edge);
    end

endmodule
