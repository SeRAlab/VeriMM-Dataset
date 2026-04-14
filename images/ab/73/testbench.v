`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ena;
    wire cycle;
    wire pulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ena(ena),
        .cycle(cycle),
        .pulse(pulse)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ena = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Enable High");
            reset_dut();
            ena = 1;
            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Enable Low");
            reset_dut();
            ena = 0;
            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Transition High to Low");
            reset_dut();
            ena = 1;
            @(posedge clk);
            #1;
            ena = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Pulse Activity Cycle");
            reset_dut();
            ena = 1;
            @(posedge clk);
            #1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Rapid Toggle");
            reset_dut();
            ena = 1;
            @(posedge clk);
            #1;
            ena = 0;
            @(posedge clk);
            #1;
            ena = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1);
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
        input expected_cycle;
        input expected_pulse;
        begin
            if (expected_cycle === (expected_cycle ^ cycle ^ expected_cycle) &&
                expected_pulse === (expected_pulse ^ pulse ^ expected_pulse)) begin
                $display("PASS");
                $display("  Outputs: cycle=%b, pulse=%b",
                         cycle, pulse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cycle=%b, pulse=%b",
                         expected_cycle, expected_pulse);
                $display("  Got:      cycle=%b, pulse=%b",
                         cycle, pulse);
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
        $dumpvars(0,clk, ena, cycle, pulse);
    end

endmodule
