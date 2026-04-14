`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg rstn;
    wire [6:0] blockcnt;
    wire counterrun1;
    wire counterrun2;
    wire [5:0] cyclecnt;
    wire finish;
    wire gxgyrun;
    wire newblock;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .rstn(rstn),
        .blockcnt(blockcnt),
        .counterrun1(counterrun1),
        .counterrun2(counterrun2),
        .cyclecnt(cyclecnt),
        .finish(finish),
        .gxgyrun(gxgyrun),
        .newblock(newblock)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rstn = 0;
        enable = 0;
        @(posedge clk);
        #2 rstn = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Post-Reset Initialization", test_num);
        reset_dut();
        #1;

        #1;


        check_outputs(7'd0, 1'b0, 1'b0, 6'd0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Operation active and pipeline delay check", test_num);
        reset_dut();
        enable = 1;

        repeat(10) @(posedge clk);
        #1;

        #1;


        check_outputs(7'd0, 1'b1, 1'b1, 6'd10, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Newblock signal trigger at cycle 40", test_num);
        reset_dut();
        enable = 1;

        repeat(40) @(posedge clk);
        #1;

        #1;


        check_outputs(7'd0, 1'b1, 1'b1, 6'd40, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Block count increment check", test_num);
        reset_dut();
        enable = 1;

        repeat(41) @(posedge clk);
        #1;

        #1;


        check_outputs(7'd1, 1'b1, 1'b1, 6'd0, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Termination condition check (Finish)", test_num);
        reset_dut();
        enable = 1;



        repeat(2664) @(posedge clk);
        #1;

        #1;


        check_outputs(7'd64, 1'b1, 1'b1, 6'd40, 1'b1, 1'b1, 1'b1);
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
        input [6:0] expected_blockcnt;
        input expected_counterrun1;
        input expected_counterrun2;
        input [5:0] expected_cyclecnt;
        input expected_finish;
        input expected_gxgyrun;
        input expected_newblock;
        begin
            if (expected_blockcnt === (expected_blockcnt ^ blockcnt ^ expected_blockcnt) &&
                expected_counterrun1 === (expected_counterrun1 ^ counterrun1 ^ expected_counterrun1) &&
                expected_counterrun2 === (expected_counterrun2 ^ counterrun2 ^ expected_counterrun2) &&
                expected_cyclecnt === (expected_cyclecnt ^ cyclecnt ^ expected_cyclecnt) &&
                expected_finish === (expected_finish ^ finish ^ expected_finish) &&
                expected_gxgyrun === (expected_gxgyrun ^ gxgyrun ^ expected_gxgyrun) &&
                expected_newblock === (expected_newblock ^ newblock ^ expected_newblock)) begin
                $display("PASS");
                $display("  Outputs: blockcnt=%h, counterrun1=%b, counterrun2=%b, cyclecnt=%h, finish=%b, gxgyrun=%b, newblock=%b",
                         blockcnt, counterrun1, counterrun2, cyclecnt, finish, gxgyrun, newblock);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: blockcnt=%h, counterrun1=%b, counterrun2=%b, cyclecnt=%h, finish=%b, gxgyrun=%b, newblock=%b",
                         expected_blockcnt, expected_counterrun1, expected_counterrun2, expected_cyclecnt, expected_finish, expected_gxgyrun, expected_newblock);
                $display("  Got:      blockcnt=%h, counterrun1=%b, counterrun2=%b, cyclecnt=%h, finish=%b, gxgyrun=%b, newblock=%b",
                         blockcnt, counterrun1, counterrun2, cyclecnt, finish, gxgyrun, newblock);
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
        $dumpvars(0,clk, enable, rstn, blockcnt, counterrun1, counterrun2, cyclecnt, finish, gxgyrun, newblock);
    end

endmodule
