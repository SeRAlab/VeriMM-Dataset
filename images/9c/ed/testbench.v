`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLOCK_50;
    wire [31:0] counter_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLOCK_50(CLOCK_50),
        .counter_out(counter_out)
    );

    // Clock generation (10ns period)
    initial begin
        CLOCK_50 = 0;
        forever #5 CLOCK_50 = ~CLOCK_50;
    end

        task reset_dut;

        begin



            @(posedge CLOCK_50);
            expected_val = expected_val + 1;
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking increment after 10 cycles total...");
            reset_dut();
            repeat(9) @(posedge CLOCK_50);
            expected_val = expected_val + 9;
            #1;
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Checking increment after 50 more cycles...");
            reset_dut();
            repeat(49) @(posedge CLOCK_50);
            expected_val = expected_val + 49;
            #1;
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Checking increment after 100 more cycles...");
            reset_dut();
            repeat(99) @(posedge CLOCK_50);
            expected_val = expected_val + 99;
            #1;
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Checking increment after 1000 more cycles...");
            reset_dut();
            repeat(999) @(posedge CLOCK_50);
            expected_val = expected_val + 999;
            #1;
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Checking increment after 5000 more cycles...");
            reset_dut();
            repeat(4999) @(posedge CLOCK_50);
            expected_val = expected_val + 4999;
            #1;
            #1;

            check_outputs(expected_val);
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
        input [31:0] expected_counter_out;
        begin
            if (expected_counter_out === (expected_counter_out ^ counter_out ^ expected_counter_out)) begin
                $display("PASS");
                $display("  Outputs: counter_out=%h",
                         counter_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_out=%h",
                         expected_counter_out);
                $display("  Got:      counter_out=%h",
                         counter_out);
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
        $dumpvars(0,CLOCK_50, counter_out);
    end

endmodule
