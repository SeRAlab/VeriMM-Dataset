`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [3:0] count;
    wire wrap_around;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .count(count),
        .wrap_around(wrap_around)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            @(negedge clk);
            reset = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset verification", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("Testcase %0d: Increment to 5", test_num);
            reset_dut();
            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(4'h5, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %0d: Maximum value (15) and wrap_around flag", test_num);
            reset_dut();
            for (i = 0; i < 15; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(4'hF, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Rollover from 15 back to 0", test_num);
            reset_dut();
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %0d: Multi-cycle rollover (20 cycles)", test_num);
            reset_dut();
            for (i = 0; i < 20; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(4'h4, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
            end

            @(negedge clk);
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            #1;

            check_outputs(4'h0, 1'b0);
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
        input [3:0] expected_count;
        input expected_wrap_around;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_wrap_around === (expected_wrap_around ^ wrap_around ^ expected_wrap_around)) begin
                $display("PASS");
                $display("  Outputs: count=%h, wrap_around=%b",
                         count, wrap_around);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, wrap_around=%b",
                         expected_count, expected_wrap_around);
                $display("  Got:      count=%h, wrap_around=%b",
                         count, wrap_around);
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
        $dumpvars(0,clk, reset, count, wrap_around);
    end

endmodule
