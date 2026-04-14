`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data1;
    reg [7:0] data2;
    reg rst;
    wire done;
    wire eq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data1(data1),
        .data2(data2),
        .rst(rst),
        .done(done),
        .eq(eq)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        data1 = 0;
        data2 = 0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Identical Data (0xAA)", test_num);
        reset_dut();
        data1 = 8'hAA;
        data2 = 8'hAA;

        while (!done) @(posedge clk);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Different Data (0x55 vs 0xAA)", test_num);
        reset_dut();
        data1 = 8'h55;
        data2 = 8'hAA;
        while (!done) @(posedge clk);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Zero Values", test_num);
        reset_dut();
        data1 = 8'h00;
        data2 = 8'h00;
        while (!done) @(posedge clk);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Max Values (0xFF)", test_num);
        reset_dut();
        data1 = 8'hFF;
        data2 = 8'hFF;
        while (!done) @(posedge clk);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Single bit difference", test_num);
        reset_dut();
        data1 = 8'b10101010;
        data2 = 8'b10101011;
        while (!done) @(posedge clk);
        #1;

        check_outputs(1'b1, 1'b0);
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
        input expected_done;
        input expected_eq;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_eq === (expected_eq ^ eq ^ expected_eq)) begin
                $display("PASS");
                $display("  Outputs: done=%b, eq=%b",
                         done, eq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, eq=%b",
                         expected_done, expected_eq);
                $display("  Got:      done=%b, eq=%b",
                         done, eq);
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
        $dumpvars(0,clk, data1, data2, rst, done, eq);
    end

endmodule
