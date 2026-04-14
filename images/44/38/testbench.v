`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg branch;
    reg [15:0] branchAddr;
    reg clk;
    reg globalStall;
    reg [15:0] instr;
    reg rd_en;
    reg rst_n;
    reg stall;
    wire branchInit;
    wire hlt;
    wire [15:0] pc;
    wire [15:0] pcNext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .branch(branch),
        .branchAddr(branchAddr),
        .clk(clk),
        .globalStall(globalStall),
        .instr(instr),
        .rd_en(rd_en),
        .rst_n(rst_n),
        .stall(stall),
        .branchInit(branchInit),
        .hlt(hlt),
        .pc(pc),
        .pcNext(pcNext)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            branch = 0;
            branchAddr = 0;
            globalStall = 0;
            instr = 0;
            rd_en = 0;
            stall = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Behavior");
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 16'h0000, 16'h0001);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Sequential PC Update");
            reset_dut();
            rd_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 16'h0001, 16'h0002);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Local Stall");
            reset_dut();
            rd_en = 1;
            @(posedge clk);
            #1 stall = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 16'h0001, 16'h0001);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Global Stall");
            reset_dut();
            rd_en = 1;
            @(posedge clk);
            #1 globalStall = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 16'h0001, 16'h0001);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Branching");
            reset_dut();
            rd_en = 1;
            branch = 1;
            branchAddr = 16'h1234;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 16'h1234, 16'h1235);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Halt Condition");
            reset_dut();
            rd_en = 1;
            instr = 16'h7000;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 1'b1, 16'h0001, 16'h0001);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Read Enable Disabled");
            reset_dut();
            rd_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 16'h0000, 16'h0000);
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
        input expected_branchInit;
        input expected_hlt;
        input [15:0] expected_pc;
        input [15:0] expected_pcNext;
        begin
            if (expected_branchInit === (expected_branchInit ^ branchInit ^ expected_branchInit) &&
                expected_hlt === (expected_hlt ^ hlt ^ expected_hlt) &&
                expected_pc === (expected_pc ^ pc ^ expected_pc) &&
                expected_pcNext === (expected_pcNext ^ pcNext ^ expected_pcNext)) begin
                $display("PASS");
                $display("  Outputs: branchInit=%b, hlt=%b, pc=%h, pcNext=%h",
                         branchInit, hlt, pc, pcNext);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: branchInit=%b, hlt=%b, pc=%h, pcNext=%h",
                         expected_branchInit, expected_hlt, expected_pc, expected_pcNext);
                $display("  Got:      branchInit=%b, hlt=%b, pc=%h, pcNext=%h",
                         branchInit, hlt, pc, pcNext);
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
        $dumpvars(0,branch, branchAddr, clk, globalStall, instr, rd_en, rst_n, stall, branchInit, hlt, pc, pcNext);
    end

endmodule
