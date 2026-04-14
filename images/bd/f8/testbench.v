`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [10:0] Q;
    reg clk;
    reg [63:0] din;
    reg [10:0] gcc0.gc0.count_d1_reg[10];
    reg out;
    reg ram_full_fb_i_reg;
    reg tmp_ram_rd_en;
    wire [63:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Q(Q),
        .clk(clk),
        .din(din),
        .gcc0.gc0.count_d1_reg[10](gcc0.gc0.count_d1_reg[10]),
        .out(out),
        .ram_full_fb_i_reg(ram_full_fb_i_reg),
        .tmp_ram_rd_en(tmp_ram_rd_en),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ram_full_fb_i_reg = 1'b0;
            tmp_ram_rd_en = 1'b0;
            Q = 11'h000;
            din = 64'h0;
            out = 1'b0;


            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Running testcase001: Load din...");

            ram_full_fb_i_reg = 1'b1;
            tmp_ram_rd_en = 1'b0;
            din = 64'hFEDCBA9876543210;

            @(posedge clk);
            #1;
            #1;

            check_outputs(64'hFEDCBA9876543210);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Running testcase002: Load Q (flags: 0, 0)...");

            ram_full_fb_i_reg = 1'b0;
            tmp_ram_rd_en = 1'b0;
            Q = 11'h5A5;
            din = 64'hFFFFFFFFFFFFFFFF;

            @(posedge clk);
            #1;

            #1;


            check_outputs(64'h00000000000005A5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Running testcase003: Load Q (flags: 1, 1)...");

            ram_full_fb_i_reg = 1'b1;
            tmp_ram_rd_en = 1'b1;
            Q = 11'h7FF;
            din = 64'hAAAAAAAAAAAAAAAA;

            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h00000000000007FF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Running testcase004: Load Q (flags: 0, 1)...");

            ram_full_fb_i_reg = 1'b0;
            tmp_ram_rd_en = 1'b1;
            Q = 11'h123;

            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0000000000000123);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Running testcase005: Sequential logic check...");


            ram_full_fb_i_reg = 1'b1;
            tmp_ram_rd_en = 1'b0;
            din = 64'h1234567812345678;
            @(posedge clk);
            #1;


            ram_full_fb_i_reg = 1'b0;
            Q = 11'h001;
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'h0000000000000001);
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
        input [63:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,Q, clk, din, gcc0.gc0.count_d1_reg[10], out, ram_full_fb_i_reg, tmp_ram_rd_en, dout);
    end

endmodule
