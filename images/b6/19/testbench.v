`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [27:0] big_alu_result;
    reg clk;
    reg en;
    reg [27:0] fra_result;
    reg res;
    wire [27:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .big_alu_result(big_alu_result),
        .clk(clk),
        .en(en),
        .fra_result(fra_result),
        .res(res),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        res = 0;
        en = 0;
        big_alu_result = 28'h0;
        fra_result = 28'h0;
        @(posedge clk);
        #1;
        res = 1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Active-low reset check (res=0 overrides everything)", test_num);
        res = 0;
        en = 1;
        big_alu_result = 28'hAAAAAAA;
        fra_result = 28'h5555555;
        @(posedge clk);
        #1;
        #1;

        check_outputs(28'h0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Select big_alu_result (en=0)", test_num);
        res = 1;
        en = 0;
        big_alu_result = 28'h1234567;
        fra_result = 28'h89ABCDE;
        @(posedge clk);
        #1;
        #1;

        check_outputs(28'h1234567);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Select fra_result (en=1)", test_num);
        res = 1;
        en = 1;
        big_alu_result = 28'h1234567;
        fra_result = 28'h89ABCDE;
        @(posedge clk);
        #1;
        #1;

        check_outputs(28'h89ABCDE);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: All-ones pattern on big_alu_result (en=0)", test_num);
        res = 1;
        en = 0;
        big_alu_result = 28'hFFFFFFF;
        fra_result = 28'h0000000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(28'hFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: All-ones pattern on fra_result (en=1)", test_num);
        res = 1;
        en = 1;
        big_alu_result = 28'h0000000;
        fra_result = 28'hFFFFFFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(28'hFFFFFFF);
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
        input [27:0] expected_out;
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
        $dumpvars(0,big_alu_result, clk, en, fra_result, res, out);
    end

endmodule
