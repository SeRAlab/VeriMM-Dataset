`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg reset;
    reg x;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .reset(reset),
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
            reset = 1;
            x = 0;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Initial Reset Check");
            reset_dut();

            #1;


            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Sequence Detection Path (1-1-1)");
            reset_dut();
            x = 1; @(posedge clock);
            x = 1; @(posedge clock);
            x = 1; @(posedge clock);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Return to 0 after sequence");
            reset_dut();

            x = 1; @(posedge clock);
            x = 1; @(posedge clock);
            x = 1; @(posedge clock);

            x = 0; @(posedge clock);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Interrupted Sequence Check");
            reset_dut();
            x = 1; @(posedge clock);
            x = 0; @(posedge clock);
            x = 1; @(posedge clock);
            x = 1; @(posedge clock);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Mid-sequence Reset");
            reset_dut();
            x = 1; @(posedge clock);
            x = 1; @(posedge clock);
            reset = 1; @(posedge clock);
            #1 reset = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: All Zeros Check");
            reset_dut();
            x = 0; @(posedge clock);
            x = 0; @(posedge clock);
            x = 0; @(posedge clock);
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
        $dumpvars(0,clock, reset, x, y);
    end

endmodule
