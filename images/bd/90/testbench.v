`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg vin_vs;
    reg vout_vs;
    wire [1:0] rd_bank;
    wire [1:0] wr_bank;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst_n(rst_n),
        .vin_vs(vin_vs),
        .vout_vs(vout_vs),
        .rd_bank(rd_bank),
        .wr_bank(wr_bank)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            vin_vs = 0;
            vout_vs = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Reset verification");
            reset_dut();
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Single write edge detection");
            reset_dut();
            @(posedge clk);
            vin_vs = 1;
            repeat(2) @(posedge clk);
            vin_vs = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b00, 2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Single read edge detection");
            reset_dut();
            @(posedge clk);
            vout_vs = 1;
            repeat(2) @(posedge clk);
            vout_vs = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b01, 2'b00);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Test Case 004: Multiple write pulses (Bank 0 -> 1 -> 2 -> 3)");
            reset_dut();
            for(i = 0; i < 3; i = i + 1) begin
                @(posedge clk);
                vin_vs = 1;
                repeat(2) @(posedge clk);
                vin_vs = 0;
                repeat(2) @(posedge clk);
            end
            #1;

            check_outputs(2'b00, 2'b11);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Test Case 005: Write bank wrap around (4 pulses)");
            reset_dut();
            for(i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                vin_vs = 1;
                repeat(2) @(posedge clk);
                vin_vs = 0;
                repeat(2) @(posedge clk);
            end
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Test Case 006: Read bank wrap around (4 pulses)");
            reset_dut();
            for(i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                vout_vs = 1;
                repeat(2) @(posedge clk);
                vout_vs = 0;
                repeat(2) @(posedge clk);
            end
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Simultaneous write and read edges");
            reset_dut();
            @(posedge clk);
            vin_vs = 1;
            vout_vs = 1;
            repeat(2) @(posedge clk);
            vin_vs = 0;
            vout_vs = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Interleaved edges (2 Writes, 1 Read)");
            reset_dut();

            @(posedge clk); vin_vs = 1;
            @(posedge clk); vin_vs = 0;

            @(posedge clk); vout_vs = 1;
            @(posedge clk); vout_vs = 0;

            @(posedge clk); vin_vs = 1;
            @(posedge clk); vin_vs = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'b01, 2'b10);
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
        input [1:0] expected_rd_bank;
        input [1:0] expected_wr_bank;
        begin
            if (expected_rd_bank === (expected_rd_bank ^ rd_bank ^ expected_rd_bank) &&
                expected_wr_bank === (expected_wr_bank ^ wr_bank ^ expected_wr_bank)) begin
                $display("PASS");
                $display("  Outputs: rd_bank=%h, wr_bank=%h",
                         rd_bank, wr_bank);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd_bank=%h, wr_bank=%h",
                         expected_rd_bank, expected_wr_bank);
                $display("  Got:      rd_bank=%h, wr_bank=%h",
                         rd_bank, wr_bank);
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
        $dumpvars(0,clk, rst_n, vin_vs, vout_vs, rd_bank, wr_bank);
    end

endmodule
