`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [23:0] addr;
    reg clk;
    reg rst;
    wire [15:0] dout;
    wire rdy;
    wire [22:0] sram_addr;
    wire sram_adv;
    wire sram_ce;
    wire sram_clk;
    wire sram_cre;
    wire sram_lb;
    wire sram_oe;
    wire sram_ub;
    wire sram_we;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .rst(rst),
        .dout(dout),
        .rdy(rdy),
        .sram_addr(sram_addr),
        .sram_adv(sram_adv),
        .sram_ce(sram_ce),
        .sram_clk(sram_clk),
        .sram_cre(sram_cre),
        .sram_lb(sram_lb),
        .sram_oe(sram_oe),
        .sram_ub(sram_ub),
        .sram_we(sram_we)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        addr = 0;
        drive_en = 0;
        sram_data_drive = 0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        repeat(1) @(posedge clk);
    end
        endtask
    task simulate_sram_read;

        input [15:0] data_to_provide;
        begin

            wait(sram_ce == 0 && sram_oe == 0);
            drive_en = 1;
            sram_data_drive = data_to_provide;

            wait(rdy == 1);
            @(posedge clk);
            drive_en = 0;
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Reset State Check");
        reset_dut();

        #1;


        check_outputs(16'h0000, 1'b1, 23'h0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Basic Read Operation");
        reset_dut();

        addr = 24'hABCDEF;


        fork
            simulate_sram_read(16'h1234);
        join_none


        wait(rdy == 0);
        wait(rdy == 1);
        #2;


        #1;



        check_outputs(16'h1234, 1'b1, 23'h55E6F7, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Read from Address 0x555554");
        reset_dut();

        addr = 24'h555554;

        fork
            simulate_sram_read(16'hAAAA);
        join_none

        wait(rdy == 0);
        wait(rdy == 1);
        #2;


        #1;



        check_outputs(16'hAAAA, 1'b1, 23'h2AAAAA, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1);
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
        input [15:0] expected_dout;
        input expected_rdy;
        input [22:0] expected_sram_addr;
        input expected_sram_adv;
        input expected_sram_ce;
        input expected_sram_clk;
        input expected_sram_cre;
        input expected_sram_lb;
        input expected_sram_oe;
        input expected_sram_ub;
        input expected_sram_we;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_rdy === (expected_rdy ^ rdy ^ expected_rdy) &&
                expected_sram_addr === (expected_sram_addr ^ sram_addr ^ expected_sram_addr) &&
                expected_sram_adv === (expected_sram_adv ^ sram_adv ^ expected_sram_adv) &&
                expected_sram_ce === (expected_sram_ce ^ sram_ce ^ expected_sram_ce) &&
                expected_sram_clk === (expected_sram_clk ^ sram_clk ^ expected_sram_clk) &&
                expected_sram_cre === (expected_sram_cre ^ sram_cre ^ expected_sram_cre) &&
                expected_sram_lb === (expected_sram_lb ^ sram_lb ^ expected_sram_lb) &&
                expected_sram_oe === (expected_sram_oe ^ sram_oe ^ expected_sram_oe) &&
                expected_sram_ub === (expected_sram_ub ^ sram_ub ^ expected_sram_ub) &&
                expected_sram_we === (expected_sram_we ^ sram_we ^ expected_sram_we)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, rdy=%b, sram_addr=%h, sram_adv=%b, sram_ce=%b, sram_clk=%b, sram_cre=%b, sram_lb=%b, sram_oe=%b, sram_ub=%b, sram_we=%b",
                         dout, rdy, sram_addr, sram_adv, sram_ce, sram_clk, sram_cre, sram_lb, sram_oe, sram_ub, sram_we);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, rdy=%b, sram_addr=%h, sram_adv=%b, sram_ce=%b, sram_clk=%b, sram_cre=%b, sram_lb=%b, sram_oe=%b, sram_ub=%b, sram_we=%b",
                         expected_dout, expected_rdy, expected_sram_addr, expected_sram_adv, expected_sram_ce, expected_sram_clk, expected_sram_cre, expected_sram_lb, expected_sram_oe, expected_sram_ub, expected_sram_we);
                $display("  Got:      dout=%h, rdy=%b, sram_addr=%h, sram_adv=%b, sram_ce=%b, sram_clk=%b, sram_cre=%b, sram_lb=%b, sram_oe=%b, sram_ub=%b, sram_we=%b",
                         dout, rdy, sram_addr, sram_adv, sram_ce, sram_clk, sram_cre, sram_lb, sram_oe, sram_ub, sram_we);
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
        $dumpvars(0,addr, clk, rst, dout, rdy, sram_addr, sram_adv, sram_ce, sram_clk, sram_cre, sram_lb, sram_oe, sram_ub, sram_we);
    end

endmodule
