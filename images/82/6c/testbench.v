`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg start;
    reg stop;
    wire [31:0] cnt_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .stop(stop),
        .cnt_o(cnt_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        start = 0;
        stop = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Initial Reset", test_num);
        reset_dut();
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Normal Increment (Start=1, Stop=0)", test_num);
        reset_dut();
        start = 1;
        stop = 0;
        repeat(15) @(posedge clk);
        #1;
        #1;

        check_outputs(32'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Stop priority over Start", test_num);
        reset_dut();
        start = 1;
        stop = 1;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pause and Resume logic", test_num);
        reset_dut();
        start = 1;
        stop = 0;
        repeat(5) @(posedge clk);
        stop = 1;
        repeat(5) @(posedge clk);
        stop = 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(32'd10);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Start de-asserted (Idle)", test_num);
        reset_dut();
        start = 0;
        stop = 0;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset during operation", test_num);
        reset_dut();
        start = 1;
        stop = 0;
        repeat(20) @(posedge clk);
        rst = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Toggle start while stop is active", test_num);
        reset_dut();
        start = 1;
        stop = 0;
        repeat(5) @(posedge clk);
        stop = 1;
        repeat(2) @(posedge clk);
        start = 0;
        repeat(2) @(posedge clk);
        start = 1;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(32'd5);
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
        input [31:0] expected_cnt_o;
        begin
            if (expected_cnt_o === (expected_cnt_o ^ cnt_o ^ expected_cnt_o)) begin
                $display("PASS");
                $display("  Outputs: cnt_o=%h",
                         cnt_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cnt_o=%h",
                         expected_cnt_o);
                $display("  Got:      cnt_o=%h",
                         cnt_o);
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
        $dumpvars(0,clk, rst, start, stop, cnt_o);
    end

endmodule
