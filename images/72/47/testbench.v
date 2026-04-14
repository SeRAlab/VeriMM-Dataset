`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg core_sp_clk;
    reg [31:0] fifo_pr_bblock;
    reg [31:0] fifo_pr_nhop;
    reg [31:0] previous_bblock;
    reg [31:0] previous_nhop;
    reg reset;
    wire [31:0] jump_bblock;
    wire [10:0] jump_index_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .core_sp_clk(core_sp_clk),
        .fifo_pr_bblock(fifo_pr_bblock),
        .fifo_pr_nhop(fifo_pr_nhop),
        .previous_bblock(previous_bblock),
        .previous_nhop(previous_nhop),
        .reset(reset),
        .jump_bblock(jump_bblock),
        .jump_index_addr(jump_index_addr)
    );

    // Clock generation (10ns period)
    initial begin
        core_sp_clk = 0;
        forever #5 core_sp_clk = ~core_sp_clk;
    end

        task reset_dut;

        begin
            reset = 1;
            fifo_pr_bblock = 0;
            fifo_pr_nhop = 0;
            previous_bblock = 0;
            previous_nhop = 0;
            @(posedge core_sp_clk);
            #1;
            reset = 0;
            @(posedge core_sp_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset State", test_num);
            reset = 1;
            @(posedge core_sp_clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Condition Matches (Equal)", test_num);
            reset_dut();
            previous_bblock = 32'hA000;
            fifo_pr_bblock = 32'hA000;
            fifo_pr_nhop = 32'hFFFF;
            @(posedge core_sp_clk);
            #1;
            #1;

            check_outputs(32'h1, 11'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Condition Matches (Adjacent)", test_num);
            reset_dut();
            previous_bblock = 32'hB000;
            fifo_pr_bblock = 32'hB001;
            fifo_pr_nhop = 32'hFFFF;
            @(posedge core_sp_clk);
            #1;
            #1;

            check_outputs(32'h1, 11'h0);
        end
        endtask

    task testcase004;

        reg [10:0] expected_addr;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Condition Fails (Jump Logic)", test_num);
            reset_dut();
            previous_bblock = 32'h12345678;
            fifo_pr_bblock = 32'hFFFFFFFF;
            fifo_pr_nhop = 32'h0000ABCD;




            expected_addr = (32'h0000ABCD >> 2) & 11'h7FF;

            @(posedge core_sp_clk);
            #1;
            #1;

            check_outputs(32'h12345678, expected_addr);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary nhop bits", test_num);
            reset_dut();
            previous_bblock = 32'hCAFEBABE;
            fifo_pr_bblock = 32'h0;
            fifo_pr_nhop = 32'hFFFFFFFF;

            @(posedge core_sp_clk);
            #1;

            #1;


            check_outputs(32'hCAFEBABE, 11'h7FF);
        end
        endtask

    task testcase006;

        reg [10:0] expected_addr;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Near Adjacent (Lower)", test_num);
            reset_dut();
            previous_bblock = 32'h100;
            fifo_pr_bblock = 32'h0FF;
            fifo_pr_nhop = 32'h1234;
            expected_addr = (32'h1234 >> 2) & 11'h7FF;

            @(posedge core_sp_clk);
            #1;
            #1;

            check_outputs(32'h100, expected_addr);
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
        input [31:0] expected_jump_bblock;
        input [10:0] expected_jump_index_addr;
        begin
            if (expected_jump_bblock === (expected_jump_bblock ^ jump_bblock ^ expected_jump_bblock) &&
                expected_jump_index_addr === (expected_jump_index_addr ^ jump_index_addr ^ expected_jump_index_addr)) begin
                $display("PASS");
                $display("  Outputs: jump_bblock=%h, jump_index_addr=%h",
                         jump_bblock, jump_index_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: jump_bblock=%h, jump_index_addr=%h",
                         expected_jump_bblock, expected_jump_index_addr);
                $display("  Got:      jump_bblock=%h, jump_index_addr=%h",
                         jump_bblock, jump_index_addr);
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
        $dumpvars(0,core_sp_clk, fifo_pr_bblock, fifo_pr_nhop, previous_bblock, previous_nhop, reset, jump_bblock, jump_index_addr);
    end

endmodule
