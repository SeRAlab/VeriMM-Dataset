`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ctrl;
    wire [4:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ctrl(ctrl),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ctrl = 1;

            force dut.count = 5'd0;
            @(posedge clk);
            #1 release dut.count;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Counting Up", test_num);
            reset_dut();
            ctrl = 1;
            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(5'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Counting Down (Underflow from 0)", test_num);
            reset_dut();
            ctrl = 0;
            repeat(1) @(posedge clk);
            #1 #1;
 check_outputs(5'h1F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Upward Wrap-around (0 to 32)", test_num);
            reset_dut();
            ctrl = 1;
            repeat(32) @(posedge clk);
            #1 #1;
 check_outputs(5'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Downward Wrap-around (5 steps)", test_num);
            reset_dut();
            ctrl = 0;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(5'd27);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Direction Change (Up 15, then Down 5)", test_num);
            reset_dut();
            ctrl = 1;
            repeat(15) @(posedge clk);
            ctrl = 0;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(5'd10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Stress direction switch (Up 5, Down 10)", test_num);
            reset_dut();
            ctrl = 1;
            repeat(5) @(posedge clk);
            ctrl = 0;
            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(5'd27);
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
        $dumpvars(0,clk, ctrl, count);
    end

endmodule
