`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg [2:0] MAPPER;
    reg [23:0] ROM_MASK;
    reg [23:0] SAVERAM_MASK;
    reg [23:0] SNES_ADDR;
    reg SNES_CS;
    reg [7:0] SNES_PA;
    reg use_msu1;
    wire IS_ROM;
    wire IS_SAVERAM;
    wire IS_WRITABLE;
    wire [23:0] ROM_ADDR;
    wire ROM_SEL;
    wire cx4_enable;
    wire cx4_vect_enable;
    wire msu_enable;
    wire r213f_enable;
    wire snescmd_rd_enable;
    wire snescmd_wr_enable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .MAPPER(MAPPER),
        .ROM_MASK(ROM_MASK),
        .SAVERAM_MASK(SAVERAM_MASK),
        .SNES_ADDR(SNES_ADDR),
        .SNES_CS(SNES_CS),
        .SNES_PA(SNES_PA),
        .use_msu1(use_msu1),
        .IS_ROM(IS_ROM),
        .IS_SAVERAM(IS_SAVERAM),
        .IS_WRITABLE(IS_WRITABLE),
        .ROM_ADDR(ROM_ADDR),
        .ROM_SEL(ROM_SEL),
        .cx4_enable(cx4_enable),
        .cx4_vect_enable(cx4_vect_enable),
        .msu_enable(msu_enable),
        .r213f_enable(r213f_enable),
        .snescmd_rd_enable(snescmd_rd_enable),
        .snescmd_wr_enable(snescmd_wr_enable)
    );
    task reset_inputs;

        begin
            MAPPER = 3'b000;
            ROM_MASK = 24'hFFFFFF;
            SAVERAM_MASK = 24'h00FFFF;
            SNES_ADDR = 24'h000000;
            SNES_CS = 1'b1;
            SNES_PA = 8'h00;
            use_msu1 = 1'b0;
            CLK = 0;
            #10;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: LoROM ROM Access (Bank 00, Offset 8000)", test_num);
            reset_inputs();
            MAPPER = 3'b000;
            SNES_ADDR = 24'h008000;
            SNES_CS = 1'b0;



            #1;




            check_outputs(1'b1, 1'b0, 1'b0, 24'h000000, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: SaveRAM Access (Bank 70, Offset 0000)", test_num);
            reset_inputs();
            MAPPER = 3'b000;
            SNES_ADDR = 24'h700000;
            SNES_CS = 1'b0;


            #1;



            check_outputs(1'b0, 1'b1, 1'b1, 24'h000000, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: HiROM ROM Access (Bank C0, Offset 0000)", test_num);
            reset_inputs();
            MAPPER = 3'b001;
            SNES_ADDR = 24'hC00000;
            SNES_CS = 1'b0;


            #1;



            check_outputs(1'b1, 1'b0, 1'b0, 24'h000000, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: MSU1 Enable Check", test_num);
            reset_inputs();
            use_msu1 = 1'b1;
            SNES_ADDR = 24'h002004;
            SNES_CS = 1'b1;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 24'h000000, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: CX4 Enable Check", test_num);
            reset_inputs();
            MAPPER = 3'b011;
            SNES_ADDR = 24'h006000;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 24'h000000, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Register 213F Enable", test_num);
            reset_inputs();
            SNES_PA = 8'h3F;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 24'h000000, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0);
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
        input expected_IS_ROM;
        input expected_IS_SAVERAM;
        input expected_IS_WRITABLE;
        input [23:0] expected_ROM_ADDR;
        input expected_ROM_SEL;
        input expected_cx4_enable;
        input expected_cx4_vect_enable;
        input expected_msu_enable;
        input expected_r213f_enable;
        input expected_snescmd_rd_enable;
        input expected_snescmd_wr_enable;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_IS_ROM === (expected_IS_ROM ^ IS_ROM ^ expected_IS_ROM) &&
                expected_IS_SAVERAM === (expected_IS_SAVERAM ^ IS_SAVERAM ^ expected_IS_SAVERAM) &&
                expected_IS_WRITABLE === (expected_IS_WRITABLE ^ IS_WRITABLE ^ expected_IS_WRITABLE) &&
                expected_ROM_ADDR === (expected_ROM_ADDR ^ ROM_ADDR ^ expected_ROM_ADDR) &&
                expected_ROM_SEL === (expected_ROM_SEL ^ ROM_SEL ^ expected_ROM_SEL) &&
                expected_cx4_enable === (expected_cx4_enable ^ cx4_enable ^ expected_cx4_enable) &&
                expected_cx4_vect_enable === (expected_cx4_vect_enable ^ cx4_vect_enable ^ expected_cx4_vect_enable) &&
                expected_msu_enable === (expected_msu_enable ^ msu_enable ^ expected_msu_enable) &&
                expected_r213f_enable === (expected_r213f_enable ^ r213f_enable ^ expected_r213f_enable) &&
                expected_snescmd_rd_enable === (expected_snescmd_rd_enable ^ snescmd_rd_enable ^ expected_snescmd_rd_enable) &&
                expected_snescmd_wr_enable === (expected_snescmd_wr_enable ^ snescmd_wr_enable ^ expected_snescmd_wr_enable)) begin
                $display("PASS");
                $display("  Outputs: IS_ROM=%b, IS_SAVERAM=%b, IS_WRITABLE=%b, ROM_ADDR=%h, ROM_SEL=%b, cx4_enable=%b, cx4_vect_enable=%b, msu_enable=%b, r213f_enable=%b, snescmd_rd_enable=%b, snescmd_wr_enable=%b",
                         IS_ROM, IS_SAVERAM, IS_WRITABLE, ROM_ADDR, ROM_SEL, cx4_enable, cx4_vect_enable, msu_enable, r213f_enable, snescmd_rd_enable, snescmd_wr_enable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IS_ROM=%b, IS_SAVERAM=%b, IS_WRITABLE=%b, ROM_ADDR=%h, ROM_SEL=%b, cx4_enable=%b, cx4_vect_enable=%b, msu_enable=%b, r213f_enable=%b, snescmd_rd_enable=%b, snescmd_wr_enable=%b",
                         expected_IS_ROM, expected_IS_SAVERAM, expected_IS_WRITABLE, expected_ROM_ADDR, expected_ROM_SEL, expected_cx4_enable, expected_cx4_vect_enable, expected_msu_enable, expected_r213f_enable, expected_snescmd_rd_enable, expected_snescmd_wr_enable);
                $display("  Got:      IS_ROM=%b, IS_SAVERAM=%b, IS_WRITABLE=%b, ROM_ADDR=%h, ROM_SEL=%b, cx4_enable=%b, cx4_vect_enable=%b, msu_enable=%b, r213f_enable=%b, snescmd_rd_enable=%b, snescmd_wr_enable=%b",
                         IS_ROM, IS_SAVERAM, IS_WRITABLE, ROM_ADDR, ROM_SEL, cx4_enable, cx4_vect_enable, msu_enable, r213f_enable, snescmd_rd_enable, snescmd_wr_enable);
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
