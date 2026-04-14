`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock_in;
    reg [20:0] iHz_in;
    reg reset_n;
    wire clock_div;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock_in(clock_in),
        .iHz_in(iHz_in),
        .reset_n(reset_n),
        .clock_div(clock_div)
    );

    // Clock generation (10ns period)
    initial begin
        clock_in = 0;
        forever #5 clock_in = ~clock_in;
    end

        task reset_dut;

        begin
            reset_n = 0;
            iHz_in = 0;
            repeat(2) @(posedge clock_in);
            #1;
            reset_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: iHz_in = 2 (Divide by 4 total period)", test_num);
            reset_dut();
            iHz_in = 2;


            repeat(4) @(posedge clock_in);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: iHz_in = 5 (Check toggle to high)", test_num);
            reset_dut();
            iHz_in = 5;

            repeat(5) @(posedge clock_in);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: iHz_in = 1 (Toggle every cycle)", test_num);
            reset_dut();
            iHz_in = 1;
            repeat(1) @(posedge clock_in);
            repeat(1) @(posedge clock_in);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Mid-operation reset", test_num);
            reset_dut();
            iHz_in = 100;
            repeat(50) @(posedge clock_in);
            reset_n = 0;
            #20;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Large division factor (iHz_in = 50)", test_num);
            reset_dut();
            iHz_in = 50;
            repeat(50) @(posedge clock_in);
            repeat(50) @(posedge clock_in);
            #1;
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
        input expected_clock_div;
        begin
            if (expected_clock_div === (expected_clock_div ^ clock_div ^ expected_clock_div)) begin
                $display("PASS");
                $display("  Outputs: clock_div=%b",
                         clock_div);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clock_div=%b",
                         expected_clock_div);
                $display("  Got:      clock_div=%b",
                         clock_div);
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
        $dumpvars(0,clock_in, iHz_in, reset_n, clock_div);
    end

endmodule
