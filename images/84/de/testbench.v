`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    wire carry_out;
    wire [2:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .carry_out(carry_out),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        enable = 0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Reset State Check");
        reset_dut();

        #1;


        check_outputs(0, 3'b000);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Increment to 4");
        reset_dut();
        enable = 1;
        repeat(4) @(posedge clk);
        #1;
        enable = 0;

        #1;


        check_outputs(0, 3'b100);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Max value and Carry Out");
        reset_dut();
        enable = 1;
        repeat(7) @(posedge clk);
        #1;

        #1;


        check_outputs(1, 3'b111);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Rollover from 7 to 0");
        reset_dut();
        enable = 1;
        repeat(8) @(posedge clk);
        #1;
        enable = 0;

        #1;


        check_outputs(0, 3'b000);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Enable gating (pausing counter)");
        reset_dut();
        enable = 1;
        repeat(2) @(posedge clk);
        #1;
        enable = 0;
        repeat(3) @(posedge clk);
        #1;

        #1;


        check_outputs(0, 3'b010);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Synchronous reset while counting");
        reset_dut();
        enable = 1;
        repeat(5) @(posedge clk);
        #1;
        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;
        enable = 0;

        #1;


        check_outputs(0, 3'b000);
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
        input expected_carry_out;
        input [2:0] expected_q;
        begin
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, q=%h",
                         carry_out, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, q=%h",
                         expected_carry_out, expected_q);
                $display("  Got:      carry_out=%b, q=%h",
                         carry_out, q);
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
        $dumpvars(0,clk, enable, reset, carry_out, q);
    end

endmodule
