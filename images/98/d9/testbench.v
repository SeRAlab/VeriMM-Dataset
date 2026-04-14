`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    wire out1hz;
    wire out200hz;
    wire out5hz;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .out1hz(out1hz),
        .out200hz(out200hz),
        .out5hz(out5hz)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin


            @(posedge clock);
            current_cycle = current_cycle + 1;
        end
        endtask
    task wait_cycles;

        input integer target;
        begin
            if (target > current_cycle) begin
                repeat(target - current_cycle) @(posedge clock);
                current_cycle = target;
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Checking initial idle state...");
            reset_dut();
            wait_cycles(100);
            #1;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Checking 200Hz pulse at 5ms mark (cycle 500,000)...");

            wait_cycles(499999);
            #1;
            #1;

            check_outputs(0, 1, 0);


            wait_cycles(500000);
            #1;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Checking 5Hz pulse at 200ms mark (cycle 20,000,000)...");

            wait_cycles(19999999);
            #1;
            #1;

            check_outputs(0, 1, 1);

            wait_cycles(20000000);
            #1;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Checking 1Hz pulse at 1s mark (cycle 100,000,000)...");

            wait_cycles(99999999);
            #1;
            #1;

            check_outputs(1, 1, 1);

            wait_cycles(100000000);
            #1;
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
        input expected_out1hz;
        input expected_out200hz;
        input expected_out5hz;
        begin
            if (expected_out1hz === (expected_out1hz ^ out1hz ^ expected_out1hz) &&
                expected_out200hz === (expected_out200hz ^ out200hz ^ expected_out200hz) &&
                expected_out5hz === (expected_out5hz ^ out5hz ^ expected_out5hz)) begin
                $display("PASS");
                $display("  Outputs: out1hz=%b, out200hz=%b, out5hz=%b",
                         out1hz, out200hz, out5hz);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1hz=%b, out200hz=%b, out5hz=%b",
                         expected_out1hz, expected_out200hz, expected_out5hz);
                $display("  Got:      out1hz=%b, out200hz=%b, out5hz=%b",
                         out1hz, out200hz, out5hz);
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
        $dumpvars(0,clock, out1hz, out200hz, out5hz);
    end

endmodule
