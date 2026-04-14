`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [23:0] SNES_ADDR;
    reg [7:0] ram0_bank;
    reg ram0_linear;
    wire [7:0] PA_addr;
    wire PA_enable;
    wire bank_enable;
    wire [12:0] bram_addr;
    wire bram_enable;
    wire irq_enable;
    wire linear_enable;
    wire [23:0] ram0_addr;
    wire ram0_enable;
    wire [18:0] ram1_addr;
    wire ram1_enable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .SNES_ADDR(SNES_ADDR),
        .ram0_bank(ram0_bank),
        .ram0_linear(ram0_linear),
        .PA_addr(PA_addr),
        .PA_enable(PA_enable),
        .bank_enable(bank_enable),
        .bram_addr(bram_addr),
        .bram_enable(bram_enable),
        .irq_enable(irq_enable),
        .linear_enable(linear_enable),
        .ram0_addr(ram0_addr),
        .ram0_enable(ram0_enable),
        .ram1_addr(ram1_addr),
        .ram1_enable(ram1_enable)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            SNES_ADDR = 24'h0;
            ram0_bank = 8'h0;
            ram0_linear = 1'b0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: WRAM (ram1) Access at $7E:2000");
            reset_dut();
            SNES_ADDR = 24'h7E2000;
            @(posedge CLK);
            #1;


            #1;



            check_outputs(8'h00, 1'b0, 1'b0, 13'h0, 1'b0, 1'b0, 1'b0, 24'h0, 1'b0, 19'h02000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Peripheral Address (PA) Access at $00:2130");
            reset_dut();
            SNES_ADDR = 24'h002130;
            @(posedge CLK);
            #1;


            #1;



            check_outputs(8'h30, 1'b1, 1'b0, 13'h0, 1'b0, 1'b0, 1'b0, 24'h0, 1'b0, 19'h0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: BRAM (SRAM) Access at $70:1000");
            reset_dut();
            SNES_ADDR = 24'h701000;
            @(posedge CLK);
            #1;


            #1;



            check_outputs(8'h00, 1'b0, 1'b0, 13'h1000, 1'b1, 1'b0, 1'b0, 24'h0, 1'b0, 19'h0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: RAM0 Access with Linear Addressing");
            reset_dut();
            SNES_ADDR = 24'hC00000;
            ram0_linear = 1'b1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'h00, 1'b0, 1'b0, 13'h0, 1'b0, 1'b0, 1'b1, 24'hC00000, 1'b1, 19'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: RAM0 Access with Banked Addressing");
            reset_dut();
            SNES_ADDR = 24'h008000;
            ram0_bank = 8'h05;
            ram0_linear = 1'b0;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'h00, 1'b0, 1'b1, 13'h0, 1'b0, 1'b0, 1'b0, 24'h058000, 1'b1, 19'h0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Checking Interrupt Request (IRQ) Enable Address");
            reset_dut();

            SNES_ADDR = 24'h002C00;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'h00, 1'b0, 1'b0, 13'h0, 1'b0, 1'b1, 1'b0, 24'h0, 1'b0, 19'h0, 1'b0);
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
        input [7:0] expected_PA_addr;
        input expected_PA_enable;
        input expected_bank_enable;
        input [12:0] expected_bram_addr;
        input expected_bram_enable;
        input expected_irq_enable;
        input expected_linear_enable;
        input [23:0] expected_ram0_addr;
        input expected_ram0_enable;
        input [18:0] expected_ram1_addr;
        input expected_ram1_enable;
        begin
            if (expected_PA_addr === (expected_PA_addr ^ PA_addr ^ expected_PA_addr) &&
                expected_PA_enable === (expected_PA_enable ^ PA_enable ^ expected_PA_enable) &&
                expected_bank_enable === (expected_bank_enable ^ bank_enable ^ expected_bank_enable) &&
                expected_bram_addr === (expected_bram_addr ^ bram_addr ^ expected_bram_addr) &&
                expected_bram_enable === (expected_bram_enable ^ bram_enable ^ expected_bram_enable) &&
                expected_irq_enable === (expected_irq_enable ^ irq_enable ^ expected_irq_enable) &&
                expected_linear_enable === (expected_linear_enable ^ linear_enable ^ expected_linear_enable) &&
                expected_ram0_addr === (expected_ram0_addr ^ ram0_addr ^ expected_ram0_addr) &&
                expected_ram0_enable === (expected_ram0_enable ^ ram0_enable ^ expected_ram0_enable) &&
                expected_ram1_addr === (expected_ram1_addr ^ ram1_addr ^ expected_ram1_addr) &&
                expected_ram1_enable === (expected_ram1_enable ^ ram1_enable ^ expected_ram1_enable)) begin
                $display("PASS");
                $display("  Outputs: PA_addr=%h, PA_enable=%b, bank_enable=%b, bram_addr=%h, bram_enable=%b, irq_enable=%b, linear_enable=%b, ram0_addr=%h, ram0_enable=%b, ram1_addr=%h, ram1_enable=%b",
                         PA_addr, PA_enable, bank_enable, bram_addr, bram_enable, irq_enable, linear_enable, ram0_addr, ram0_enable, ram1_addr, ram1_enable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PA_addr=%h, PA_enable=%b, bank_enable=%b, bram_addr=%h, bram_enable=%b, irq_enable=%b, linear_enable=%b, ram0_addr=%h, ram0_enable=%b, ram1_addr=%h, ram1_enable=%b",
                         expected_PA_addr, expected_PA_enable, expected_bank_enable, expected_bram_addr, expected_bram_enable, expected_irq_enable, expected_linear_enable, expected_ram0_addr, expected_ram0_enable, expected_ram1_addr, expected_ram1_enable);
                $display("  Got:      PA_addr=%h, PA_enable=%b, bank_enable=%b, bram_addr=%h, bram_enable=%b, irq_enable=%b, linear_enable=%b, ram0_addr=%h, ram0_enable=%b, ram1_addr=%h, ram1_enable=%b",
                         PA_addr, PA_enable, bank_enable, bram_addr, bram_enable, irq_enable, linear_enable, ram0_addr, ram0_enable, ram1_addr, ram1_enable);
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
        $dumpvars(0,CLK, SNES_ADDR, ram0_bank, ram0_linear, PA_addr, PA_enable, bank_enable, bram_addr, bram_enable, irq_enable, linear_enable, ram0_addr, ram0_enable, ram1_addr, ram1_enable);
    end

endmodule
