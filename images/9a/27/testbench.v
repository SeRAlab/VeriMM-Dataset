`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [6:0] hours_display;
    wire [6:0] minutes_display;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .hours_display(hours_display),
        .minutes_display(minutes_display)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial Reset to 00:00", test_num);
            reset_dut();
            #1;

            check_outputs(get_seg(0), get_seg(0));
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Increment to 00:01", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(get_seg(0), get_seg(1));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hour Transition (00:59 -> 01:00)", test_num);
            reset_dut();
            repeat(60) @(posedge clk);
            #1;
            #1;

            check_outputs(get_seg(1), get_seg(0));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-day Time (12:34)", test_num);
            reset_dut();
            repeat(12 * 60 + 34) @(posedge clk);
            #1;
            #1;

            check_outputs(get_seg(12), get_seg(34));
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 24-Hour Rollover (23:59 -> 00:00)", test_num);
            reset_dut();
            repeat(24 * 60) @(posedge clk);
            #1;
            #1;

            check_outputs(get_seg(0), get_seg(0));
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
        input [6:0] expected_hours_display;
        input [6:0] expected_minutes_display;
        begin
            if (expected_hours_display === (expected_hours_display ^ hours_display ^ expected_hours_display) &&
                expected_minutes_display === (expected_minutes_display ^ minutes_display ^ expected_minutes_display)) begin
                $display("PASS");
                $display("  Outputs: hours_display=%h, minutes_display=%h",
                         hours_display, minutes_display);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hours_display=%h, minutes_display=%h",
                         expected_hours_display, expected_minutes_display);
                $display("  Got:      hours_display=%h, minutes_display=%h",
                         hours_display, minutes_display);
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
        $dumpvars(0,clk, reset, hours_display, minutes_display);
    end

endmodule
