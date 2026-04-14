`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dir;
    reg rst;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dir(dir),
        .rst(rst),
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
        dir = 1;
        #10;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Reset Check", test_num);
        reset_dut();
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Increment 5 times", test_num);
        reset_dut();
        dir = 1;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Decrement 3 times (Underflow check)", test_num);
        reset_dut();
        dir = 0;

        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(4'hD);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Overflow check (Count 16 times)", test_num);
        reset_dut();
        dir = 1;
        repeat(16) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Mixed direction (Up 10, Down 4)", test_num);
        reset_dut();
        dir = 1;
        repeat(10) @(posedge clk);
        dir = 0;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h6);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Check maximum 4-bit value", test_num);
        reset_dut();
        dir = 1;
        repeat(15) @(posedge clk);
        #1;
        #1;

        check_outputs(4'hF);
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
        input [3:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, dir, rst, out);
    end

endmodule
