`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg start;
    wire [2:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .start(start),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        integer timeout;
        begin
            $display("\nResetting DUT...");
            start = 0;
            timeout = 0;

            while (count !== 3'b000 && timeout < 10) begin
                @(negedge clk);
                start = 1;
                timeout = timeout + 1;
            end
            @(negedge clk);
            start = 0;
            repeat(2) @(negedge clk);
            $display("DUT Reset Complete. Current Count: %d", count);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Idle state (start=0)", test_num);
            reset_dut();
            @(negedge clk);
            start = 0;
            repeat(5) @(negedge clk);
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Count to 3", test_num);
            reset_dut();
            @(negedge clk);
            start = 1;
            repeat(3) @(negedge clk);
            start = 0;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Count to maximum (7)", test_num);
            reset_dut();
            @(negedge clk);
            start = 1;
            repeat(7) @(negedge clk);
            start = 0;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Rollover (7 -> 0)", test_num);
            reset_dut();
            @(negedge clk);
            start = 1;
            repeat(8) @(negedge clk);
            start = 0;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Pause and Resume", test_num);
            reset_dut();
            @(negedge clk);
            start = 1;
            repeat(2) @(negedge clk);
            start = 0;
            repeat(3) @(negedge clk);
            start = 1;
            repeat(2) @(negedge clk);
            start = 0;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Multiple Rollovers (18 cycles)", test_num);
            reset_dut();
            @(negedge clk);
            start = 1;
            repeat(18) @(negedge clk);
            start = 0;
            #1;

            check_outputs(3'd2);
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
        input [2:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, start, count);
    end

endmodule
