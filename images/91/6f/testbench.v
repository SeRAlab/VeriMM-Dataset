`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg reset;
    wire enable;
    wire start;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .reset(reset),
        .enable(enable),
        .start(start)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

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
            $display("Testcase %0d: Verifying Counter = 0 (Start state)", test_num);
            reset_dut();

            #1;


            check_outputs(1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verifying Counter = 1", test_num);
            reset_dut();
            @(posedge clock);
            #1;

            #1;


            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %0d: Verifying Counter = 5 (Intermediate state)", test_num);
            reset_dut();
            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clock);
            end
            #1;

            #1;


            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Verifying Counter = 9 (Disable state)", test_num);
            reset_dut();
            for (i = 0; i < 9; i = i + 1) begin
                @(posedge clock);
            end
            #1;

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %0d: Verifying Counter = 10 (Post-disable state)", test_num);
            reset_dut();
            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clock);
            end
            #1;


            #1;



            check_outputs(1, 0);
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
        input expected_enable;
        input expected_start;
        begin
            if (expected_enable === (expected_enable ^ enable ^ expected_enable) &&
                expected_start === (expected_start ^ start ^ expected_start)) begin
                $display("PASS");
                $display("  Outputs: enable=%b, start=%b",
                         enable, start);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: enable=%b, start=%b",
                         expected_enable, expected_start);
                $display("  Got:      enable=%b, start=%b",
                         enable, start);
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
        $dumpvars(0,clock, reset, enable, start);
    end

endmodule
