`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg RENDERER_CLK;
    reg [7:0] RENDERER_DATA;
    reg RENDERER_ENABLE;
    reg [10:0] RENDERER_POS_X;
    reg [9:0] RENDERER_POS_Y;
    reg RENDERER_SEL_BUFF;
    wire [18:0] RENDERER_ADDR;
    wire [4:0] RENDERER_BLUE;
    wire RENDERER_CE;
    wire [4:0] RENDERER_GREEN;
    wire RENDERER_OE;
    wire [4:0] RENDERER_RED;
    wire RENDERER_WE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RENDERER_CLK(RENDERER_CLK),
        .RENDERER_DATA(RENDERER_DATA),
        .RENDERER_ENABLE(RENDERER_ENABLE),
        .RENDERER_POS_X(RENDERER_POS_X),
        .RENDERER_POS_Y(RENDERER_POS_Y),
        .RENDERER_SEL_BUFF(RENDERER_SEL_BUFF),
        .RENDERER_ADDR(RENDERER_ADDR),
        .RENDERER_BLUE(RENDERER_BLUE),
        .RENDERER_CE(RENDERER_CE),
        .RENDERER_GREEN(RENDERER_GREEN),
        .RENDERER_OE(RENDERER_OE),
        .RENDERER_RED(RENDERER_RED),
        .RENDERER_WE(RENDERER_WE)
    );

    // Clock generation (10ns period)
    initial begin
        RENDERER_CLK = 0;
        forever #5 RENDERER_CLK = ~RENDERER_CLK;
    end

        task reset_dut;

    begin
        RENDERER_ENABLE = 0;
        RENDERER_POS_X = 0;
        RENDERER_POS_Y = 0;
        RENDERER_DATA = 0;
        RENDERER_SEL_BUFF = 0;
        repeat(2) @(posedge RENDERER_CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Disabled State");
        reset_dut();
        RENDERER_ENABLE = 0;
        RENDERER_POS_X = 11'd100;
        RENDERER_POS_Y = 10'd50;
        @(posedge RENDERER_CLK);
        #1;

        #1;


        check_outputs(19'h0, 5'h0, 1'b1, 5'h0, 1'b1, 5'h0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Origin (0,0) Red Color");
        reset_dut();
        RENDERER_ENABLE = 1;
        RENDERER_POS_X = 0;
        RENDERER_POS_Y = 0;
        RENDERER_SEL_BUFF = 0;
        RENDERER_DATA = 8'hE0;
        @(posedge RENDERER_CLK);
        #1;

        #1;


        check_outputs(19'h00000, 5'h00, 1'b0, 5'h00, 1'b0, 5'h1C, 1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Coord (10, 5) Green Color");
        reset_dut();
        RENDERER_ENABLE = 1;
        RENDERER_POS_X = 11'd10;
        RENDERER_POS_Y = 10'd5;
        RENDERER_SEL_BUFF = 0;
        RENDERER_DATA = 8'h1C;
        @(posedge RENDERER_CLK);
        #1;
        #1;

        check_outputs(19'h00C8A, 5'h00, 1'b0, 5'h1C, 1'b0, 5'h00, 1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Buffer 1 Offset Blue Color");
        reset_dut();
        RENDERER_ENABLE = 1;
        RENDERER_POS_X = 11'd0;
        RENDERER_POS_Y = 10'd0;
        RENDERER_SEL_BUFF = 1;
        RENDERER_DATA = 8'h03;
        @(posedge RENDERER_CLK);
        #1;
        #1;

        check_outputs(19'h40000, 5'h18, 1'b0, 5'h00, 1'b0, 5'h00, 1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Max Resolution White Color");
        reset_dut();
        RENDERER_ENABLE = 1;
        RENDERER_POS_X = 11'd639;
        RENDERER_POS_Y = 10'd479;
        RENDERER_SEL_BUFF = 0;
        RENDERER_DATA = 8'hFF;
        @(posedge RENDERER_CLK);
        #1;
        #1;

        check_outputs(19'h4AF3F, 5'h18, 1'b0, 5'h1C, 1'b0, 5'h1C, 1'b1);
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
        input [18:0] expected_RENDERER_ADDR;
        input [4:0] expected_RENDERER_BLUE;
        input expected_RENDERER_CE;
        input [4:0] expected_RENDERER_GREEN;
        input expected_RENDERER_OE;
        input [4:0] expected_RENDERER_RED;
        input expected_RENDERER_WE;
        begin
            if (expected_RENDERER_ADDR === (expected_RENDERER_ADDR ^ RENDERER_ADDR ^ expected_RENDERER_ADDR) &&
                expected_RENDERER_BLUE === (expected_RENDERER_BLUE ^ RENDERER_BLUE ^ expected_RENDERER_BLUE) &&
                expected_RENDERER_CE === (expected_RENDERER_CE ^ RENDERER_CE ^ expected_RENDERER_CE) &&
                expected_RENDERER_GREEN === (expected_RENDERER_GREEN ^ RENDERER_GREEN ^ expected_RENDERER_GREEN) &&
                expected_RENDERER_OE === (expected_RENDERER_OE ^ RENDERER_OE ^ expected_RENDERER_OE) &&
                expected_RENDERER_RED === (expected_RENDERER_RED ^ RENDERER_RED ^ expected_RENDERER_RED) &&
                expected_RENDERER_WE === (expected_RENDERER_WE ^ RENDERER_WE ^ expected_RENDERER_WE)) begin
                $display("PASS");
                $display("  Outputs: RENDERER_ADDR=%h, RENDERER_BLUE=%h, RENDERER_CE=%b, RENDERER_GREEN=%h, RENDERER_OE=%b, RENDERER_RED=%h, RENDERER_WE=%b",
                         RENDERER_ADDR, RENDERER_BLUE, RENDERER_CE, RENDERER_GREEN, RENDERER_OE, RENDERER_RED, RENDERER_WE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RENDERER_ADDR=%h, RENDERER_BLUE=%h, RENDERER_CE=%b, RENDERER_GREEN=%h, RENDERER_OE=%b, RENDERER_RED=%h, RENDERER_WE=%b",
                         expected_RENDERER_ADDR, expected_RENDERER_BLUE, expected_RENDERER_CE, expected_RENDERER_GREEN, expected_RENDERER_OE, expected_RENDERER_RED, expected_RENDERER_WE);
                $display("  Got:      RENDERER_ADDR=%h, RENDERER_BLUE=%h, RENDERER_CE=%b, RENDERER_GREEN=%h, RENDERER_OE=%b, RENDERER_RED=%h, RENDERER_WE=%b",
                         RENDERER_ADDR, RENDERER_BLUE, RENDERER_CE, RENDERER_GREEN, RENDERER_OE, RENDERER_RED, RENDERER_WE);
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
        $dumpvars(0,RENDERER_CLK, RENDERER_DATA, RENDERER_ENABLE, RENDERER_POS_X, RENDERER_POS_Y, RENDERER_SEL_BUFF, RENDERER_ADDR, RENDERER_BLUE, RENDERER_CE, RENDERER_GREEN, RENDERER_OE, RENDERER_RED, RENDERER_WE);
    end

endmodule
