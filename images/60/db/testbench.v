`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] aluCalcIn;
    reg [31:0] aluCondIn;
    reg clk;
    reg [3:0] destRegIn;
    reg [1:0] dstMuxIn;
    reg flush;
    reg isLWIn;
    reg memWrEnIn;
    reg [3:0] opIn;
    reg [31:0] pcIn;
    reg regWrEnIn;
    reg [31:0] src1RegIn;
    wire [31:0] aluCalcOut;
    wire [31:0] aluCondOut;
    wire [3:0] destRegOut;
    wire [1:0] dstMuxOut;
    wire isLWOut;
    wire memWrEnOut;
    wire [3:0] opOut;
    wire [31:0] pcOut;
    wire regWrEnOut;
    wire [31:0] src1RegOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aluCalcIn(aluCalcIn),
        .aluCondIn(aluCondIn),
        .clk(clk),
        .destRegIn(destRegIn),
        .dstMuxIn(dstMuxIn),
        .flush(flush),
        .isLWIn(isLWIn),
        .memWrEnIn(memWrEnIn),
        .opIn(opIn),
        .pcIn(pcIn),
        .regWrEnIn(regWrEnIn),
        .src1RegIn(src1RegIn),
        .aluCalcOut(aluCalcOut),
        .aluCondOut(aluCondOut),
        .destRegOut(destRegOut),
        .dstMuxOut(dstMuxOut),
        .isLWOut(isLWOut),
        .memWrEnOut(memWrEnOut),
        .opOut(opOut),
        .pcOut(pcOut),
        .regWrEnOut(regWrEnOut),
        .src1RegOut(src1RegOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            pcIn = 0;
            src1RegIn = 0;
            aluCalcIn = 0;
            aluCondIn = 0;
            destRegIn = 0;
            regWrEnIn = 0;
            memWrEnIn = 0;
            isLWIn = 0;
            opIn = 0;
            dstMuxIn = 0;
            flush = 1;
            @(posedge clk);
            #1;
            flush = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Basic data propagation");

            pcIn = 32'h0000_1004;
            src1RegIn = 32'hDEAD_BEEF;
            aluCalcIn = 32'h0000_0020;
            aluCondIn = 32'h0000_0001;
            destRegIn = 4'h5;
            regWrEnIn = 1'b1;
            memWrEnIn = 1'b0;
            isLWIn = 1'b0;
            opIn = 4'h2;
            dstMuxIn = 2'b01;
            flush = 1'b0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0000_0020, 32'h0000_0001, 4'h5, 2'b01, 1'b0, 1'b0, 4'h2, 32'h0000_1004, 1'b1, 32'hDEAD_BEEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: All-ones data propagation");

            pcIn = 32'hFFFF_FFFF;
            src1RegIn = 32'hFFFF_FFFF;
            aluCalcIn = 32'hFFFF_FFFF;
            aluCondIn = 32'hFFFF_FFFF;
            destRegIn = 4'hF;
            regWrEnIn = 1'b1;
            memWrEnIn = 1'b1;
            isLWIn = 1'b1;
            opIn = 4'hF;
            dstMuxIn = 2'b11;
            flush = 1'b0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFF_FFFF, 32'hFFFF_FFFF, 4'hF, 2'b11, 1'b1, 1'b1, 4'hF, 32'hFFFF_FFFF, 1'b1, 32'hFFFF_FFFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Flush functionality");

            pcIn = 32'h1234_5678;
            src1RegIn = 32'h8765_4321;
            aluCalcIn = 32'hAAAA_BBBB;
            aluCondIn = 32'hCCCC_DDDD;
            destRegIn = 4'hA;
            regWrEnIn = 1'b1;
            memWrEnIn = 1'b1;
            isLWIn = 1'b1;
            opIn = 4'h5;
            dstMuxIn = 2'b10;
            flush = 1'b1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0, 32'h0, 4'h0, 2'b0, 1'b0, 1'b0, 4'h0, 32'h0, 1'b0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Recovery from flush");


            pcIn = 32'h4444_4444;
            src1RegIn = 32'h5555_5555;
            aluCalcIn = 32'h6666_6666;
            aluCondIn = 32'h7777_7777;
            destRegIn = 4'h2;
            regWrEnIn = 1'b1;
            memWrEnIn = 1'b0;
            isLWIn = 1'b0;
            opIn = 4'h8;
            dstMuxIn = 2'b00;
            flush = 1'b0;
            @(posedge clk);
            #2;


            flush = 1'b1;
            @(posedge clk);
            #2;


            pcIn = 32'h9999_9999;
            src1RegIn = 32'h8888_8888;
            aluCalcIn = 32'h7777_7777;
            aluCondIn = 32'h6666_6666;
            destRegIn = 4'hC;
            regWrEnIn = 1'b0;
            memWrEnIn = 1'b1;
            isLWIn = 1'b1;
            opIn = 4'h1;
            dstMuxIn = 2'b11;
            flush = 1'b0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h7777_7777, 32'h6666_6666, 4'hC, 2'b11, 1'b1, 1'b1, 4'h1, 32'h9999_9999, 1'b0, 32'h8888_8888);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Zero values propagation");

            pcIn = 32'h0;
            src1RegIn = 32'h0;
            aluCalcIn = 32'h0;
            aluCondIn = 32'h0;
            destRegIn = 4'h0;
            regWrEnIn = 1'b0;
            memWrEnIn = 1'b0;
            isLWIn = 1'b0;
            opIn = 4'h0;
            dstMuxIn = 2'b0;
            flush = 1'b0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0, 32'h0, 4'h0, 2'b0, 1'b0, 1'b0, 4'h0, 32'h0, 1'b0, 32'h0);
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
        input [31:0] expected_aluCalcOut;
        input [31:0] expected_aluCondOut;
        input [3:0] expected_destRegOut;
        input [1:0] expected_dstMuxOut;
        input expected_isLWOut;
        input expected_memWrEnOut;
        input [3:0] expected_opOut;
        input [31:0] expected_pcOut;
        input expected_regWrEnOut;
        input [31:0] expected_src1RegOut;
        begin
            if (expected_aluCalcOut === (expected_aluCalcOut ^ aluCalcOut ^ expected_aluCalcOut) &&
                expected_aluCondOut === (expected_aluCondOut ^ aluCondOut ^ expected_aluCondOut) &&
                expected_destRegOut === (expected_destRegOut ^ destRegOut ^ expected_destRegOut) &&
                expected_dstMuxOut === (expected_dstMuxOut ^ dstMuxOut ^ expected_dstMuxOut) &&
                expected_isLWOut === (expected_isLWOut ^ isLWOut ^ expected_isLWOut) &&
                expected_memWrEnOut === (expected_memWrEnOut ^ memWrEnOut ^ expected_memWrEnOut) &&
                expected_opOut === (expected_opOut ^ opOut ^ expected_opOut) &&
                expected_pcOut === (expected_pcOut ^ pcOut ^ expected_pcOut) &&
                expected_regWrEnOut === (expected_regWrEnOut ^ regWrEnOut ^ expected_regWrEnOut) &&
                expected_src1RegOut === (expected_src1RegOut ^ src1RegOut ^ expected_src1RegOut)) begin
                $display("PASS");
                $display("  Outputs: aluCalcOut=%h, aluCondOut=%h, destRegOut=%h, dstMuxOut=%h, isLWOut=%b, memWrEnOut=%b, opOut=%h, pcOut=%h, regWrEnOut=%b, src1RegOut=%h",
                         aluCalcOut, aluCondOut, destRegOut, dstMuxOut, isLWOut, memWrEnOut, opOut, pcOut, regWrEnOut, src1RegOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluCalcOut=%h, aluCondOut=%h, destRegOut=%h, dstMuxOut=%h, isLWOut=%b, memWrEnOut=%b, opOut=%h, pcOut=%h, regWrEnOut=%b, src1RegOut=%h",
                         expected_aluCalcOut, expected_aluCondOut, expected_destRegOut, expected_dstMuxOut, expected_isLWOut, expected_memWrEnOut, expected_opOut, expected_pcOut, expected_regWrEnOut, expected_src1RegOut);
                $display("  Got:      aluCalcOut=%h, aluCondOut=%h, destRegOut=%h, dstMuxOut=%h, isLWOut=%b, memWrEnOut=%b, opOut=%h, pcOut=%h, regWrEnOut=%b, src1RegOut=%h",
                         aluCalcOut, aluCondOut, destRegOut, dstMuxOut, isLWOut, memWrEnOut, opOut, pcOut, regWrEnOut, src1RegOut);
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
        $dumpvars(0,aluCalcIn, aluCondIn, clk, destRegIn, dstMuxIn, flush, isLWIn, memWrEnIn, opIn, pcIn, regWrEnIn, src1RegIn, aluCalcOut, aluCondOut, destRegOut, dstMuxOut, isLWOut, memWrEnOut, opOut, pcOut, regWrEnOut, src1RegOut);
    end

endmodule
