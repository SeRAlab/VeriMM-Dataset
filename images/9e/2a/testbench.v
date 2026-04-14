`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg signal_in;
    wire signal_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .signal_in(signal_in),
        .signal_out(signal_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            signal_in = 0;
            repeat(DEBOUNCE_LIMIT + 5) @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %03d: Valid Low to High transition", test_num);
            signal_in = 1;
            repeat(DEBOUNCE_LIMIT + 5) @(posedge clock);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            signal_in = 1;
            repeat(DEBOUNCE_LIMIT + 5) @(posedge clock);

            $display("Testcase %03d: Valid High to Low transition", test_num);
            signal_in = 0;
            repeat(DEBOUNCE_LIMIT + 5) @(posedge clock);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %03d: Filter short high glitch (5 cycles)", test_num);
            signal_in = 1;
            repeat(5) @(posedge clock);
            signal_in = 0;
            repeat(DEBOUNCE_LIMIT + 5) @(posedge clock);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            signal_in = 1;
            repeat(DEBOUNCE_LIMIT + 5) @(posedge clock);

            $display("Testcase %03d: Filter short low glitch (5 cycles) while High", test_num);
            signal_in = 0;
            repeat(5) @(posedge clock);
            signal_in = 1;
            repeat(DEBOUNCE_LIMIT + 5) @(posedge clock);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %03d: Multiple bounces before stabilizing High", test_num);
            signal_in = 1; repeat(3) @(posedge clock);
            signal_in = 0; repeat(2) @(posedge clock);
            signal_in = 1; repeat(4) @(posedge clock);
            signal_in = 0; repeat(2) @(posedge clock);

            signal_in = 1;
            repeat(DEBOUNCE_LIMIT + 5) @(posedge clock);
            #1;

            check_outputs(1'b1);
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
        input expected_signal_out;
        begin
            if (expected_signal_out === (expected_signal_out ^ signal_out ^ expected_signal_out)) begin
                $display("PASS");
                $display("  Outputs: signal_out=%b",
                         signal_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: signal_out=%b",
                         expected_signal_out);
                $display("  Got:      signal_out=%b",
                         signal_out);
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
        $dumpvars(0,clock, signal_in, signal_out);
    end

endmodule
