`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_cog;
    reg clk_pll;
    reg [31:0] data;
    reg ena;
    reg [31:0] pin_in;
    reg setctr;
    reg setfrq;
    reg setphs;
    wire [32:0] phs;
    wire [31:0] pin_out;
    wire pll;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_cog(clk_cog),
        .clk_pll(clk_pll),
        .data(data),
        .ena(ena),
        .pin_in(pin_in),
        .setctr(setctr),
        .setfrq(setfrq),
        .setphs(setphs),
        .phs(phs),
        .pin_out(pin_out),
        .pll(pll)
    );

    // Clock generation (10ns period)
    initial begin
        clk_cog = 0;
        forever #5 clk_cog = ~clk_cog;
    end

        task reset_dut;

        begin
            ena = 0;
            setctr = 0;
            setfrq = 0;
            setphs = 0;
            data = 0;
            pin_in = 0;
            @(posedge clk_cog);

            data = 0;
            setctr = 1; setfrq = 1; setphs = 1;
            @(posedge clk_cog);
            setctr = 0; setfrq = 0; setphs = 0;
            @(posedge clk_cog);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            data = 32'd5;
            setfrq = 1;
            @(posedge clk_cog);
            setfrq = 0;


            data = 32'd0;
            setphs = 1;
            @(posedge clk_cog);
            setphs = 0;

            ena = 1;
            repeat(10) @(posedge clk_cog);
            ena = 0;
            @(posedge clk_cog);

            $display("Testcase 001: Basic Accumulation");
            #1;

            check_outputs(33'd50, 32'h0, 1'bz);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            data = 32'd10;
            setfrq = 1;
            @(posedge clk_cog);
            setfrq = 0;

            data = 32'd100;
            setphs = 1;
            @(posedge clk_cog);
            setphs = 0;

            ena = 1;
            repeat(5) @(posedge clk_cog);
            ena = 0;
            @(posedge clk_cog);

            $display("Testcase 002: Offset Phase Accumulation");
            #1;

            check_outputs(33'd150, 32'h0, 1'bz);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            data = 32'd100;
            setfrq = 1;
            @(posedge clk_cog);
            setfrq = 0;

            ena = 0;
            repeat(10) @(posedge clk_cog);

            $display("Testcase 003: Enable Gating (Disabled)");
            #1;

            check_outputs(33'd0, 32'h0, 1'bz);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            data = 32'h8000_0000;
            setfrq = 1;
            @(posedge clk_cog);
            setfrq = 0;

            ena = 1;
            repeat(3) @(posedge clk_cog);
            ena = 0;
            @(posedge clk_cog);

            $display("Testcase 004: Overflow into bit 32");
            #1;

            check_outputs(33'h1_8000_0000, 32'h0, 1'bz);
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
        input [32:0] expected_phs;
        input [31:0] expected_pin_out;
        input expected_pll;
        begin
            if (expected_phs === (expected_phs ^ phs ^ expected_phs) &&
                expected_pin_out === (expected_pin_out ^ pin_out ^ expected_pin_out) &&
                expected_pll === (expected_pll ^ pll ^ expected_pll)) begin
                $display("PASS");
                $display("  Outputs: phs=%h, pin_out=%h, pll=%b",
                         phs, pin_out, pll);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: phs=%h, pin_out=%h, pll=%b",
                         expected_phs, expected_pin_out, expected_pll);
                $display("  Got:      phs=%h, pin_out=%h, pll=%b",
                         phs, pin_out, pll);
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
        $dumpvars(0,clk_cog, clk_pll, data, ena, pin_in, setctr, setfrq, setphs, phs, pin_out, pll);
    end

endmodule
