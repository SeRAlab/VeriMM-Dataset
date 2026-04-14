`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] bestmode;
    reg [5:0] bestmode16;
    reg [5:0] bestmode32;
    reg [6:0] blockcnt;
    reg clk;
    reg [5:0] cnt;
    reg finish;
    reg rstn;
    wire [6:0] md_waddr;
    wire [5:0] md_wdata;
    wire md_we;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bestmode(bestmode),
        .bestmode16(bestmode16),
        .bestmode32(bestmode32),
        .blockcnt(blockcnt),
        .clk(clk),
        .cnt(cnt),
        .finish(finish),
        .rstn(rstn),
        .md_waddr(md_waddr),
        .md_wdata(md_wdata),
        .md_we(md_we)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rstn = 0;
            cnt = 0;
            blockcnt = 0;
            bestmode = 0;
            bestmode16 = 0;
            bestmode32 = 0;
            finish = 0;
            repeat(5) @(posedge clk);
            rstn = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case 001: Basic write bestmode to address 0x0A");
            bestmode = 6'h21;
            blockcnt = 7'h0A;
            finish = 1;
            @(posedge clk);
            finish = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'h0A, 6'h21, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case 002: Boundary address check (0x7F)");
            bestmode = 6'h0F;
            blockcnt = 7'h7F;
            finish = 1;
            @(posedge clk);
            finish = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'h7F, 6'h0F, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case 003: No write check (finish=0)");
            bestmode = 6'h33;
            blockcnt = 7'h20;
            finish = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(md_waddr, md_wdata, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case 004: Max data value check (0x3F)");
            bestmode = 6'h3F;
            blockcnt = 7'h01;
            finish = 1;
            @(posedge clk);
            finish = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'h01, 6'h3F, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Reset state check");

            bestmode = 6'h15;
            blockcnt = 7'h10;
            finish = 1;
            @(posedge clk);

            rstn = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(7'h00, 6'h00, 1'b0);
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
        input [6:0] expected_md_waddr;
        input [5:0] expected_md_wdata;
        input expected_md_we;
        begin
            if (expected_md_waddr === (expected_md_waddr ^ md_waddr ^ expected_md_waddr) &&
                expected_md_wdata === (expected_md_wdata ^ md_wdata ^ expected_md_wdata) &&
                expected_md_we === (expected_md_we ^ md_we ^ expected_md_we)) begin
                $display("PASS");
                $display("  Outputs: md_waddr=%h, md_wdata=%h, md_we=%b",
                         md_waddr, md_wdata, md_we);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: md_waddr=%h, md_wdata=%h, md_we=%b",
                         expected_md_waddr, expected_md_wdata, expected_md_we);
                $display("  Got:      md_waddr=%h, md_wdata=%h, md_we=%b",
                         md_waddr, md_wdata, md_we);
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
        $dumpvars(0,bestmode, bestmode16, bestmode32, blockcnt, clk, cnt, finish, rstn, md_waddr, md_wdata, md_we);
    end

endmodule
