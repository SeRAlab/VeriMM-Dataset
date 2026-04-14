`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg [31:0] cnt_max;
    reg [31:0] cnt_min;
    reg cnten;
    reg inc_dec;
    wire [31:0] cnt_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .cnt_max(cnt_max),
        .cnt_min(cnt_min),
        .cnten(cnten),
        .inc_dec(inc_dec),
        .cnt_value(cnt_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        clr = 1;
        cnten = 0;
        inc_dec = 1;
        cnt_max = 32'hFFFFFFFF;
        cnt_min = 32'h00000000;
        @(posedge clk);
        #1;
        clr = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Basic Up Counting");
        reset_dut();
        cnt_min = 32'd10;
        cnt_max = 32'd20;
        inc_dec = 1;
        clr = 1;
        @(posedge clk); #1 clr = 0;

        cnten = 1;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(32'd15);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Up Counting Wrap-around");
        reset_dut();
        cnt_min = 32'd10;
        cnt_max = 32'd20;
        inc_dec = 1;
        clr = 1; @(posedge clk); #1 clr = 0;

        cnten = 1;
        repeat(11) @(posedge clk);
        #1;
        #1;

        check_outputs(32'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Down Counting Wrap-around");
        reset_dut();
        cnt_min = 32'd0;
        cnt_max = 32'd100;
        inc_dec = 0;
        clr = 1; @(posedge clk); #1 clr = 0;

        cnten = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'd100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Counter Enable/Disable");
        reset_dut();
        cnt_min = 32'd0;
        cnt_max = 32'd100;
        inc_dec = 1;
        clr = 1; @(posedge clk); #1 clr = 0;

        cnten = 1;
        repeat(3) @(posedge clk);
        cnten = 0;
        repeat(3) @(posedge clk);
        cnten = 1;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(32'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Clear Signal Priority");
        reset_dut();
        cnt_min = 32'd50;
        cnt_max = 32'd100;
        inc_dec = 1;
        clr = 1; @(posedge clk); #1 clr = 0;

        cnten = 1;
        repeat(10) @(posedge clk);
        clr = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'd50);
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
        input [31:0] expected_cnt_value;
        begin
            if (expected_cnt_value === (expected_cnt_value ^ cnt_value ^ expected_cnt_value)) begin
                $display("PASS");
                $display("  Outputs: cnt_value=%h",
                         cnt_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cnt_value=%h",
                         expected_cnt_value);
                $display("  Got:      cnt_value=%h",
                         cnt_value);
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
        $dumpvars(0,clk, clr, cnt_max, cnt_min, cnten, inc_dec, cnt_value);
    end

endmodule
