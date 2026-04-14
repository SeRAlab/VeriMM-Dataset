`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] initial_value;
    reg load;
    wire [4:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .initial_value(initial_value),
        .load(load),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        load = 1;
        initial_value = 5'b00000;
        @(posedge clk);
        #1;
        load = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Basic incrementing from 0", test_num);
        reset_dut();

        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(5'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Load 5'h0A and increment 3 times", test_num);
        reset_dut();
        load = 1;
        initial_value = 5'h0A;
        @(posedge clk);
        #1;
        load = 0;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(5'd13);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Rollover from 31 to 0", test_num);
        reset_dut();
        load = 1;
        initial_value = 5'h1F;
        @(posedge clk);
        #1;
        load = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Load 30 and wait 4 cycles", test_num);
        reset_dut();
        load = 1;
        initial_value = 5'd30;
        @(posedge clk);
        #1;
        load = 0;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(5'd2);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Load high priority over increment", test_num);
        reset_dut();
        load = 1;
        initial_value = 5'h15;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(5'h15);
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
        input [4:0] expected_count;
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
        $dumpvars(0,clk, initial_value, load, count);
    end

endmodule
