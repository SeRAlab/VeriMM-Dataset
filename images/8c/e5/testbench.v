`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load_enable;
    reg [5:0] load_value;
    wire [5:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load_enable(load_enable),
        .load_value(load_value),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(posedge clk);
        load_enable <= 1;
        load_value <= 6'd0;
        @(posedge clk);
        #1;
        load_enable <= 0;
        load_value <= 6'd0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Basic Increment");
        reset_dut();

        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(6'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Load specific value (42)");
        reset_dut();
        @(posedge clk);
        load_enable <= 1;
        load_value <= 6'd42;
        @(posedge clk);
        #1;
        #1;

        check_outputs(6'd42);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Roll-over 63 to 0");
        reset_dut();
        @(posedge clk);
        load_enable <= 1;
        load_value <= 6'h3F;
        @(posedge clk);
        load_enable <= 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(6'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Load then increment");
        reset_dut();
        @(posedge clk);
        load_enable <= 1;
        load_value <= 6'd10;
        @(posedge clk);
        load_enable <= 0;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(6'd20);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Interrupted count by load");
        reset_dut();
        repeat(3) @(posedge clk);
        @(posedge clk);
        load_enable <= 1;
        load_value <= 6'd50;
        @(posedge clk);
        load_enable <= 0;
        #1;
        #1;

        check_outputs(6'd50);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Load zero from non-zero state");
        reset_dut();
        repeat(15) @(posedge clk);
        @(posedge clk);
        load_enable <= 1;
        load_value <= 6'd0;
        @(posedge clk);
        load_enable <= 0;
        #1;
        #1;

        check_outputs(6'd0);
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
        input [5:0] expected_count;
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
        $dumpvars(0,clk, load_enable, load_value, count);
    end

endmodule
