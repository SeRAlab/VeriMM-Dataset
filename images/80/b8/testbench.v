`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    wire [3:0] count;
    wire reached_max;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .count(count),
        .reached_max(reached_max)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 0;
        enable = 0;
        @(negedge clk);
        reset = 1;
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();

        #1;


        check_outputs(4'd0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        enable = 1;
        @(negedge clk);
        #1;

        check_outputs(4'd1, 1'b0);
    end
        endtask

    task testcase003;

    integer i;
    begin
        reset_dut();
        enable = 1;
        for (i = 0; i < 9; i = i + 1) begin
            @(negedge clk);
        end

        #1;


        check_outputs(4'd9, 1'b1);
    end
        endtask

    task testcase004;

    integer i;
    begin
        reset_dut();
        enable = 1;
        for (i = 0; i < 10; i = i + 1) begin
            @(negedge clk);
        end

        #1;


        check_outputs(4'd0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        enable = 1;
        repeat(3) @(negedge clk);
        enable = 0;
        repeat(3) @(negedge clk);
        #1;

        check_outputs(4'd3, 1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        enable = 1;
        repeat(5) @(negedge clk);
        reset = 0;
        #2;
        #1;

        check_outputs(4'd0, 1'b0);
        reset = 1;
    end
        endtask

    task testcase007;

    integer i;
    begin
        reset_dut();
        enable = 1;

        for (i = 0; i < 20; i = i + 1) begin
            @(negedge clk);
        end
        #1;

        check_outputs(4'd0, 1'b0);
    end
        endtask

    task testcase008;

    integer i;
    begin
        reset_dut();
        enable = 1;
        for (i = 0; i < 9; i = i + 1) begin
            @(negedge clk);
        end
        enable = 0;
        repeat(2) @(negedge clk);
        #1;

        check_outputs(4'd9, 1'b1);
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
        testcase007();
        testcase008();
        
        
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
        input expected_reached_max;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_reached_max === (expected_reached_max ^ reached_max ^ expected_reached_max)) begin
                $display("PASS");
                $display("  Outputs: count=%h, reached_max=%b",
                         count, reached_max);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, reached_max=%b",
                         expected_count, expected_reached_max);
                $display("  Got:      count=%h, reached_max=%b",
                         count, reached_max);
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
        $dumpvars(0,clk, enable, reset, count, reached_max);
    end

endmodule
