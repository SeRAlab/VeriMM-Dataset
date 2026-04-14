`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg start;
    wire [7:0] rand_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .rand_num(rand_num)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(posedge clk);
        rst = 1;
        start = 0;
        repeat (2) @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Verifying Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(8'h01);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Single Clock Step", test_num);
        reset_dut();
        @(posedge clk);
        start = 1;
        @(posedge clk);
        #1 start = 0;

        #1;


        check_outputs(8'h02);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Verifying Start/Pause Signal", test_num);
        reset_dut();
        @(posedge clk);
        start = 1;
        repeat(2) @(posedge clk);
        #1 start = 0;
        repeat(3) @(posedge clk);

        #1;


        check_outputs(8'h04);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Multi-cycle Sequence Check", test_num);
        reset_dut();
        @(posedge clk);
        start = 1;
        repeat(5) @(posedge clk);
        #1 start = 0;

        #1;


        check_outputs(8'h20);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset Mid-Operation", test_num);
        reset_dut();
        @(posedge clk);
        start = 1;
        repeat(10) @(posedge clk);
        #1 rst = 1;
        repeat(2) @(posedge clk);
        #1 rst = 0; start = 0;

        #1;


        check_outputs(8'h01);
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
        input [7:0] expected_rand_num;
        begin
            if (expected_rand_num === (expected_rand_num ^ rand_num ^ expected_rand_num)) begin
                $display("PASS");
                $display("  Outputs: rand_num=%h",
                         rand_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rand_num=%h",
                         expected_rand_num);
                $display("  Got:      rand_num=%h",
                         rand_num);
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
        $dumpvars(0,clk, rst, start, rand_num);
    end

endmodule
