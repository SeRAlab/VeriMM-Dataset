`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [12:0] addr_in;
    reg clk;
    wire [9:0] bank0_addr;
    wire [9:0] bank1_addr;
    wire [9:0] bank2_addr;
    wire [9:0] bank3_addr;
    wire odd;
    wire [1:0] sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_in(addr_in),
        .clk(clk),
        .bank0_addr(bank0_addr),
        .bank1_addr(bank1_addr),
        .bank2_addr(bank2_addr),
        .bank3_addr(bank3_addr),
        .odd(odd),
        .sel(sel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr_in = 0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            addr_in = 13'h0000;
            repeat(2) @(posedge clk);
            #1;
            $display("Test 001: Address 0x0000");
            #1;

            check_outputs(10'h000, 10'h000, 10'h000, 10'h000, 1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            addr_in = 13'h0001;
            repeat(2) @(posedge clk);
            #1;
            $display("Test 002: Address 0x0001 (Odd Bit)");
            #1;

            check_outputs(10'h000, 10'h000, 10'h000, 10'h000, 1'b1, 2'b00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            addr_in = 13'h0002;
            repeat(2) @(posedge clk);
            #1;
            $display("Test 003: Address 0x0002 (Bank Addr 1)");
            #1;

            check_outputs(10'h001, 10'h001, 10'h001, 10'h001, 1'b0, 2'b00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            addr_in = 13'h0800;
            repeat(2) @(posedge clk);
            #1;
            $display("Test 004: Address 0x0800 (Sel 1)");
            #1;

            check_outputs(10'h000, 10'h000, 10'h000, 10'h000, 1'b0, 2'b01);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            addr_in = 13'h1000;
            repeat(2) @(posedge clk);
            #1;
            $display("Test 005: Address 0x1000 (Sel 2)");
            #1;

            check_outputs(10'h000, 10'h000, 10'h000, 10'h000, 1'b0, 2'b10);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            addr_in = 13'h1800;
            repeat(2) @(posedge clk);
            #1;
            $display("Test 006: Address 0x1800 (Sel 3)");
            #1;

            check_outputs(10'h000, 10'h000, 10'h000, 10'h000, 1'b0, 2'b11);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            addr_in = 13'h1FFF;
            repeat(2) @(posedge clk);
            #1;
            $display("Test 007: Address 0x1FFF (Max Values)");
            #1;

            check_outputs(10'h3FF, 10'h3FF, 10'h3FF, 10'h3FF, 1'b1, 2'b11);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            addr_in = 13'h0AAA;
            repeat(2) @(posedge clk);
            #1;
            $display("Test 008: Address 0x0AAA (Alternating Bits)");
            #1;

            check_outputs(10'h155, 10'h155, 10'h155, 10'h155, 1'b0, 2'b01);
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
        input [9:0] expected_bank0_addr;
        input [9:0] expected_bank1_addr;
        input [9:0] expected_bank2_addr;
        input [9:0] expected_bank3_addr;
        input expected_odd;
        input [1:0] expected_sel;
        begin
            if (expected_bank0_addr === (expected_bank0_addr ^ bank0_addr ^ expected_bank0_addr) &&
                expected_bank1_addr === (expected_bank1_addr ^ bank1_addr ^ expected_bank1_addr) &&
                expected_bank2_addr === (expected_bank2_addr ^ bank2_addr ^ expected_bank2_addr) &&
                expected_bank3_addr === (expected_bank3_addr ^ bank3_addr ^ expected_bank3_addr) &&
                expected_odd === (expected_odd ^ odd ^ expected_odd) &&
                expected_sel === (expected_sel ^ sel ^ expected_sel)) begin
                $display("PASS");
                $display("  Outputs: bank0_addr=%h, bank1_addr=%h, bank2_addr=%h, bank3_addr=%h, odd=%b, sel=%h",
                         bank0_addr, bank1_addr, bank2_addr, bank3_addr, odd, sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bank0_addr=%h, bank1_addr=%h, bank2_addr=%h, bank3_addr=%h, odd=%b, sel=%h",
                         expected_bank0_addr, expected_bank1_addr, expected_bank2_addr, expected_bank3_addr, expected_odd, expected_sel);
                $display("  Got:      bank0_addr=%h, bank1_addr=%h, bank2_addr=%h, bank3_addr=%h, odd=%b, sel=%h",
                         bank0_addr, bank1_addr, bank2_addr, bank3_addr, odd, sel);
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
        $dumpvars(0,addr_in, clk, bank0_addr, bank1_addr, bank2_addr, bank3_addr, odd, sel);
    end

endmodule
