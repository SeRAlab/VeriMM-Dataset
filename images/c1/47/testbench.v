`timescale 1ns/1ps

module eth_txcounters_tb;

    // Testbench signals (sequential circuit)
    reg DlyCrcEn;
    reg ExDfrEn;
    reg HugEn;
    reg MTxClk;
    reg [15:0] MaxFL;
    reg [15:0] MinFL;
    reg PacketFinished_q;
    reg Reset;
    reg StartBackoff;
    reg StartDefer;
    reg StartFCS;
    reg StartIPG;
    reg StartJam;
    reg StateBackOff;
    reg [1:0] StateData;
    reg StateDefer;
    reg StateFCS;
    reg StateIPG;
    reg StateIdle;
    reg StateJam;
    reg StatePAD;
    reg StatePreamble;
    reg StateSFD;
    reg TxStartFrm;
    wire [15:0] ByteCnt;
    wire [2:0] DlyCrcCnt;
    wire ExcessiveDefer;
    wire MaxFrame;
    wire [15:0] NibCnt;
    wire NibCntEq15;
    wire NibCntEq7;
    wire NibbleMinFl;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eth_txcounters dut (
        .DlyCrcEn(DlyCrcEn),
        .ExDfrEn(ExDfrEn),
        .HugEn(HugEn),
        .MTxClk(MTxClk),
        .MaxFL(MaxFL),
        .MinFL(MinFL),
        .PacketFinished_q(PacketFinished_q),
        .Reset(Reset),
        .StartBackoff(StartBackoff),
        .StartDefer(StartDefer),
        .StartFCS(StartFCS),
        .StartIPG(StartIPG),
        .StartJam(StartJam),
        .StateBackOff(StateBackOff),
        .StateData(StateData),
        .StateDefer(StateDefer),
        .StateFCS(StateFCS),
        .StateIPG(StateIPG),
        .StateIdle(StateIdle),
        .StateJam(StateJam),
        .StatePAD(StatePAD),
        .StatePreamble(StatePreamble),
        .StateSFD(StateSFD),
        .TxStartFrm(TxStartFrm),
        .ByteCnt(ByteCnt),
        .DlyCrcCnt(DlyCrcCnt),
        .ExcessiveDefer(ExcessiveDefer),
        .MaxFrame(MaxFrame),
        .NibCnt(NibCnt),
        .NibCntEq15(NibCntEq15),
        .NibCntEq7(NibCntEq7),
        .NibbleMinFl(NibbleMinFl)
    );

    // Clock generation (10ns period)
    initial begin
        MTxClk = 0;
        forever #5 MTxClk = ~MTxClk;
    end

    task reset_dut;
    //define reset task
    endtask
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eth_txcounters Testbench");
        $display("========================================");


        
        
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
        input [15:0] expected_ByteCnt;
        input [2:0] expected_DlyCrcCnt;
        input expected_ExcessiveDefer;
        input expected_MaxFrame;
        input [15:0] expected_NibCnt;
        input expected_NibCntEq15;
        input expected_NibCntEq7;
        input expected_NibbleMinFl;
        begin
            if (expected_ByteCnt === (expected_ByteCnt ^ ByteCnt ^ expected_ByteCnt) &&
                expected_DlyCrcCnt === (expected_DlyCrcCnt ^ DlyCrcCnt ^ expected_DlyCrcCnt) &&
                expected_ExcessiveDefer === (expected_ExcessiveDefer ^ ExcessiveDefer ^ expected_ExcessiveDefer) &&
                expected_MaxFrame === (expected_MaxFrame ^ MaxFrame ^ expected_MaxFrame) &&
                expected_NibCnt === (expected_NibCnt ^ NibCnt ^ expected_NibCnt) &&
                expected_NibCntEq15 === (expected_NibCntEq15 ^ NibCntEq15 ^ expected_NibCntEq15) &&
                expected_NibCntEq7 === (expected_NibCntEq7 ^ NibCntEq7 ^ expected_NibCntEq7) &&
                expected_NibbleMinFl === (expected_NibbleMinFl ^ NibbleMinFl ^ expected_NibbleMinFl)) begin
                $display("PASS");
                $display("  Outputs: ByteCnt=%h, DlyCrcCnt=%h, ExcessiveDefer=%b, MaxFrame=%b, NibCnt=%h, NibCntEq15=%b, NibCntEq7=%b, NibbleMinFl=%b",
                         ByteCnt, DlyCrcCnt, ExcessiveDefer, MaxFrame, NibCnt, NibCntEq15, NibCntEq7, NibbleMinFl);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ByteCnt=%h, DlyCrcCnt=%h, ExcessiveDefer=%b, MaxFrame=%b, NibCnt=%h, NibCntEq15=%b, NibCntEq7=%b, NibbleMinFl=%b",
                         expected_ByteCnt, expected_DlyCrcCnt, expected_ExcessiveDefer, expected_MaxFrame, expected_NibCnt, expected_NibCntEq15, expected_NibCntEq7, expected_NibbleMinFl);
                $display("  Got:      ByteCnt=%h, DlyCrcCnt=%h, ExcessiveDefer=%b, MaxFrame=%b, NibCnt=%h, NibCntEq15=%b, NibCntEq7=%b, NibbleMinFl=%b",
                         ByteCnt, DlyCrcCnt, ExcessiveDefer, MaxFrame, NibCnt, NibCntEq15, NibCntEq7, NibbleMinFl);
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
        $dumpvars(0,DlyCrcEn, ExDfrEn, HugEn, MTxClk, MaxFL, MinFL, PacketFinished_q, Reset, StartBackoff, StartDefer, StartFCS, StartIPG, StartJam, StateBackOff, StateData, StateDefer, StateFCS, StateIPG, StateIdle, StateJam, StatePAD, StatePreamble, StateSFD, TxStartFrm, ByteCnt, DlyCrcCnt, ExcessiveDefer, MaxFrame, NibCnt, NibCntEq15, NibCntEq7, NibbleMinFl);
    end

endmodule
