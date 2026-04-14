`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg load;
    wire [3:0] count_out;
    wire max_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .load(load),
        .count_out(count_out),
        .max_count(max_count)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(negedge clock);
            load = 1;
            @(negedge clock);
            load = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset check", test_num);
            reset_dut();

            #1;


            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Increment to 7", test_num);
            reset_dut();
            repeat(7) @(negedge clock);
            #1;

            check_outputs(4'd7, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Reach maximum count (15)", test_num);
            reset_dut();
            repeat(15) @(negedge clock);
            #1;

            check_outputs(4'd15, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Overflow/Rollover check", test_num);
            reset_dut();
            repeat(16) @(negedge clock);

            #1;


            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Synchronous load mid-sequence", test_num);
            reset_dut();
            repeat(10) @(negedge clock);

            @(negedge clock);
            load = 1;
            @(negedge clock);
            load = 0;
            #1;

            check_outputs(4'd0, 1'b0);
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
        input [3:0] expected_count_out;
        input expected_max_count;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out) &&
                expected_max_count === (expected_max_count ^ max_count ^ expected_max_count)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h, max_count=%b",
                         count_out, max_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h, max_count=%b",
                         expected_count_out, expected_max_count);
                $display("  Got:      count_out=%h, max_count=%b",
                         count_out, max_count);
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
        $dumpvars(0,clock, load, count_out, max_count);
    end

endmodule
