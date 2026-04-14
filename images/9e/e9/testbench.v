`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg [23:0] ROM_MASK;
    reg [23:0] SAVERAM_MASK;
    reg [23:0] SNES_ADDR;
    reg SNES_ROMSEL;
    wire IS_ROM;
    wire IS_SAVERAM;
    wire [23:0] ROM_ADDR;
    wire ROM_HIT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .ROM_MASK(ROM_MASK),
        .SAVERAM_MASK(SAVERAM_MASK),
        .SNES_ADDR(SNES_ADDR),
        .SNES_ROMSEL(SNES_ROMSEL),
        .IS_ROM(IS_ROM),
        .IS_SAVERAM(IS_SAVERAM),
        .ROM_ADDR(ROM_ADDR),
        .ROM_HIT(ROM_HIT)
    );
    task testcase001;

    begin
        test_num = 1;

        SNES_ADDR = 24'h000000;
        SNES_ROMSEL = 1;
        ROM_MASK = 24'h3FFFFF;
        SAVERAM_MASK = 24'h007FFF;
        @(posedge CLK);


        SNES_ADDR = 24'h008000;
        SNES_ROMSEL = 0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b1, 1'b0, 24'h008000, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;

        SNES_ROMSEL = 1;
        @(posedge CLK);


        ROM_MASK = 24'h0FFFFF;
        SNES_ADDR = 24'h808000;
        SNES_ROMSEL = 0;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(1'b1, 1'b0, 24'h008000, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;

        SNES_ROMSEL = 1;
        @(posedge CLK);


        SNES_ADDR = 24'h700000;
        SNES_ROMSEL = 1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b0, 1'b1, 24'h700000 & SAVERAM_MASK, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;

        SNES_ROMSEL = 1;
        @(posedge CLK);


        SAVERAM_MASK = 24'h0007FF;
        SNES_ADDR = 24'h701234;
        SNES_ROMSEL = 1;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(1'b0, 1'b1, 24'h000234, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;

        SNES_ROMSEL = 1;
        @(posedge CLK);


        SNES_ADDR = 24'h002100;
        SNES_ROMSEL = 1;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(1'b0, 1'b0, 24'h0, 1'b0);
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
        input expected_IS_ROM;
        input expected_IS_SAVERAM;
        input [23:0] expected_ROM_ADDR;
        input expected_ROM_HIT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_IS_ROM === (expected_IS_ROM ^ IS_ROM ^ expected_IS_ROM) &&
                expected_IS_SAVERAM === (expected_IS_SAVERAM ^ IS_SAVERAM ^ expected_IS_SAVERAM) &&
                expected_ROM_ADDR === (expected_ROM_ADDR ^ ROM_ADDR ^ expected_ROM_ADDR) &&
                expected_ROM_HIT === (expected_ROM_HIT ^ ROM_HIT ^ expected_ROM_HIT)) begin
                $display("PASS");
                $display("  Outputs: IS_ROM=%b, IS_SAVERAM=%b, ROM_ADDR=%h, ROM_HIT=%b",
                         IS_ROM, IS_SAVERAM, ROM_ADDR, ROM_HIT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IS_ROM=%b, IS_SAVERAM=%b, ROM_ADDR=%h, ROM_HIT=%b",
                         expected_IS_ROM, expected_IS_SAVERAM, expected_ROM_ADDR, expected_ROM_HIT);
                $display("  Got:      IS_ROM=%b, IS_SAVERAM=%b, ROM_ADDR=%h, ROM_HIT=%b",
                         IS_ROM, IS_SAVERAM, ROM_ADDR, ROM_HIT);
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
