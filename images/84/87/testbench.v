`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [23:0] SNES_ADDR;
    reg SNES_ROMSEL;
    wire [7:0] PA_addr;
    wire PA_enable;
    wire [12:0] bram_addr;
    wire bram_enable;
    wire irq_enable;
    wire linear_enable;
    wire linear_enable2;
    wire [23:0] ram0_addr;
    wire ram0_enable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .SNES_ADDR(SNES_ADDR),
        .SNES_ROMSEL(SNES_ROMSEL),
        .PA_addr(PA_addr),
        .PA_enable(PA_enable),
        .bram_addr(bram_addr),
        .bram_enable(bram_enable),
        .irq_enable(irq_enable),
        .linear_enable(linear_enable),
        .linear_enable2(linear_enable2),
        .ram0_addr(ram0_addr),
        .ram0_enable(ram0_enable)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        SNES_ADDR = 24'h000000;
        SNES_ROMSEL = 1'b1;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test %0d: WRAM Access (7E:1234)", test_num);
        SNES_ADDR = 24'h7E1234;
        SNES_ROMSEL = 1'b1;
        @(posedge CLK);
        #2;

        #1;


        check_outputs(8'h00, 1'b0, 13'h0000, 1'b0, 1'b0, 1'b0, 1'b0, 24'h7E1234, 1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test %0d: PA Register Access (00:2104)", test_num);
        SNES_ADDR = 24'h002104;
        SNES_ROMSEL = 1'b1;
        @(posedge CLK);
        #2;

        #1;


        check_outputs(8'h04, 1'b1, 13'h0000, 1'b0, 1'b0, 1'b0, 1'b0, 24'h002104, 1'b0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test %0d: BRAM Access (70:0ABC)", test_num);
        SNES_ADDR = 24'h700ABC;
        SNES_ROMSEL = 1'b1;
        @(posedge CLK);
        #2;

        #1;


        check_outputs(8'h00, 1'b0, 13'h0ABC, 1'b1, 1'b0, 1'b0, 1'b0, 24'h700ABC, 1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test %0d: ROM Selection (C0:0000)", test_num);
        SNES_ADDR = 24'hC00000;
        SNES_ROMSEL = 1'b0;
        @(posedge CLK);
        #2;


        #1;



        check_outputs(8'h00, 1'b0, 13'h0000, 1'b0, 1'b0, 1'b1, 1'b1, 24'hC00000, 1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test %0d: Mirror WRAM Access (00:0500)", test_num);
        SNES_ADDR = 24'h000500;
        SNES_ROMSEL = 1'b1;
        @(posedge CLK);
        #2;

        #1;


        check_outputs(8'h00, 1'b0, 13'h0000, 1'b0, 1'b0, 1'b0, 1'b0, 24'h000500, 1'b1);
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
        input [7:0] expected_PA_addr;
        input expected_PA_enable;
        input [12:0] expected_bram_addr;
        input expected_bram_enable;
        input expected_irq_enable;
        input expected_linear_enable;
        input expected_linear_enable2;
        input [23:0] expected_ram0_addr;
        input expected_ram0_enable;
        begin
            if (expected_PA_addr === (expected_PA_addr ^ PA_addr ^ expected_PA_addr) &&
                expected_PA_enable === (expected_PA_enable ^ PA_enable ^ expected_PA_enable) &&
                expected_bram_addr === (expected_bram_addr ^ bram_addr ^ expected_bram_addr) &&
                expected_bram_enable === (expected_bram_enable ^ bram_enable ^ expected_bram_enable) &&
                expected_irq_enable === (expected_irq_enable ^ irq_enable ^ expected_irq_enable) &&
                expected_linear_enable === (expected_linear_enable ^ linear_enable ^ expected_linear_enable) &&
                expected_linear_enable2 === (expected_linear_enable2 ^ linear_enable2 ^ expected_linear_enable2) &&
                expected_ram0_addr === (expected_ram0_addr ^ ram0_addr ^ expected_ram0_addr) &&
                expected_ram0_enable === (expected_ram0_enable ^ ram0_enable ^ expected_ram0_enable)) begin
                $display("PASS");
                $display("  Outputs: PA_addr=%h, PA_enable=%b, bram_addr=%h, bram_enable=%b, irq_enable=%b, linear_enable=%b, linear_enable2=%b, ram0_addr=%h, ram0_enable=%b",
                         PA_addr, PA_enable, bram_addr, bram_enable, irq_enable, linear_enable, linear_enable2, ram0_addr, ram0_enable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PA_addr=%h, PA_enable=%b, bram_addr=%h, bram_enable=%b, irq_enable=%b, linear_enable=%b, linear_enable2=%b, ram0_addr=%h, ram0_enable=%b",
                         expected_PA_addr, expected_PA_enable, expected_bram_addr, expected_bram_enable, expected_irq_enable, expected_linear_enable, expected_linear_enable2, expected_ram0_addr, expected_ram0_enable);
                $display("  Got:      PA_addr=%h, PA_enable=%b, bram_addr=%h, bram_enable=%b, irq_enable=%b, linear_enable=%b, linear_enable2=%b, ram0_addr=%h, ram0_enable=%b",
                         PA_addr, PA_enable, bram_addr, bram_enable, irq_enable, linear_enable, linear_enable2, ram0_addr, ram0_enable);
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
        $dumpvars(0,CLK, SNES_ADDR, SNES_ROMSEL, PA_addr, PA_enable, bram_addr, bram_enable, irq_enable, linear_enable, linear_enable2, ram0_addr, ram0_enable);
    end

endmodule
