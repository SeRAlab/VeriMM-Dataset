`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [3:0] count;
    wire max_count_reached;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .count(count),
        .max_count_reached(max_count_reached)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        #20;
        @(negedge clk);
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Initial increment after reset", test_num);
        reset_dut();


        #1;



        check_outputs(4'd1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Count to middle value (8)", test_num);
        reset_dut();
        repeat(7) @(posedge clk);
        #1;
        #1;

        check_outputs(4'd8, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reaching max count (15)", test_num);
        reset_dut();
        repeat(14) @(posedge clk);
        #1;
        #1;

        check_outputs(4'd15, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Wrap around from 15 to 0", test_num);
        reset_dut();
        repeat(15) @(posedge clk);
        #1;
        #1;

        check_outputs(4'd0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Asynchronous reset mid-operation", test_num);
        reset_dut();
        repeat(10) @(posedge clk);
        rst = 1;
        #20;
        rst = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'd1, 1'b0);
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
        input [3:0] expected_count;
        input expected_max_count_reached;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_max_count_reached === (expected_max_count_reached ^ max_count_reached ^ expected_max_count_reached)) begin
                $display("PASS");
                $display("  Outputs: count=%h, max_count_reached=%b",
                         count, max_count_reached);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, max_count_reached=%b",
                         expected_count, expected_max_count_reached);
                $display("  Got:      count=%h, max_count_reached=%b",
                         count, max_count_reached);
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
        $dumpvars(0,clk, rst, count, max_count_reached);
    end

endmodule
