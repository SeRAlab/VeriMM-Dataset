`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] aluOperation;
    reg aluShiftImm;
    reg aluSrc;
    reg clock;
    reg loadImm;
    reg [1:0] memReadWidth;
    reg memToReg;
    reg [3:0] memWrite;
    reg [4:0] rd;
    reg [31:0] readData1;
    reg [31:0] readData2;
    reg regDst;
    reg regWrite;
    reg reset;
    reg [4:0] rs;
    reg [4:0] rt;
    reg [4:0] sa;
    reg [31:0] sigExt;
    reg syncClr;
    wire [3:0] aluOperationOut;
    wire aluShiftImmOut;
    wire aluSrcOut;
    wire loadImmOut;
    wire [1:0] memReadWidthOut;
    wire memToRegOut;
    wire [3:0] memWriteOut;
    wire [4:0] rdOut;
    wire [31:0] readData1Out;
    wire [31:0] readData2Out;
    wire regDstOut;
    wire regWriteOut;
    wire [4:0] rsOut;
    wire [4:0] rtOut;
    wire [4:0] saOut;
    wire [31:0] sigExtOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aluOperation(aluOperation),
        .aluShiftImm(aluShiftImm),
        .aluSrc(aluSrc),
        .clock(clock),
        .loadImm(loadImm),
        .memReadWidth(memReadWidth),
        .memToReg(memToReg),
        .memWrite(memWrite),
        .rd(rd),
        .readData1(readData1),
        .readData2(readData2),
        .regDst(regDst),
        .regWrite(regWrite),
        .reset(reset),
        .rs(rs),
        .rt(rt),
        .sa(sa),
        .sigExt(sigExt),
        .syncClr(syncClr),
        .aluOperationOut(aluOperationOut),
        .aluShiftImmOut(aluShiftImmOut),
        .aluSrcOut(aluSrcOut),
        .loadImmOut(loadImmOut),
        .memReadWidthOut(memReadWidthOut),
        .memToRegOut(memToRegOut),
        .memWriteOut(memWriteOut),
        .rdOut(rdOut),
        .readData1Out(readData1Out),
        .readData2Out(readData2Out),
        .regDstOut(regDstOut),
        .regWriteOut(regWriteOut),
        .rsOut(rsOut),
        .rtOut(rtOut),
        .saOut(saOut),
        .sigExtOut(sigExtOut)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            syncClr = 0;
            rs = 0;
            rt = 0;
            rd = 0;
            sa = 0;
            aluOperation = 0;
            sigExt = 0;
            readData1 = 0;
            readData2 = 0;
            aluSrc = 0;
            aluShiftImm = 0;
            regDst = 0;
            loadImm = 0;
            memWrite = 0;
            memToReg = 0;
            memReadWidth = 0;
            regWrite = 0;
            #10;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Asynchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 1'b0, 1'b0, 1'b0, 2'h0, 1'b0, 4'h0, 5'h0, 32'h0, 32'h0, 1'b0, 1'b0, 5'h0, 5'h0, 5'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Normal Data Load", test_num);
            reset_dut();


            aluOperation = 4'hA;
            aluShiftImm = 1'b1;
            aluSrc = 1'b1;
            loadImm = 1'b0;
            memReadWidth = 2'h2;
            memToReg = 1'b1;
            memWrite = 4'hF;
            rd = 5'h1F;
            readData1 = 32'hDEADBEEF;
            readData2 = 32'hCAFEBABE;
            regDst = 1'b1;
            regWrite = 1'b1;
            rs = 5'h01;
            rt = 5'h02;
            sa = 5'h03;
            sigExt = 32'h12345678;
            syncClr = 0;

            @(posedge clock);
            #2;

            #1;


            check_outputs(4'hA, 1'b1, 1'b1, 1'b0, 2'h2, 1'b1, 4'hF, 5'h1F, 32'hDEADBEEF, 32'hCAFEBABE, 1'b1, 1'b1, 5'h01, 5'h02, 5'h03, 32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Synchronous Clear Check", test_num);
            reset_dut();


            aluOperation = 4'h5;
            aluShiftImm = 1'b0;
            aluSrc = 1'b0;
            loadImm = 1'b1;
            memReadWidth = 2'h1;
            memToReg = 1'b0;
            memWrite = 4'h0;
            rd = 5'h0A;
            readData1 = 32'h11112222;
            readData2 = 32'h33334444;
            regDst = 1'b0;
            regWrite = 1'b0;
            rs = 5'h10;
            rt = 5'h11;
            sa = 5'h12;
            sigExt = 32'h55556666;


            syncClr = 1;

            @(posedge clock);
            #2;


            #1;



            check_outputs(4'h0, 1'b0, 1'b0, 1'b0, 2'h0, 1'b0, 4'h0, 5'h0, 32'h0, 32'h0, 1'b0, 1'b0, 5'h0, 5'h0, 5'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Sequential Data Change", test_num);
            reset_dut();


            aluOperation = 4'h1; rs = 5'h01; rt = 5'h02;
            @(posedge clock);
            #2;


            aluOperation = 4'h2; rs = 5'h03; rt = 5'h04;

            #1;


            check_outputs(4'h1, 1'b0, 1'b0, 1'b0, 2'h0, 1'b0, 4'h0, 5'h0, 32'h0, 32'h0, 1'b0, 1'b0, 5'h01, 5'h02, 5'h0, 32'h0);


            @(posedge clock);
            #2;

            #1;


            check_outputs(4'h2, 1'b0, 1'b0, 1'b0, 2'h0, 1'b0, 4'h0, 5'h0, 32'h0, 32'h0, 1'b0, 1'b0, 5'h03, 5'h04, 5'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verify all fields together", test_num);
            reset_dut();

            syncClr = 0;
            aluOperation = 4'hF;
            sigExt = 32'hAAAAAAAA;
            readData1 = 32'hBBBBBBBB;
            readData2 = 32'hCCCCCCCC;
            aluSrc = 1'b1;
            aluShiftImm = 1'b1;
            memWrite = 4'h9;
            memToReg = 1'b1;
            memReadWidth = 2'b11;
            rs = 5'd10;
            rt = 5'd11;
            rd = 5'd12;
            sa = 5'd13;
            regDst = 1'b1;
            loadImm = 1'b1;
            regWrite = 1'b1;

            @(posedge clock);
            #2;

            #1;


            check_outputs(4'hF, 1'b1, 1'b1, 1'b1, 2'b11, 1'b1, 4'h9, 5'd12, 32'hBBBBBBBB, 32'hCCCCCCCC, 1'b1, 1'b1, 5'd10, 5'd11, 5'd13, 32'hAAAAAAAA);
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
        input [3:0] expected_aluOperationOut;
        input expected_aluShiftImmOut;
        input expected_aluSrcOut;
        input expected_loadImmOut;
        input [1:0] expected_memReadWidthOut;
        input expected_memToRegOut;
        input [3:0] expected_memWriteOut;
        input [4:0] expected_rdOut;
        input [31:0] expected_readData1Out;
        input [31:0] expected_readData2Out;
        input expected_regDstOut;
        input expected_regWriteOut;
        input [4:0] expected_rsOut;
        input [4:0] expected_rtOut;
        input [4:0] expected_saOut;
        input [31:0] expected_sigExtOut;
        begin
            if (expected_aluOperationOut === (expected_aluOperationOut ^ aluOperationOut ^ expected_aluOperationOut) &&
                expected_aluShiftImmOut === (expected_aluShiftImmOut ^ aluShiftImmOut ^ expected_aluShiftImmOut) &&
                expected_aluSrcOut === (expected_aluSrcOut ^ aluSrcOut ^ expected_aluSrcOut) &&
                expected_loadImmOut === (expected_loadImmOut ^ loadImmOut ^ expected_loadImmOut) &&
                expected_memReadWidthOut === (expected_memReadWidthOut ^ memReadWidthOut ^ expected_memReadWidthOut) &&
                expected_memToRegOut === (expected_memToRegOut ^ memToRegOut ^ expected_memToRegOut) &&
                expected_memWriteOut === (expected_memWriteOut ^ memWriteOut ^ expected_memWriteOut) &&
                expected_rdOut === (expected_rdOut ^ rdOut ^ expected_rdOut) &&
                expected_readData1Out === (expected_readData1Out ^ readData1Out ^ expected_readData1Out) &&
                expected_readData2Out === (expected_readData2Out ^ readData2Out ^ expected_readData2Out) &&
                expected_regDstOut === (expected_regDstOut ^ regDstOut ^ expected_regDstOut) &&
                expected_regWriteOut === (expected_regWriteOut ^ regWriteOut ^ expected_regWriteOut) &&
                expected_rsOut === (expected_rsOut ^ rsOut ^ expected_rsOut) &&
                expected_rtOut === (expected_rtOut ^ rtOut ^ expected_rtOut) &&
                expected_saOut === (expected_saOut ^ saOut ^ expected_saOut) &&
                expected_sigExtOut === (expected_sigExtOut ^ sigExtOut ^ expected_sigExtOut)) begin
                $display("PASS");
                $display("  Outputs: aluOperationOut=%h, aluShiftImmOut=%b, aluSrcOut=%b, loadImmOut=%b, memReadWidthOut=%h, memToRegOut=%b, memWriteOut=%h, rdOut=%h, readData1Out=%h, readData2Out=%h, regDstOut=%b, regWriteOut=%b, rsOut=%h, rtOut=%h, saOut=%h, sigExtOut=%h",
                         aluOperationOut, aluShiftImmOut, aluSrcOut, loadImmOut, memReadWidthOut, memToRegOut, memWriteOut, rdOut, readData1Out, readData2Out, regDstOut, regWriteOut, rsOut, rtOut, saOut, sigExtOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluOperationOut=%h, aluShiftImmOut=%b, aluSrcOut=%b, loadImmOut=%b, memReadWidthOut=%h, memToRegOut=%b, memWriteOut=%h, rdOut=%h, readData1Out=%h, readData2Out=%h, regDstOut=%b, regWriteOut=%b, rsOut=%h, rtOut=%h, saOut=%h, sigExtOut=%h",
                         expected_aluOperationOut, expected_aluShiftImmOut, expected_aluSrcOut, expected_loadImmOut, expected_memReadWidthOut, expected_memToRegOut, expected_memWriteOut, expected_rdOut, expected_readData1Out, expected_readData2Out, expected_regDstOut, expected_regWriteOut, expected_rsOut, expected_rtOut, expected_saOut, expected_sigExtOut);
                $display("  Got:      aluOperationOut=%h, aluShiftImmOut=%b, aluSrcOut=%b, loadImmOut=%b, memReadWidthOut=%h, memToRegOut=%b, memWriteOut=%h, rdOut=%h, readData1Out=%h, readData2Out=%h, regDstOut=%b, regWriteOut=%b, rsOut=%h, rtOut=%h, saOut=%h, sigExtOut=%h",
                         aluOperationOut, aluShiftImmOut, aluSrcOut, loadImmOut, memReadWidthOut, memToRegOut, memWriteOut, rdOut, readData1Out, readData2Out, regDstOut, regWriteOut, rsOut, rtOut, saOut, sigExtOut);
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
        $dumpvars(0,aluOperation, aluShiftImm, aluSrc, clock, loadImm, memReadWidth, memToReg, memWrite, rd, readData1, readData2, regDst, regWrite, reset, rs, rt, sa, sigExt, syncClr, aluOperationOut, aluShiftImmOut, aluSrcOut, loadImmOut, memReadWidthOut, memToRegOut, memWriteOut, rdOut, readData1Out, readData2Out, regDstOut, regWriteOut, rsOut, rtOut, saOut, sigExtOut);
    end

endmodule
