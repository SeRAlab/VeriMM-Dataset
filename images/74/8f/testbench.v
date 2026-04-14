`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg reset;
    reg sysclk;
    wire [6:0] egg_timer;
    wire selection;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .reset(reset),
        .sysclk(sysclk),
        .egg_timer(egg_timer),
        .selection(selection)
    );

    // Clock generation (10ns period)
    initial begin
        sysclk = 0;
        forever #5 sysclk = ~sysclk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge sysclk);
            #1;
            reset = 0;
            @(posedge sysclk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Post-Reset Initialization...");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(7'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: First Toggle Pulse...");
            test_num = 2;
            reset_dut();

            wait(egg_timer == 7'h7F);
            #1;

            #1;


            check_outputs(7'h7F, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Post-Toggle State...");
            test_num = 3;
            reset_dut();
            wait(egg_timer == 7'h7F);
            @(posedge sysclk);
            #1;

            #1;


            check_outputs(7'h0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Second Toggle Event...");
            test_num = 4;
            reset_dut();

            wait(egg_timer == 7'h7F);
            @(posedge sysclk);

            wait(egg_timer == 7'h7F);
            #1;

            #1;


            check_outputs(7'h7F, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Reset during active selection...");
            test_num = 5;
            reset_dut();

            wait(egg_timer == 7'h7F);
            @(posedge sysclk);
            #1;

            reset = 1;
            @(posedge sysclk);
            #1;
            reset = 0;
            #1;

            #1;


            check_outputs(7'h0, 1'b0);
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
        input [6:0] expected_egg_timer;
        input expected_selection;
        begin
            if (expected_egg_timer === (expected_egg_timer ^ egg_timer ^ expected_egg_timer) &&
                expected_selection === (expected_selection ^ selection ^ expected_selection)) begin
                $display("PASS");
                $display("  Outputs: egg_timer=%h, selection=%b",
                         egg_timer, selection);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: egg_timer=%h, selection=%b",
                         expected_egg_timer, expected_selection);
                $display("  Got:      egg_timer=%h, selection=%b",
                         egg_timer, selection);
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
        $dumpvars(0,reset, sysclk, egg_timer, selection);
    end

endmodule
