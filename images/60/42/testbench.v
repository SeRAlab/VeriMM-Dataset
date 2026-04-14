`timescale 1ns/1ps

module reset_sequential_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg reset;
    wire m;
    wire n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reset_sequential_module dut (
        .clock(clock),
        .reset(reset),
        .m(m),
        .n(n)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task apply_reset_pulse;

        begin
            reset = 1;
            @(posedge clock);
            #1;
            reset = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Running Test Case 001: First reset pulse...");
            reset_dut();
            apply_reset_pulse();
            #1;

            check_outputs(1'b0, 1'bx);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Test Case 002: Second reset pulse...");
            apply_reset_pulse();
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Test Case 003: Third reset pulse...");
            apply_reset_pulse();
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Test Case 004: Fourth reset pulse...");
            apply_reset_pulse();
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Test Case 005: Fifth reset pulse...");
            apply_reset_pulse();
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reset_sequential_module Testbench");
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
        input expected_m;
        input expected_n;
        begin
            if (expected_m === (expected_m ^ m ^ expected_m) &&
                expected_n === (expected_n ^ n ^ expected_n)) begin
                $display("PASS");
                $display("  Outputs: m=%b, n=%b",
                         m, n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m=%b, n=%b",
                         expected_m, expected_n);
                $display("  Got:      m=%b, n=%b",
                         m, n);
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
        $dumpvars(0,clock, reset, m, n);
    end

endmodule
