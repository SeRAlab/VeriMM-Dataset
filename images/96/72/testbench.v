`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ena;
    reg rst;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ena(ena),
        .rst(rst),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        ena = 0;
        rst = 0;

        repeat(2) @(posedge clk);
        #1 rst = 1;

        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset state check", test_num);
        reset_dut();
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Single increment", test_num);
        reset_dut();
        ena = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Two increments", test_num);
        reset_dut();
        ena = 1;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Three increments", test_num);
        reset_dut();
        ena = 1;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Four increments", test_num);
        reset_dut();
        ena = 1;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Seven increments", test_num);
        reset_dut();
        ena = 1;
        repeat(7) @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Ten increments", test_num);
        reset_dut();
        ena = 1;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Fifteen increments", test_num);
        reset_dut();
        ena = 1;
        repeat(15) @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Rollover check (16 steps)", test_num);
        reset_dut();
        ena = 1;
        repeat(16) @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Enable disable check", test_num);
        reset_dut();
        ena = 1;
        repeat(5) @(posedge clk);
        ena = 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0111);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, ena, rst, q);
    end

endmodule
