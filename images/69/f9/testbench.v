`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire en;
    wire to;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .to(to)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Checking initial state after reset", test_num);
        reset_dut();

        #1 #1;
 check_outputs(1, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Checking state just before timeout", test_num);
        reset_dut();

        repeat(9) @(posedge clk);
        #1 #1;
 check_outputs(1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Checking timeout assertion at cycle t", test_num);
        reset_dut();

        repeat(10) @(posedge clk);
        #1 #1;
 check_outputs(0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Checking if timeout state persists", test_num);
        reset_dut();

        repeat(15) @(posedge clk);
        #1 #1;
 check_outputs(0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Resetting timer mid-count to prevent timeout", test_num);
        reset_dut();

        repeat(5) @(posedge clk);

        rst = 1; @(posedge clk); #1 rst = 0;

        repeat(7) @(posedge clk);
        #1 #1;
 check_outputs(1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Recovery from timeout via reset", test_num);
        reset_dut();
        repeat(10) @(posedge clk);
        reset_dut();
        #1 #1;
 check_outputs(1, 0);
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
        input expected_en;
        input expected_to;
        begin
            if (expected_en === (expected_en ^ en ^ expected_en) &&
                expected_to === (expected_to ^ to ^ expected_to)) begin
                $display("PASS");
                $display("  Outputs: en=%b, to=%b",
                         en, to);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: en=%b, to=%b",
                         expected_en, expected_to);
                $display("  Got:      en=%b, to=%b",
                         en, to);
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
        $dumpvars(0,clk, rst, en, to);
    end

endmodule
