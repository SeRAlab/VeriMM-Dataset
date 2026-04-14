`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg [2:0] MAPPER;
    reg [23:0] ROM_MASK;
    reg [23:0] SAVERAM_MASK;
    reg [23:0] SNES_ADDR;
    reg [7:0] SNES_PA;
    reg SNES_ROMSEL;
    reg [15:0] featurebits;
    wire IS_ROM;
    wire IS_SAVERAM;
    wire IS_WRITABLE;
    wire [23:0] ROM_ADDR;
    wire ROM_HIT;
    wire branch1_enable;
    wire branch2_enable;
    wire branch3_enable;
    wire cx4_enable;
    wire cx4_vect_enable;
    wire msu_enable;
    wire nmicmd_enable;
    wire r2100_hit;
    wire r213f_enable;
    wire return_vector_enable;
    wire snescmd_enable;

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
        .SNES_PA(SNES_PA),
        .SNES_ROMSEL(SNES_ROMSEL),
        .featurebits(featurebits),
        .IS_ROM(IS_ROM),
        .IS_SAVERAM(IS_SAVERAM),
        .IS_WRITABLE(IS_WRITABLE),
        .ROM_ADDR(ROM_ADDR),
        .ROM_HIT(ROM_HIT),
        .branch1_enable(branch1_enable),
        .branch2_enable(branch2_enable),
        .branch3_enable(branch3_enable),
        .cx4_enable(cx4_enable),
        .cx4_vect_enable(cx4_vect_enable),
        .msu_enable(msu_enable),
        .nmicmd_enable(nmicmd_enable),
        .r2100_hit(r2100_hit),
        .r213f_enable(r213f_enable),
        .return_vector_enable(return_vector_enable),
        .snescmd_enable(snescmd_enable)
    );
    task reset_inputs;

    begin
        CLK = 0;
        MAPPER = 3'b000;
        ROM_MASK = 24'hFFFFFF;
        SAVERAM_MASK = 24'h00FFFF;
        SNES_ADDR = 24'h000000;
        SNES_PA = 8'h00;
        SNES_ROMSEL = 1'b1;
        featurebits = 16'h0000;
    end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: LoROM ROM Access", test_num);
        reset_inputs();

        MAPPER = 3'b000;
        SNES_ROMSEL = 1'b0;
        SNES_ADDR = 24'h008000;
        SNES_PA = 8'h00;
        ROM_MASK = 24'h7FFFFF;

        #20;


        #1;



        check_outputs(1'b1, 1'b0, 1'b0, 24'h000000, 1'b1,
                      1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: HiROM ROM Access", test_num);
        reset_inputs();

        MAPPER = 3'b001;
        SNES_ROMSEL = 1'b0;
        SNES_ADDR = 24'hC00000;
        ROM_MASK = 24'hFFFFFF;

        #20;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 24'h000000, 1'b1,
                      1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: SaveRAM Access", test_num);
        reset_inputs();

        MAPPER = 3'b000;
        SNES_ROMSEL = 1'b1;
        SNES_ADDR = 24'h700000;
        SAVERAM_MASK = 24'h007FFF;

        #20;

        #1;


        check_outputs(1'b0, 1'b1, 1'b1, 24'h000000, 1'b0,
                      1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: MSU1 Feature Enable", test_num);
        reset_inputs();

        featurebits = 16'h0001;
        SNES_ADDR = 24'h002000;
        SNES_PA = 8'h21;

        #20;


        #1;



        check_outputs(1'b0, 1'b0, 1'b0, 24'h000000, 1'b0,
                      1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Cx4 Feature Enable", test_num);
        reset_inputs();

        featurebits = 16'h0002;
        SNES_ADDR = 24'h006000;
        SNES_ROMSEL = 1'b1;

        #20;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 24'h000000, 1'b0,
                      1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: R2100 Shadowing", test_num);
        reset_inputs();

        SNES_ADDR = 24'h002100;
        SNES_PA = 8'h21;

        #20;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 24'h000000, 1'b0,
                      1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Return Vector Feature", test_num);
        reset_inputs();

        featurebits = 16'h0010;
        SNES_ADDR = 24'h00FFE0;

        #20;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0, 24'h000000, 1'b0,
                      1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: ROM Masking Logic", test_num);
        reset_inputs();

        MAPPER = 3'b000;
        SNES_ROMSEL = 1'b0;
        SNES_ADDR = 24'h018000;
        ROM_MASK = 24'h007FFF;

        #20;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 24'h000000, 1'b1,
                      1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
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
        input expected_IS_ROM;
        input expected_IS_SAVERAM;
        input expected_IS_WRITABLE;
        input [23:0] expected_ROM_ADDR;
        input expected_ROM_HIT;
        input expected_branch1_enable;
        input expected_branch2_enable;
        input expected_branch3_enable;
        input expected_cx4_enable;
        input expected_cx4_vect_enable;
        input expected_msu_enable;
        input expected_nmicmd_enable;
        input expected_r2100_hit;
        input expected_r213f_enable;
        input expected_return_vector_enable;
        input expected_snescmd_enable;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_IS_ROM === (expected_IS_ROM ^ IS_ROM ^ expected_IS_ROM) &&
                expected_IS_SAVERAM === (expected_IS_SAVERAM ^ IS_SAVERAM ^ expected_IS_SAVERAM) &&
                expected_IS_WRITABLE === (expected_IS_WRITABLE ^ IS_WRITABLE ^ expected_IS_WRITABLE) &&
                expected_ROM_ADDR === (expected_ROM_ADDR ^ ROM_ADDR ^ expected_ROM_ADDR) &&
                expected_ROM_HIT === (expected_ROM_HIT ^ ROM_HIT ^ expected_ROM_HIT) &&
                expected_branch1_enable === (expected_branch1_enable ^ branch1_enable ^ expected_branch1_enable) &&
                expected_branch2_enable === (expected_branch2_enable ^ branch2_enable ^ expected_branch2_enable) &&
                expected_branch3_enable === (expected_branch3_enable ^ branch3_enable ^ expected_branch3_enable) &&
                expected_cx4_enable === (expected_cx4_enable ^ cx4_enable ^ expected_cx4_enable) &&
                expected_cx4_vect_enable === (expected_cx4_vect_enable ^ cx4_vect_enable ^ expected_cx4_vect_enable) &&
                expected_msu_enable === (expected_msu_enable ^ msu_enable ^ expected_msu_enable) &&
                expected_nmicmd_enable === (expected_nmicmd_enable ^ nmicmd_enable ^ expected_nmicmd_enable) &&
                expected_r2100_hit === (expected_r2100_hit ^ r2100_hit ^ expected_r2100_hit) &&
                expected_r213f_enable === (expected_r213f_enable ^ r213f_enable ^ expected_r213f_enable) &&
                expected_return_vector_enable === (expected_return_vector_enable ^ return_vector_enable ^ expected_return_vector_enable) &&
                expected_snescmd_enable === (expected_snescmd_enable ^ snescmd_enable ^ expected_snescmd_enable)) begin
                $display("PASS");
                $display("  Outputs: IS_ROM=%b, IS_SAVERAM=%b, IS_WRITABLE=%b, ROM_ADDR=%h, ROM_HIT=%b, branch1_enable=%b, branch2_enable=%b, branch3_enable=%b, cx4_enable=%b, cx4_vect_enable=%b, msu_enable=%b, nmicmd_enable=%b, r2100_hit=%b, r213f_enable=%b, return_vector_enable=%b, snescmd_enable=%b",
                         IS_ROM, IS_SAVERAM, IS_WRITABLE, ROM_ADDR, ROM_HIT, branch1_enable, branch2_enable, branch3_enable, cx4_enable, cx4_vect_enable, msu_enable, nmicmd_enable, r2100_hit, r213f_enable, return_vector_enable, snescmd_enable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IS_ROM=%b, IS_SAVERAM=%b, IS_WRITABLE=%b, ROM_ADDR=%h, ROM_HIT=%b, branch1_enable=%b, branch2_enable=%b, branch3_enable=%b, cx4_enable=%b, cx4_vect_enable=%b, msu_enable=%b, nmicmd_enable=%b, r2100_hit=%b, r213f_enable=%b, return_vector_enable=%b, snescmd_enable=%b",
                         expected_IS_ROM, expected_IS_SAVERAM, expected_IS_WRITABLE, expected_ROM_ADDR, expected_ROM_HIT, expected_branch1_enable, expected_branch2_enable, expected_branch3_enable, expected_cx4_enable, expected_cx4_vect_enable, expected_msu_enable, expected_nmicmd_enable, expected_r2100_hit, expected_r213f_enable, expected_return_vector_enable, expected_snescmd_enable);
                $display("  Got:      IS_ROM=%b, IS_SAVERAM=%b, IS_WRITABLE=%b, ROM_ADDR=%h, ROM_HIT=%b, branch1_enable=%b, branch2_enable=%b, branch3_enable=%b, cx4_enable=%b, cx4_vect_enable=%b, msu_enable=%b, nmicmd_enable=%b, r2100_hit=%b, r213f_enable=%b, return_vector_enable=%b, snescmd_enable=%b",
                         IS_ROM, IS_SAVERAM, IS_WRITABLE, ROM_ADDR, ROM_HIT, branch1_enable, branch2_enable, branch3_enable, cx4_enable, cx4_vect_enable, msu_enable, nmicmd_enable, r2100_hit, r213f_enable, return_vector_enable, snescmd_enable);
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
