`timescale 1ns/1ps

module eth_txstatem_tb;

    // Testbench signals (sequential circuit)
    reg CarrierSense;
    reg ColWindow;
    reg Collision;
    reg CrcEn;
    reg ExcessiveDefer;
    reg FullD;
    reg [6:0] IPGR1;
    reg [6:0] IPGR2;
    reg [6:0] IPGT;
    reg MTxClk;
    reg MaxFrame;
    reg [6:0] NibCnt;
    reg NibCntEq15;
    reg NibCntEq7;
    reg NibbleMinFl;
    reg NoBckof;
    reg Pad;
    reg RandomEq0;
    reg RandomEqByteCnt;
    reg Reset;
    reg RetryMax;
    reg StartTxDone;
    reg TooBig;
    reg TxEndFrm;
    reg TxStartFrm;
    reg TxUnderRun;
    reg UnderRun;
    wire DeferIndication;
    wire StartBackoff;
    wire [1:0] StartData;
    wire StartDefer;
    wire StartFCS;
    wire StartIPG;
    wire StartJam;
    wire StartPreamble;
    wire StateBackOff;
    wire [1:0] StateData;
    wire StateDefer;
    wire StateFCS;
    wire StateIPG;
    wire StateIdle;
    wire StateJam;
    wire StateJam_q;
    wire StatePAD;
    wire StatePreamble;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eth_txstatem dut (
        .CarrierSense(CarrierSense),
        .ColWindow(ColWindow),
        .Collision(Collision),
        .CrcEn(CrcEn),
        .ExcessiveDefer(ExcessiveDefer),
        .FullD(FullD),
        .IPGR1(IPGR1),
        .IPGR2(IPGR2),
        .IPGT(IPGT),
        .MTxClk(MTxClk),
        .MaxFrame(MaxFrame),
        .NibCnt(NibCnt),
        .NibCntEq15(NibCntEq15),
        .NibCntEq7(NibCntEq7),
        .NibbleMinFl(NibbleMinFl),
        .NoBckof(NoBckof),
        .Pad(Pad),
        .RandomEq0(RandomEq0),
        .RandomEqByteCnt(RandomEqByteCnt),
        .Reset(Reset),
        .RetryMax(RetryMax),
        .StartTxDone(StartTxDone),
        .TooBig(TooBig),
        .TxEndFrm(TxEndFrm),
        .TxStartFrm(TxStartFrm),
        .TxUnderRun(TxUnderRun),
        .UnderRun(UnderRun),
        .DeferIndication(DeferIndication),
        .StartBackoff(StartBackoff),
        .StartData(StartData),
        .StartDefer(StartDefer),
        .StartFCS(StartFCS),
        .StartIPG(StartIPG),
        .StartJam(StartJam),
        .StartPreamble(StartPreamble),
        .StateBackOff(StateBackOff),
        .StateData(StateData),
        .StateDefer(StateDefer),
        .StateFCS(StateFCS),
        .StateIPG(StateIPG),
        .StateIdle(StateIdle),
        .StateJam(StateJam),
        .StateJam_q(StateJam_q),
        .StatePAD(StatePAD),
        .StatePreamble(StatePreamble)
    );

    // Clock generation (10ns period)
    initial begin
        MTxClk = 0;
        forever #5 MTxClk = ~MTxClk;
    end

        task reset_dut;

        begin
            Reset = 1;
            CarrierSense = 0;
            ColWindow = 0;
            Collision = 0;
            CrcEn = 0;
            ExcessiveDefer = 0;
            FullD = 0;
            IPGR1 = 7'h0C;
            IPGR2 = 7'h12;
            IPGT = 7'h15;
            MaxFrame = 0;
            NibCnt = 0;
            NibCntEq15 = 0;
            NibCntEq7 = 0;
            NibbleMinFl = 0;
            NoBckof = 0;
            Pad = 0;
            RandomEq0 = 0;
            RandomEqByteCnt = 0;
            RetryMax = 0;
            StartTxDone = 0;
            TooBig = 0;
            TxEndFrm = 0;
            TxStartFrm = 0;
            TxUnderRun = 0;
            UnderRun = 0;
            repeat(2) @(posedge MTxClk);
            #1 Reset = 0;
            repeat(1) @(posedge MTxClk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Normal Transmission Flow", test_num);
            reset_dut();


            TxStartFrm = 1;
            @(posedge MTxClk);
            TxStartFrm = 0;




            wait(StatePreamble);
            NibCntEq15 = 1;

            @(posedge MTxClk);
            NibCntEq15 = 0;


            wait(StateData != 2'b00);
            TxEndFrm = 1;
            CrcEn = 1;

            @(posedge MTxClk);
            TxEndFrm = 0;

            wait(StateFCS);
            NibCntEq7 = 1;

            @(posedge MTxClk);
            NibCntEq7 = 0;


            repeat(2) @(posedge MTxClk);


            #1;



            check_outputs(
                0, 0, 2'b00, 0, 0, 1, 0, 0,
                0, 2'b00, 0, 0, 0, 1, 0, 0, 0, 0
            );
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Collision and Backoff", test_num);
            reset_dut();


            TxStartFrm = 1;
            @(posedge MTxClk);
            TxStartFrm = 0;

            wait(StateData != 2'b00);


            Collision = 1;
            @(posedge MTxClk);


            wait(StateJam);
            Collision = 0;
            NibCntEq7 = 1;

            @(posedge MTxClk);
            NibCntEq7 = 0;


            wait(StateBackOff);
            RandomEq0 = 1;

            @(posedge MTxClk);
            RandomEq0 = 0;


            repeat(2) @(posedge MTxClk);



            if (StateDefer || StateIdle) begin
                pass_count = pass_count + 1;
                $display("PASS: Transitioned out of Backoff correctly");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Stuck in Backoff or Jam");
            end
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Padding Short Frame", test_num);
            reset_dut();

            TxStartFrm = 1;
            Pad = 1;
            @(posedge MTxClk);
            TxStartFrm = 0;

            wait(StatePreamble);
            NibCntEq15 = 1;
            @(posedge MTxClk);
            NibCntEq15 = 0;

            wait(StateData != 2'b00);
            TxEndFrm = 1;
            NibbleMinFl = 0;
            @(posedge MTxClk);
            TxEndFrm = 0;


            wait(StatePAD);
            NibbleMinFl = 1;
            CrcEn = 1;

            @(posedge MTxClk);

            wait(StateFCS);
            NibCntEq7 = 1;
            @(posedge MTxClk);

            #1;


            check_outputs(
                0, 0, 2'b00, 0, 0, 1, 0, 0,
                0, 2'b00, 0, 0, 0, 1, 0, 0, 0, 0
            );
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Excessive Deferment", test_num);
            reset_dut();

            CarrierSense = 1;
            ExcessiveDefer = 1;

            @(posedge MTxClk);

            if (DeferIndication) begin
                $display("PASS: DeferIndication asserted on ExcessiveDefer");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: DeferIndication not asserted");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Full Duplex Collision Ignore", test_num);
            reset_dut();

            FullD = 1;
            TxStartFrm = 1;
            @(posedge MTxClk);
            TxStartFrm = 0;

            wait(StateData != 2'b00);
            Collision = 1;
            repeat(3) @(posedge MTxClk);


            if (StateJam) begin
                $display("FAIL: Entered Jam state in Full Duplex mode");
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: Ignored collision in Full Duplex mode");
                pass_count = pass_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eth_txstatem Testbench");
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
        input expected_DeferIndication;
        input expected_StartBackoff;
        input [1:0] expected_StartData;
        input expected_StartDefer;
        input expected_StartFCS;
        input expected_StartIPG;
        input expected_StartJam;
        input expected_StartPreamble;
        input expected_StateBackOff;
        input [1:0] expected_StateData;
        input expected_StateDefer;
        input expected_StateFCS;
        input expected_StateIPG;
        input expected_StateIdle;
        input expected_StateJam;
        input expected_StateJam_q;
        input expected_StatePAD;
        input expected_StatePreamble;
        begin
            if (expected_DeferIndication === (expected_DeferIndication ^ DeferIndication ^ expected_DeferIndication) &&
                expected_StartBackoff === (expected_StartBackoff ^ StartBackoff ^ expected_StartBackoff) &&
                expected_StartData === (expected_StartData ^ StartData ^ expected_StartData) &&
                expected_StartDefer === (expected_StartDefer ^ StartDefer ^ expected_StartDefer) &&
                expected_StartFCS === (expected_StartFCS ^ StartFCS ^ expected_StartFCS) &&
                expected_StartIPG === (expected_StartIPG ^ StartIPG ^ expected_StartIPG) &&
                expected_StartJam === (expected_StartJam ^ StartJam ^ expected_StartJam) &&
                expected_StartPreamble === (expected_StartPreamble ^ StartPreamble ^ expected_StartPreamble) &&
                expected_StateBackOff === (expected_StateBackOff ^ StateBackOff ^ expected_StateBackOff) &&
                expected_StateData === (expected_StateData ^ StateData ^ expected_StateData) &&
                expected_StateDefer === (expected_StateDefer ^ StateDefer ^ expected_StateDefer) &&
                expected_StateFCS === (expected_StateFCS ^ StateFCS ^ expected_StateFCS) &&
                expected_StateIPG === (expected_StateIPG ^ StateIPG ^ expected_StateIPG) &&
                expected_StateIdle === (expected_StateIdle ^ StateIdle ^ expected_StateIdle) &&
                expected_StateJam === (expected_StateJam ^ StateJam ^ expected_StateJam) &&
                expected_StateJam_q === (expected_StateJam_q ^ StateJam_q ^ expected_StateJam_q) &&
                expected_StatePAD === (expected_StatePAD ^ StatePAD ^ expected_StatePAD) &&
                expected_StatePreamble === (expected_StatePreamble ^ StatePreamble ^ expected_StatePreamble)) begin
                $display("PASS");
                $display("  Outputs: DeferIndication=%b, StartBackoff=%b, StartData=%h, StartDefer=%b, StartFCS=%b, StartIPG=%b, StartJam=%b, StartPreamble=%b, StateBackOff=%b, StateData=%h, StateDefer=%b, StateFCS=%b, StateIPG=%b, StateIdle=%b, StateJam=%b, StateJam_q=%b, StatePAD=%b, StatePreamble=%b",
                         DeferIndication, StartBackoff, StartData, StartDefer, StartFCS, StartIPG, StartJam, StartPreamble, StateBackOff, StateData, StateDefer, StateFCS, StateIPG, StateIdle, StateJam, StateJam_q, StatePAD, StatePreamble);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DeferIndication=%b, StartBackoff=%b, StartData=%h, StartDefer=%b, StartFCS=%b, StartIPG=%b, StartJam=%b, StartPreamble=%b, StateBackOff=%b, StateData=%h, StateDefer=%b, StateFCS=%b, StateIPG=%b, StateIdle=%b, StateJam=%b, StateJam_q=%b, StatePAD=%b, StatePreamble=%b",
                         expected_DeferIndication, expected_StartBackoff, expected_StartData, expected_StartDefer, expected_StartFCS, expected_StartIPG, expected_StartJam, expected_StartPreamble, expected_StateBackOff, expected_StateData, expected_StateDefer, expected_StateFCS, expected_StateIPG, expected_StateIdle, expected_StateJam, expected_StateJam_q, expected_StatePAD, expected_StatePreamble);
                $display("  Got:      DeferIndication=%b, StartBackoff=%b, StartData=%h, StartDefer=%b, StartFCS=%b, StartIPG=%b, StartJam=%b, StartPreamble=%b, StateBackOff=%b, StateData=%h, StateDefer=%b, StateFCS=%b, StateIPG=%b, StateIdle=%b, StateJam=%b, StateJam_q=%b, StatePAD=%b, StatePreamble=%b",
                         DeferIndication, StartBackoff, StartData, StartDefer, StartFCS, StartIPG, StartJam, StartPreamble, StateBackOff, StateData, StateDefer, StateFCS, StateIPG, StateIdle, StateJam, StateJam_q, StatePAD, StatePreamble);
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
        $dumpvars(0,CarrierSense, ColWindow, Collision, CrcEn, ExcessiveDefer, FullD, IPGR1, IPGR2, IPGT, MTxClk, MaxFrame, NibCnt, NibCntEq15, NibCntEq7, NibbleMinFl, NoBckof, Pad, RandomEq0, RandomEqByteCnt, Reset, RetryMax, StartTxDone, TooBig, TxEndFrm, TxStartFrm, TxUnderRun, UnderRun, DeferIndication, StartBackoff, StartData, StartDefer, StartFCS, StartIPG, StartJam, StartPreamble, StateBackOff, StateData, StateDefer, StateFCS, StateIPG, StateIdle, StateJam, StateJam_q, StatePAD, StatePreamble);
    end

endmodule
