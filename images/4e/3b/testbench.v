`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CMD_CLK;
    reg [31:0] CMD_DST;
    reg [31:0] CMD_LEN;
    reg CMD_REQ;
    reg [31:0] CMD_SRC;
    reg RD_READY;
    reg RST_N;
    reg WR_READY;
    wire CMD_DONE;
    wire CMD_READY;
    wire FIFO_RST;
    wire [31:0] RD_ADRS;
    wire [31:0] RD_COUNT;
    wire RD_START;
    wire [31:0] WR_ADRS;
    wire [31:0] WR_COUNT;
    wire WR_START;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CMD_CLK(CMD_CLK),
        .CMD_DST(CMD_DST),
        .CMD_LEN(CMD_LEN),
        .CMD_REQ(CMD_REQ),
        .CMD_SRC(CMD_SRC),
        .RD_READY(RD_READY),
        .RST_N(RST_N),
        .WR_READY(WR_READY),
        .CMD_DONE(CMD_DONE),
        .CMD_READY(CMD_READY),
        .FIFO_RST(FIFO_RST),
        .RD_ADRS(RD_ADRS),
        .RD_COUNT(RD_COUNT),
        .RD_START(RD_START),
        .WR_ADRS(WR_ADRS),
        .WR_COUNT(WR_COUNT),
        .WR_START(WR_START)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RST_N = 0;
        CMD_REQ = 0;
        CMD_DST = 0;
        CMD_SRC = 0;
        CMD_LEN = 0;
        RD_READY = 0;
        WR_READY = 0;
        #20;
        RST_N = 1;
        #20;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nRunning Testcase 001: Basic Memory Copy...");
        reset_dut();

        @(posedge CLK);

        CMD_SRC = 32'h1000_0000;
        CMD_DST = 32'h2000_0000;
        CMD_LEN = 32'h0000_0100;
        CMD_REQ = 1;


        wait(CMD_READY == 1);
        @(posedge CLK);
        CMD_REQ = 0;


        RD_READY = 1;
        WR_READY = 1;


        wait(CMD_DONE == 1);
        @(posedge CLK);



        #1;




        check_outputs(1'b1, 1'b1, 1'b0, 32'h1000_0000, 32'h0000_0100, 1'b0, 32'h2000_0000, 32'h0000_0100, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nRunning Testcase 002: Small Block Copy...");
        reset_dut();

        @(posedge CLK);
        CMD_SRC = 32'hAAAA_BBBB;
        CMD_DST = 32'hCCCC_DDDD;
        CMD_LEN = 32'h0000_0004;
        CMD_REQ = 1;

        wait(CMD_READY == 1);
        @(posedge CLK);
        CMD_REQ = 0;

        RD_READY = 1;
        WR_READY = 1;

        wait(CMD_DONE == 1);
        @(posedge CLK);

        #1;


        check_outputs(1'b1, 1'b1, 1'b0, 32'hAAAA_BBBB, 32'h0000_0004, 1'b0, 32'hCCCC_DDDD, 32'h0000_0004, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nRunning Testcase 003: Latency Simulation...");
        reset_dut();

        @(posedge CLK);
        CMD_SRC = 32'h5555_0000;
        CMD_DST = 32'h6666_0000;
        CMD_LEN = 32'h0000_0020;
        CMD_REQ = 1;

        wait(CMD_READY == 1);
        @(posedge CLK);
        CMD_REQ = 0;


        #50;
        RD_READY = 1;


        #50;
        WR_READY = 1;

        wait(CMD_DONE == 1);
        @(posedge CLK);

        #1;


        check_outputs(1'b1, 1'b1, 1'b0, 32'h5555_0000, 32'h0000_0020, 1'b0, 32'h6666_0000, 32'h0000_0020, 1'b0);
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
        input expected_CMD_DONE;
        input expected_CMD_READY;
        input expected_FIFO_RST;
        input [31:0] expected_RD_ADRS;
        input [31:0] expected_RD_COUNT;
        input expected_RD_START;
        input [31:0] expected_WR_ADRS;
        input [31:0] expected_WR_COUNT;
        input expected_WR_START;
        begin
            if (expected_CMD_DONE === (expected_CMD_DONE ^ CMD_DONE ^ expected_CMD_DONE) &&
                expected_CMD_READY === (expected_CMD_READY ^ CMD_READY ^ expected_CMD_READY) &&
                expected_FIFO_RST === (expected_FIFO_RST ^ FIFO_RST ^ expected_FIFO_RST) &&
                expected_RD_ADRS === (expected_RD_ADRS ^ RD_ADRS ^ expected_RD_ADRS) &&
                expected_RD_COUNT === (expected_RD_COUNT ^ RD_COUNT ^ expected_RD_COUNT) &&
                expected_RD_START === (expected_RD_START ^ RD_START ^ expected_RD_START) &&
                expected_WR_ADRS === (expected_WR_ADRS ^ WR_ADRS ^ expected_WR_ADRS) &&
                expected_WR_COUNT === (expected_WR_COUNT ^ WR_COUNT ^ expected_WR_COUNT) &&
                expected_WR_START === (expected_WR_START ^ WR_START ^ expected_WR_START)) begin
                $display("PASS");
                $display("  Outputs: CMD_DONE=%b, CMD_READY=%b, FIFO_RST=%b, RD_ADRS=%h, RD_COUNT=%h, RD_START=%b, WR_ADRS=%h, WR_COUNT=%h, WR_START=%b",
                         CMD_DONE, CMD_READY, FIFO_RST, RD_ADRS, RD_COUNT, RD_START, WR_ADRS, WR_COUNT, WR_START);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CMD_DONE=%b, CMD_READY=%b, FIFO_RST=%b, RD_ADRS=%h, RD_COUNT=%h, RD_START=%b, WR_ADRS=%h, WR_COUNT=%h, WR_START=%b",
                         expected_CMD_DONE, expected_CMD_READY, expected_FIFO_RST, expected_RD_ADRS, expected_RD_COUNT, expected_RD_START, expected_WR_ADRS, expected_WR_COUNT, expected_WR_START);
                $display("  Got:      CMD_DONE=%b, CMD_READY=%b, FIFO_RST=%b, RD_ADRS=%h, RD_COUNT=%h, RD_START=%b, WR_ADRS=%h, WR_COUNT=%h, WR_START=%b",
                         CMD_DONE, CMD_READY, FIFO_RST, RD_ADRS, RD_COUNT, RD_START, WR_ADRS, WR_COUNT, WR_START);
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
        $dumpvars(0,CLK, CMD_CLK, CMD_DST, CMD_LEN, CMD_REQ, CMD_SRC, RD_READY, RST_N, WR_READY, CMD_DONE, CMD_READY, FIFO_RST, RD_ADRS, RD_COUNT, RD_START, WR_ADRS, WR_COUNT, WR_START);
    end

endmodule
