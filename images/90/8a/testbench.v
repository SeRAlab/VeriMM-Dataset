`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dn;
    reg in1;
    reg in2;
    reg n_rst;
    reg up;
    wire [31:0] cnt;
    wire [3:0] cnt_1k;
    wire out1;
    wire out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dn(dn),
        .in1(in1),
        .in2(in2),
        .n_rst(n_rst),
        .up(up),
        .cnt(cnt),
        .cnt_1k(cnt_1k),
        .out1(out1),
        .out2(out2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        n_rst = 0;
        up = 0;
        dn = 0;
        in1 = 0;
        in2 = 0;
        @(posedge clk);
        #1 n_rst = 0;
        @(posedge clk);
        #1 n_rst = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Testcase 001: Checking Reset");
        #1;

        check_outputs(32'h0, 4'h0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Testcase 002: Incrementing Up");
        up = 1;
        repeat(50) @(posedge clk);
        up = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(32'd50, 4'h0, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Testcase 003: Incrementing then Decrementing");
        up = 1;
        repeat(30) @(posedge clk);
        up = 0;
        dn = 1;
        repeat(10) @(posedge clk);
        dn = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(32'd20, 4'h0, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Testcase 004: Counter Underflow (dn while at 0)");
        dn = 1;
        repeat(5) @(posedge clk);
        dn = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(32'hFFFFFFF9, 4'h0, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Testcase 005: Simultaneous Up and Down (Net 0)");
        up = 1;
        dn = 1;
        repeat(20) @(posedge clk);
        up = 0;
        dn = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(32'h0, 4'h0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        $display("Testcase 006: Slow Counter Divider (100,000 cycles)");

        repeat(100000) @(posedge clk);
        #1 #1;
 check_outputs(32'h0, 4'h1, 1'b0, 1'b0);
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
        input [31:0] expected_cnt;
        input [3:0] expected_cnt_1k;
        input expected_out1;
        input expected_out2;
        begin
            if (expected_cnt === (expected_cnt ^ cnt ^ expected_cnt) &&
                expected_cnt_1k === (expected_cnt_1k ^ cnt_1k ^ expected_cnt_1k) &&
                expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2)) begin
                $display("PASS");
                $display("  Outputs: cnt=%h, cnt_1k=%h, out1=%b, out2=%b",
                         cnt, cnt_1k, out1, out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cnt=%h, cnt_1k=%h, out1=%b, out2=%b",
                         expected_cnt, expected_cnt_1k, expected_out1, expected_out2);
                $display("  Got:      cnt=%h, cnt_1k=%h, out1=%b, out2=%b",
                         cnt, cnt_1k, out1, out2);
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
        $dumpvars(0,clk, dn, in1, in2, n_rst, up, cnt, cnt_1k, out1, out2);
    end

endmodule
