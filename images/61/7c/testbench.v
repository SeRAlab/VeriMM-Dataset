`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg [23:0] SNES_ADDR;
    reg [7:0] SNES_PA;
    reg SNES_ROMSEL;
    reg [15:0] featurebits;
    wire IS_ROM;
    wire IS_SAVERAM;
    wire IS_WRITABLE;
    wire [23:0] ROM_ADDR;
    wire ROM_HIT;
    wire button_addr;
    wire button_enable;
    wire msu_enable;
    wire r2100_hit;
    wire r213f_enable;
    wire sgb_enable;
    wire snescmd_enable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .SNES_ADDR(SNES_ADDR),
        .SNES_PA(SNES_PA),
        .SNES_ROMSEL(SNES_ROMSEL),
        .featurebits(featurebits),
        .IS_ROM(IS_ROM),
        .IS_SAVERAM(IS_SAVERAM),
        .IS_WRITABLE(IS_WRITABLE),
        .ROM_ADDR(ROM_ADDR),
        .ROM_HIT(ROM_HIT),
        .button_addr(button_addr),
        .button_enable(button_enable),
        .msu_enable(msu_enable),
        .r2100_hit(r2100_hit),
        .r213f_enable(r213f_enable),
        .sgb_enable(sgb_enable),
        .snescmd_enable(snescmd_enable)
    );
    task cycle_clk;

        begin
            CLK = 0; #5;
            CLK = 1; #5;
            CLK = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Basic ROM Access", test_num);
            featurebits = 16'hFFFF;
            SNES_ADDR = 24'h808000;
            SNES_PA = 8'h00;
            SNES_ROMSEL = 1'b0;

            cycle_clk();




            #1;





            check_outputs(
                1'b1,
                1'b0,
                1'b0,
                24'h000000,
                1'b1,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b0
            );
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Save RAM Access", test_num);
            featurebits = 16'hFFFF;
            SNES_ADDR = 24'h700000;
            SNES_PA = 8'h00;
            SNES_ROMSEL = 1'b1;

            cycle_clk();

            #1;


            check_outputs(
                1'b0,
                1'b1,
                1'b1,
                24'h700000,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b0
            );
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: MSU1 Enable via PA", test_num);
            featurebits = 16'h0001;
            SNES_ADDR = 24'h002000;
            SNES_PA = 8'h00;
            SNES_ROMSEL = 1'b1;

            cycle_clk();

            #1;


            check_outputs(
                1'b0,
                1'b0,
                1'b1,
                24'h002000,
                1'b0,
                1'b0,
                1'b0,
                1'b1,
                1'b0,
                1'b0,
                1'b0,
                1'b0
            );
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Register 2100 Detection", test_num);
            featurebits = 16'hFFFF;
            SNES_ADDR = 24'h002100;
            SNES_PA = 8'h00;
            SNES_ROMSEL = 1'b1;

            cycle_clk();

            #1;


            check_outputs(
                1'b0,
                1'b0,
                1'b1,
                24'h002100,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b1,
                1'b0,
                1'b0,
                1'b0
            );
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Feature Bits Disable Logic", test_num);
            featurebits = 16'h0000;
            SNES_ADDR = 24'h002000;
            SNES_PA = 8'h00;
            SNES_ROMSEL = 1'b1;

            cycle_clk();

            #1;


            check_outputs(
                1'b0,
                1'b0,
                1'b0,
                24'h002000,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b0
            );
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Register 213F Access", test_num);
            featurebits = 16'hFFFF;
            SNES_ADDR = 24'h00213F;
            SNES_PA = 8'h3F;
            SNES_ROMSEL = 1'b1;

            cycle_clk();

            #1;


            check_outputs(
                1'b0,
                1'b0,
                1'b0,
                24'h00213F,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b1,
                1'b0,
                1'b0
            );
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: HiROM Mapping Access", test_num);
            featurebits = 16'hFFFF;
            SNES_ADDR = 24'hC00000;
            SNES_PA = 8'h00;
            SNES_ROMSEL = 1'b0;

            cycle_clk();

            #1;


            check_outputs(
                1'b1,
                1'b0,
                1'b0,
                24'h000000,
                1'b1,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b0
            );
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
        input expected_IS_ROM;
        input expected_IS_SAVERAM;
        input expected_IS_WRITABLE;
        input [23:0] expected_ROM_ADDR;
        input expected_ROM_HIT;
        input expected_button_addr;
        input expected_button_enable;
        input expected_msu_enable;
        input expected_r2100_hit;
        input expected_r213f_enable;
        input expected_sgb_enable;
        input expected_snescmd_enable;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_IS_ROM === (expected_IS_ROM ^ IS_ROM ^ expected_IS_ROM) &&
                expected_IS_SAVERAM === (expected_IS_SAVERAM ^ IS_SAVERAM ^ expected_IS_SAVERAM) &&
                expected_IS_WRITABLE === (expected_IS_WRITABLE ^ IS_WRITABLE ^ expected_IS_WRITABLE) &&
                expected_ROM_ADDR === (expected_ROM_ADDR ^ ROM_ADDR ^ expected_ROM_ADDR) &&
                expected_ROM_HIT === (expected_ROM_HIT ^ ROM_HIT ^ expected_ROM_HIT) &&
                expected_button_addr === (expected_button_addr ^ button_addr ^ expected_button_addr) &&
                expected_button_enable === (expected_button_enable ^ button_enable ^ expected_button_enable) &&
                expected_msu_enable === (expected_msu_enable ^ msu_enable ^ expected_msu_enable) &&
                expected_r2100_hit === (expected_r2100_hit ^ r2100_hit ^ expected_r2100_hit) &&
                expected_r213f_enable === (expected_r213f_enable ^ r213f_enable ^ expected_r213f_enable) &&
                expected_sgb_enable === (expected_sgb_enable ^ sgb_enable ^ expected_sgb_enable) &&
                expected_snescmd_enable === (expected_snescmd_enable ^ snescmd_enable ^ expected_snescmd_enable)) begin
                $display("PASS");
                $display("  Outputs: IS_ROM=%b, IS_SAVERAM=%b, IS_WRITABLE=%b, ROM_ADDR=%h, ROM_HIT=%b, button_addr=%b, button_enable=%b, msu_enable=%b, r2100_hit=%b, r213f_enable=%b, sgb_enable=%b, snescmd_enable=%b",
                         IS_ROM, IS_SAVERAM, IS_WRITABLE, ROM_ADDR, ROM_HIT, button_addr, button_enable, msu_enable, r2100_hit, r213f_enable, sgb_enable, snescmd_enable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IS_ROM=%b, IS_SAVERAM=%b, IS_WRITABLE=%b, ROM_ADDR=%h, ROM_HIT=%b, button_addr=%b, button_enable=%b, msu_enable=%b, r2100_hit=%b, r213f_enable=%b, sgb_enable=%b, snescmd_enable=%b",
                         expected_IS_ROM, expected_IS_SAVERAM, expected_IS_WRITABLE, expected_ROM_ADDR, expected_ROM_HIT, expected_button_addr, expected_button_enable, expected_msu_enable, expected_r2100_hit, expected_r213f_enable, expected_sgb_enable, expected_snescmd_enable);
                $display("  Got:      IS_ROM=%b, IS_SAVERAM=%b, IS_WRITABLE=%b, ROM_ADDR=%h, ROM_HIT=%b, button_addr=%b, button_enable=%b, msu_enable=%b, r2100_hit=%b, r213f_enable=%b, sgb_enable=%b, snescmd_enable=%b",
                         IS_ROM, IS_SAVERAM, IS_WRITABLE, ROM_ADDR, ROM_HIT, button_addr, button_enable, msu_enable, r2100_hit, r213f_enable, sgb_enable, snescmd_enable);
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

endmodule
