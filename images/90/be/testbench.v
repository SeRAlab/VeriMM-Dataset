`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg rst;
    wire done;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .rst(rst),
        .done(done),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        enable = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("testcase001: Checking Reset state...");
        reset_dut();

        #1;


        check_outputs(0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        $display("testcase002: Counting 5 cycles...");
        reset_dut();
        enable = 1;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(0, 4'h5);
    end
        endtask

    task testcase003;

    begin
        $display("testcase003: Disabling counter to check 'done' signal...");
        reset_dut();
        enable = 1;
        repeat(3) @(posedge clk);
        enable = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1, 4'h3);
    end
        endtask

    task testcase004;

    begin
        $display("testcase004: Checking 4-bit overflow (wraparound)...");
        reset_dut();
        enable = 1;
        repeat(16) @(posedge clk);
        #1;
        #1;

        check_outputs(0, 4'h0);
    end
        endtask

    task testcase005;

    begin
        $display("testcase005: Disabling then re-enabling...");
        reset_dut();
        enable = 1;
        repeat(2) @(posedge clk);
        enable = 0;
        repeat(2) @(posedge clk);
        enable = 1;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(0, 4'h4);
    end
        endtask

    task testcase006;

    begin
        $display("testcase006: Asserting reset while enabled...");
        reset_dut();
        enable = 1;
        repeat(8) @(posedge clk);
        rst = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 4'h0);
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
        input expected_done;
        input [3:0] expected_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, out=%h",
                         done, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, out=%h",
                         expected_done, expected_out);
                $display("  Got:      done=%b, out=%h",
                         done, out);
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
        $dumpvars(0,clk, enable, rst, done, out);
    end

endmodule
