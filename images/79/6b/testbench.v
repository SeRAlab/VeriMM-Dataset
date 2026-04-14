`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] a_src;
    reg clk;
    reg i_fetch;
    reg [19:0] inst_in;
    reg [10:0] pc_in;
    reg rst;
    wire branch;
    wire [3:0] lcount;
    wire [10:0] pc_out;
    wire skip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_src(a_src),
        .clk(clk),
        .i_fetch(i_fetch),
        .inst_in(inst_in),
        .pc_in(pc_in),
        .rst(rst),
        .branch(branch),
        .lcount(lcount),
        .pc_out(pc_out),
        .skip(skip)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            i_fetch = 0;
            inst_in = 0;
            pc_in = 0;
            a_src = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(1'b0, 4'h0, 11'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(negedge clk);
            i_fetch = 1;

            inst_in = {4'h1, 5'b0, 11'h100};
            @(posedge clk);

            inst_in = {4'h2, 5'b0, 11'h105};
            @(posedge clk);

            inst_in = {4'h3, 12'b0, 4'h3};
            @(posedge clk);
            inst_in = 20'h0;


            pc_in = 11'h105;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 4'h2, 11'h100, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(negedge clk);
            i_fetch = 1;
            inst_in = {4'h1, 5'b0, 11'h200};
            @(posedge clk);
            inst_in = {4'h2, 5'b0, 11'h202};
            @(posedge clk);
            inst_in = {4'h3, 12'b0, 4'h1};
            @(posedge clk);
            inst_in = 0;


            pc_in = 11'h202;
            @(posedge clk);


            pc_in = 11'h202;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 4'h0, 11'h202, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(negedge clk);
            i_fetch = 1;
            inst_in = {4'h1, 5'b0, 11'h050};
            @(posedge clk);
            inst_in = {4'h2, 5'b0, 11'h060};
            @(posedge clk);
            inst_in = {4'h3, 12'b0, 4'h5};
            @(posedge clk);


            a_src = 6'b111111;
            inst_in = 20'hF0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'h5, 11'h0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(negedge clk);
            i_fetch = 1;
            inst_in = {4'h1, 5'b0, 11'h300};
            inst_in = {4'h2, 5'b0, 11'h310};
            inst_in = {4'h3, 12'b0, 4'h8};
            repeat(3) @(posedge clk);

            i_fetch = 0;
            pc_in = 11'h310;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 4'h8, 11'h310, 1'b0);
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
        input expected_branch;
        input [3:0] expected_lcount;
        input [10:0] expected_pc_out;
        input expected_skip;
        begin
            if (expected_branch === (expected_branch ^ branch ^ expected_branch) &&
                expected_lcount === (expected_lcount ^ lcount ^ expected_lcount) &&
                expected_pc_out === (expected_pc_out ^ pc_out ^ expected_pc_out) &&
                expected_skip === (expected_skip ^ skip ^ expected_skip)) begin
                $display("PASS");
                $display("  Outputs: branch=%b, lcount=%h, pc_out=%h, skip=%b",
                         branch, lcount, pc_out, skip);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: branch=%b, lcount=%h, pc_out=%h, skip=%b",
                         expected_branch, expected_lcount, expected_pc_out, expected_skip);
                $display("  Got:      branch=%b, lcount=%h, pc_out=%h, skip=%b",
                         branch, lcount, pc_out, skip);
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
        $dumpvars(0,a_src, clk, i_fetch, inst_in, pc_in, rst, branch, lcount, pc_out, skip);
    end

endmodule
