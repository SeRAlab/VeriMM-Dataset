`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] br_addr;
    reg branch;
    reg busy;
    reg clk;
    reg [31:0] j_addr;
    reg jump;
    reg stall;
    wire [2:0] access_size;
    wire enable;
    wire [31:0] pc;
    wire rw;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .br_addr(br_addr),
        .branch(branch),
        .busy(busy),
        .clk(clk),
        .j_addr(j_addr),
        .jump(jump),
        .stall(stall),
        .access_size(access_size),
        .enable(enable),
        .pc(pc),
        .rw(rw)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            stall  = 0;
            busy   = 0;
            jump   = 0;
            branch = 0;
            j_addr = 0;
            br_addr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        reg [31:0] start_pc;
        begin
            $display("Testcase 001: Standard PC increment");
            test_num = test_num + 1;
            reset_dut();
            start_pc = pc;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0, 1'b1, start_pc + 4, 1'b0);
        end
        endtask

    task testcase002;

        reg [31:0] start_pc;
        begin
            $display("Testcase 002: PC stall signal");
            test_num = test_num + 1;
            reset_dut();
            start_pc = pc;
            stall = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0, 1'b1, start_pc, 1'b0);
        end
        endtask

    task testcase003;

        reg [31:0] start_pc;
        begin
            $display("Testcase 003: PC busy signal");
            test_num = test_num + 1;
            reset_dut();
            start_pc = pc;
            busy = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0, 1'b1, start_pc, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Jump to target address");
            test_num = test_num + 1;
            reset_dut();
            jump = 1;
            j_addr = 32'h1234_5678;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0, 1'b1, 32'h1234_5678, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Branch to target address");
            test_num = test_num + 1;
            reset_dut();
            branch = 1;
            br_addr = 32'hABCD_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0, 1'b1, 32'hABCD_0000, 1'b0);
        end
        endtask

    task testcase006;

        reg [31:0] start_pc;
        begin
            $display("Testcase 006: Stall priority over Jump");
            test_num = test_num + 1;
            reset_dut();
            start_pc = pc;
            stall = 1;
            jump = 1;
            j_addr = 32'hFFFF_FFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0, 1'b1, start_pc, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Jump priority over Branch");
            test_num = test_num + 1;
            reset_dut();
            jump = 1;
            j_addr = 32'h1111_2222;
            branch = 1;
            br_addr = 32'h8888_9999;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0, 1'b1, 32'h1111_2222, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Verifying static control outputs");
            test_num = test_num + 1;
            reset_dut();

            jump = 0;
            stall = 0;
            @(posedge clk);
            #1;

            if (access_size === 3'b0 && rw === 1'b0 && enable === 1'b1) begin
                $display("PASS - Static signals correct");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL - Static signals incorrect: size=%h, rw=%b, en=%b", access_size, rw, enable);
                fail_count = fail_count + 1;
            end
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
        input [2:0] expected_access_size;
        input expected_enable;
        input [31:0] expected_pc;
        input expected_rw;
        begin
            if (expected_access_size === (expected_access_size ^ access_size ^ expected_access_size) &&
                expected_enable === (expected_enable ^ enable ^ expected_enable) &&
                expected_pc === (expected_pc ^ pc ^ expected_pc) &&
                expected_rw === (expected_rw ^ rw ^ expected_rw)) begin
                $display("PASS");
                $display("  Outputs: access_size=%h, enable=%b, pc=%h, rw=%b",
                         access_size, enable, pc, rw);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: access_size=%h, enable=%b, pc=%h, rw=%b",
                         expected_access_size, expected_enable, expected_pc, expected_rw);
                $display("  Got:      access_size=%h, enable=%b, pc=%h, rw=%b",
                         access_size, enable, pc, rw);
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
        $dumpvars(0,br_addr, branch, busy, clk, j_addr, jump, stall, access_size, enable, pc, rw);
    end

endmodule
