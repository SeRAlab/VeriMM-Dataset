`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] a;
    reg clk;
    reg [15:0] d;
    reg [9:0] dpra;
    reg i_ce;
    reg qdpo_ce;
    reg qdpo_clk;
    reg qdpo_rst;
    reg qdpo_srst;
    reg qspo_ce;
    reg qspo_rst;
    reg qspo_srst;
    reg we;
    wire [15:0] dpo;
    wire [15:0] qdpo;
    wire [15:0] qspo;
    wire [15:0] spo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .d(d),
        .dpra(dpra),
        .i_ce(i_ce),
        .qdpo_ce(qdpo_ce),
        .qdpo_clk(qdpo_clk),
        .qdpo_rst(qdpo_rst),
        .qdpo_srst(qdpo_srst),
        .qspo_ce(qspo_ce),
        .qspo_rst(qspo_rst),
        .qspo_srst(qspo_srst),
        .we(we),
        .dpo(dpo),
        .qdpo(qdpo),
        .qspo(qspo),
        .spo(spo)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0; d = 0; dpra = 0; we = 0; i_ce = 1;
            qspo_ce = 0; qdpo_ce = 0;
            qspo_rst = 1; qdpo_rst = 1;
            qspo_srst = 0; qdpo_srst = 0;
            #20;
            qspo_rst = 0; qdpo_rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            @(posedge clk);
            we = 1; a = 10'h00A; d = 16'hAAAA;
            @(posedge clk);
            we = 0;

            qspo_ce = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hxxxx, 16'hxxxx, 16'hAAAA, 16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clk);
            we = 1; a = 10'h055; d = 16'h5555;
            @(posedge clk);
            we = 0;
            dpra = 10'h055;

            qdpo_ce = 1;
            @(posedge qdpo_clk);
            #1;
            #1;

            check_outputs(16'h5555, 16'h5555, 16'hxxxx, 16'hxxxx);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            we = 1; a = 10'h100; d = 16'h1234;
            @(posedge clk);
            we = 0;

            qspo_ce = 1; @(posedge clk);

            we = 1; a = 10'h100; d = 16'hFFFF;
            @(posedge clk);
            we = 0; qspo_ce = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hxxxx, 16'hxxxx, 16'h1234, 16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            we = 1; a = 10'h001; d = 16'hBEEF;
            @(posedge clk);
            qspo_ce = 1; @(posedge clk);
            #1;

            qspo_srst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hxxxx, 16'hxxxx, 16'h0000, 16'hBEEF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            we = 1; a = 10'h3FF; d = 16'hC0DE;
            @(posedge clk);
            dpra = 10'h3FF;
            qdpo_ce = 1; @(posedge qdpo_clk);
            #1;

            qdpo_rst = 1;
            #5;
            #1;

            check_outputs(16'hC0DE, 16'h0000, 16'hxxxx, 16'hxxxx);
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
        input [15:0] expected_dpo;
        input [15:0] expected_qdpo;
        input [15:0] expected_qspo;
        input [15:0] expected_spo;
        begin
            if (expected_dpo === (expected_dpo ^ dpo ^ expected_dpo) &&
                expected_qdpo === (expected_qdpo ^ qdpo ^ expected_qdpo) &&
                expected_qspo === (expected_qspo ^ qspo ^ expected_qspo) &&
                expected_spo === (expected_spo ^ spo ^ expected_spo)) begin
                $display("PASS");
                $display("  Outputs: dpo=%h, qdpo=%h, qspo=%h, spo=%h",
                         dpo, qdpo, qspo, spo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dpo=%h, qdpo=%h, qspo=%h, spo=%h",
                         expected_dpo, expected_qdpo, expected_qspo, expected_spo);
                $display("  Got:      dpo=%h, qdpo=%h, qspo=%h, spo=%h",
                         dpo, qdpo, qspo, spo);
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
        $dumpvars(0,a, clk, d, dpra, i_ce, qdpo_ce, qdpo_clk, qdpo_rst, qdpo_srst, qspo_ce, qspo_rst, qspo_srst, we, dpo, qdpo, qspo, spo);
    end

endmodule
