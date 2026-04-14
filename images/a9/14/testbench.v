`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg dir;
    reg enable;
    wire [11:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .clk(clk),
        .dir(dir),
        .enable(enable),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

    begin
        areset = 1;
        enable = 0;
        dir = 0;
        #15;
        areset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Initial Reset Check", test_num);
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Count Up (10 cycles)", test_num);
        enable = 1;
        dir = 1;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(12'd10);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Count Down (5 cycles) from 0", test_num);
        enable = 1;
        dir = 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(12'hFFB);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Enable Logic Check", test_num);
        dir = 1;
        enable = 0;
        repeat(5) @(posedge clk);
        enable = 1;
        repeat(5) @(posedge clk);
        enable = 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(12'd5);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Direction Switching Check", test_num);
        enable = 1;
        dir = 1;
        repeat(20) @(posedge clk);
        dir = 0;
        repeat(7) @(posedge clk);
        #1;
        #1;

        check_outputs(12'd13);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Max Rollover Check", test_num);
        enable = 1;
        dir = 0;
        repeat(1) @(posedge clk);
        dir = 1;
        repeat(1) @(posedge clk);
        #1;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Mid-operation Async Reset Check", test_num);
        enable = 1;
        dir = 1;
        repeat(10) @(posedge clk);
        #2;
        areset = 1;
        #5;
        areset = 0;
        #1;
        #1;

        check_outputs(12'h000);
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
        input [11:0] expected_count;
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
        $dumpvars(0,areset, clk, dir, enable, count);
    end

endmodule
