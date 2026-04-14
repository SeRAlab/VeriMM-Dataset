`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg MRxClk;
    reg MRxDEqDataSoC;
    reg MRxDV;
    reg Reset;
    reg RxValid;
    reg [1:0] StateData;
    reg StateFFS;
    reg StateFrmCrc;
    reg StateIdle;
    reg StatePreamble;
    wire [3:0] FrmCrcNibCnt;
    wire FrmCrcStateEnd;
    wire [7:0] RxRamAddr;
    wire [15:0] TotalRecvNibCnt;
    wire TotalRecvNibCntEq0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MRxClk(MRxClk),
        .MRxDEqDataSoC(MRxDEqDataSoC),
        .MRxDV(MRxDV),
        .Reset(Reset),
        .RxValid(RxValid),
        .StateData(StateData),
        .StateFFS(StateFFS),
        .StateFrmCrc(StateFrmCrc),
        .StateIdle(StateIdle),
        .StatePreamble(StatePreamble),
        .FrmCrcNibCnt(FrmCrcNibCnt),
        .FrmCrcStateEnd(FrmCrcStateEnd),
        .RxRamAddr(RxRamAddr),
        .TotalRecvNibCnt(TotalRecvNibCnt),
        .TotalRecvNibCntEq0(TotalRecvNibCntEq0)
    );

    // Clock generation (10ns period)
    initial begin
        MRxClk = 0;
        forever #5 MRxClk = ~MRxClk;
    end

        task reset_dut;

        begin
            Reset = 1;
            MRxDV = 0;
            RxValid = 0;
            StateIdle = 1;
            StateFFS = 0;
            StatePreamble = 0;
            StateData = 0;
            StateFrmCrc = 0;
            MRxDEqDataSoC = 0;
            @(posedge MRxClk);
            #1 Reset = 0;
            StateIdle = 0;
            @(posedge MRxClk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(4'h0, 1'b0, 8'h00, 16'h0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            StateData = 2'b01;
            MRxDV = 1;
            RxValid = 1;

            repeat(10) @(posedge MRxClk);
            #1;

            #1;


            check_outputs(4'h0, 1'b0, 8'h0A, 16'h000A, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            StateFrmCrc = 1;
            MRxDV = 1;

            repeat(7) @(posedge MRxClk);
            #1;

            #1;


            check_outputs(4'h7, 1'b1, 8'h00, 16'h0007, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            StateData = 2'b01;
            MRxDV = 1;
            RxValid = 1;
            repeat(5) @(posedge MRxClk);
            #1;

            StateData = 0;
            MRxDV = 0;
            RxValid = 0;
            StateIdle = 1;
            @(posedge MRxClk);
            #1;

            #1;


            check_outputs(4'h0, 1'b0, 8'h00, 16'h0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            StatePreamble = 1;
            MRxDV = 1;
            RxValid = 0;
            repeat(8) @(posedge MRxClk);
            #1;

            #1;


            check_outputs(4'h0, 1'b0, 8'h00, 16'h0008, 1'b0);
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
        input [3:0] expected_FrmCrcNibCnt;
        input expected_FrmCrcStateEnd;
        input [7:0] expected_RxRamAddr;
        input [15:0] expected_TotalRecvNibCnt;
        input expected_TotalRecvNibCntEq0;
        begin
            if (expected_FrmCrcNibCnt === (expected_FrmCrcNibCnt ^ FrmCrcNibCnt ^ expected_FrmCrcNibCnt) &&
                expected_FrmCrcStateEnd === (expected_FrmCrcStateEnd ^ FrmCrcStateEnd ^ expected_FrmCrcStateEnd) &&
                expected_RxRamAddr === (expected_RxRamAddr ^ RxRamAddr ^ expected_RxRamAddr) &&
                expected_TotalRecvNibCnt === (expected_TotalRecvNibCnt ^ TotalRecvNibCnt ^ expected_TotalRecvNibCnt) &&
                expected_TotalRecvNibCntEq0 === (expected_TotalRecvNibCntEq0 ^ TotalRecvNibCntEq0 ^ expected_TotalRecvNibCntEq0)) begin
                $display("PASS");
                $display("  Outputs: FrmCrcNibCnt=%h, FrmCrcStateEnd=%b, RxRamAddr=%h, TotalRecvNibCnt=%h, TotalRecvNibCntEq0=%b",
                         FrmCrcNibCnt, FrmCrcStateEnd, RxRamAddr, TotalRecvNibCnt, TotalRecvNibCntEq0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: FrmCrcNibCnt=%h, FrmCrcStateEnd=%b, RxRamAddr=%h, TotalRecvNibCnt=%h, TotalRecvNibCntEq0=%b",
                         expected_FrmCrcNibCnt, expected_FrmCrcStateEnd, expected_RxRamAddr, expected_TotalRecvNibCnt, expected_TotalRecvNibCntEq0);
                $display("  Got:      FrmCrcNibCnt=%h, FrmCrcStateEnd=%b, RxRamAddr=%h, TotalRecvNibCnt=%h, TotalRecvNibCntEq0=%b",
                         FrmCrcNibCnt, FrmCrcStateEnd, RxRamAddr, TotalRecvNibCnt, TotalRecvNibCntEq0);
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
        $dumpvars(0,MRxClk, MRxDEqDataSoC, MRxDV, Reset, RxValid, StateData, StateFFS, StateFrmCrc, StateIdle, StatePreamble, FrmCrcNibCnt, FrmCrcStateEnd, RxRamAddr, TotalRecvNibCnt, TotalRecvNibCntEq0);
    end

endmodule
