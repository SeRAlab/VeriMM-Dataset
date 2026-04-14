`timescale 1ns/1ps

module sequential_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg rst;
    reg x;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sequential_module dut (
        .clock(clock),
        .rst(rst),
        .x(x),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            rst = 1;
            x = 0;
            @(posedge clock);
            #1;



            rst = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial State / No Toggle");
            reset_dut();
            x = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Toggle 0 -> 1");
            reset_dut();
            x = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Hold State (y=1)");
            reset_dut();

            x = 1;
            @(posedge clock);
            #1;

            x = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Toggle 1 -> 0");
            reset_dut();

            x = 1; @(posedge clock); #1;

            x = 1; @(posedge clock); #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Multiple Toggles (1->0->1)");
            reset_dut();
            x = 1; @(posedge clock); #1;
            x = 1; @(posedge clock); #1;
            x = 1; @(posedge clock); #1;
            #1;

            check_outputs(1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sequential_module Testbench");
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
        input expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
                         y);
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
        $dumpvars(0,clock, rst, x, y);
    end

endmodule
