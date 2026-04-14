`timescale 1ns/1ps

module eth_rxcounters_tb;

    // Testbench signals (sequential circuit)
    reg DlyCrcEn;
    reg HugEn;
    reg MRxClk;
    reg MRxDEqD;
    reg MRxDV;
    reg [15:0] MaxFL;
    reg Reset;
    reg [1:0] StateData;
    reg StateDrop;
    reg StateIdle;
    reg StatePreamble;
    reg StateSFD;
    reg Transmitting;
    reg r_IFG;
    wire ByteCntEq0;
    wire ByteCntEq1;
    wire ByteCntEq2;
    wire ByteCntEq3;
    wire ByteCntEq4;
    wire ByteCntEq5;
    wire ByteCntEq6;
    wire ByteCntEq7;
    wire ByteCntGreat2;
    wire ByteCntMaxFrame;
    wire [15:0] ByteCntOut;
    wire ByteCntSmall7;
    wire [3:0] DlyCrcCnt;
    wire IFGCounterEq24;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eth_rxcounters dut (
        .DlyCrcEn(DlyCrcEn),
        .HugEn(HugEn),
        .MRxClk(MRxClk),
        .MRxDEqD(MRxDEqD),
        .MRxDV(MRxDV),
        .MaxFL(MaxFL),
        .Reset(Reset),
        .StateData(StateData),
        .StateDrop(StateDrop),
        .StateIdle(StateIdle),
        .StatePreamble(StatePreamble),
        .StateSFD(StateSFD),
        .Transmitting(Transmitting),
        .r_IFG(r_IFG),
        .ByteCntEq0(ByteCntEq0),
        .ByteCntEq1(ByteCntEq1),
        .ByteCntEq2(ByteCntEq2),
        .ByteCntEq3(ByteCntEq3),
        .ByteCntEq4(ByteCntEq4),
        .ByteCntEq5(ByteCntEq5),
        .ByteCntEq6(ByteCntEq6),
        .ByteCntEq7(ByteCntEq7),
        .ByteCntGreat2(ByteCntGreat2),
        .ByteCntMaxFrame(ByteCntMaxFrame),
        .ByteCntOut(ByteCntOut),
        .ByteCntSmall7(ByteCntSmall7),
        .DlyCrcCnt(DlyCrcCnt),
        .IFGCounterEq24(IFGCounterEq24)
    );

    // Clock generation (10ns period)
    initial begin
        MRxClk = 0;
        forever #5 MRxClk = ~MRxClk;
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
        $display("eth_rxcounters Testbench");
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
        input expected_ByteCntEq0;
        input expected_ByteCntEq1;
        input expected_ByteCntEq2;
        input expected_ByteCntEq3;
        input expected_ByteCntEq4;
        input expected_ByteCntEq5;
        input expected_ByteCntEq6;
        input expected_ByteCntEq7;
        input expected_ByteCntGreat2;
        input expected_ByteCntMaxFrame;
        input [15:0] expected_ByteCntOut;
        input expected_ByteCntSmall7;
        input [3:0] expected_DlyCrcCnt;
        input expected_IFGCounterEq24;
        begin
            if (expected_ByteCntEq0 === (expected_ByteCntEq0 ^ ByteCntEq0 ^ expected_ByteCntEq0) &&
                expected_ByteCntEq1 === (expected_ByteCntEq1 ^ ByteCntEq1 ^ expected_ByteCntEq1) &&
                expected_ByteCntEq2 === (expected_ByteCntEq2 ^ ByteCntEq2 ^ expected_ByteCntEq2) &&
                expected_ByteCntEq3 === (expected_ByteCntEq3 ^ ByteCntEq3 ^ expected_ByteCntEq3) &&
                expected_ByteCntEq4 === (expected_ByteCntEq4 ^ ByteCntEq4 ^ expected_ByteCntEq4) &&
                expected_ByteCntEq5 === (expected_ByteCntEq5 ^ ByteCntEq5 ^ expected_ByteCntEq5) &&
                expected_ByteCntEq6 === (expected_ByteCntEq6 ^ ByteCntEq6 ^ expected_ByteCntEq6) &&
                expected_ByteCntEq7 === (expected_ByteCntEq7 ^ ByteCntEq7 ^ expected_ByteCntEq7) &&
                expected_ByteCntGreat2 === (expected_ByteCntGreat2 ^ ByteCntGreat2 ^ expected_ByteCntGreat2) &&
                expected_ByteCntMaxFrame === (expected_ByteCntMaxFrame ^ ByteCntMaxFrame ^ expected_ByteCntMaxFrame) &&
                expected_ByteCntOut === (expected_ByteCntOut ^ ByteCntOut ^ expected_ByteCntOut) &&
                expected_ByteCntSmall7 === (expected_ByteCntSmall7 ^ ByteCntSmall7 ^ expected_ByteCntSmall7) &&
                expected_DlyCrcCnt === (expected_DlyCrcCnt ^ DlyCrcCnt ^ expected_DlyCrcCnt) &&
                expected_IFGCounterEq24 === (expected_IFGCounterEq24 ^ IFGCounterEq24 ^ expected_IFGCounterEq24)) begin
                $display("PASS");
                $display("  Outputs: ByteCntEq0=%b, ByteCntEq1=%b, ByteCntEq2=%b, ByteCntEq3=%b, ByteCntEq4=%b, ByteCntEq5=%b, ByteCntEq6=%b, ByteCntEq7=%b, ByteCntGreat2=%b, ByteCntMaxFrame=%b, ByteCntOut=%h, ByteCntSmall7=%b, DlyCrcCnt=%h, IFGCounterEq24=%b",
                         ByteCntEq0, ByteCntEq1, ByteCntEq2, ByteCntEq3, ByteCntEq4, ByteCntEq5, ByteCntEq6, ByteCntEq7, ByteCntGreat2, ByteCntMaxFrame, ByteCntOut, ByteCntSmall7, DlyCrcCnt, IFGCounterEq24);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ByteCntEq0=%b, ByteCntEq1=%b, ByteCntEq2=%b, ByteCntEq3=%b, ByteCntEq4=%b, ByteCntEq5=%b, ByteCntEq6=%b, ByteCntEq7=%b, ByteCntGreat2=%b, ByteCntMaxFrame=%b, ByteCntOut=%h, ByteCntSmall7=%b, DlyCrcCnt=%h, IFGCounterEq24=%b",
                         expected_ByteCntEq0, expected_ByteCntEq1, expected_ByteCntEq2, expected_ByteCntEq3, expected_ByteCntEq4, expected_ByteCntEq5, expected_ByteCntEq6, expected_ByteCntEq7, expected_ByteCntGreat2, expected_ByteCntMaxFrame, expected_ByteCntOut, expected_ByteCntSmall7, expected_DlyCrcCnt, expected_IFGCounterEq24);
                $display("  Got:      ByteCntEq0=%b, ByteCntEq1=%b, ByteCntEq2=%b, ByteCntEq3=%b, ByteCntEq4=%b, ByteCntEq5=%b, ByteCntEq6=%b, ByteCntEq7=%b, ByteCntGreat2=%b, ByteCntMaxFrame=%b, ByteCntOut=%h, ByteCntSmall7=%b, DlyCrcCnt=%h, IFGCounterEq24=%b",
                         ByteCntEq0, ByteCntEq1, ByteCntEq2, ByteCntEq3, ByteCntEq4, ByteCntEq5, ByteCntEq6, ByteCntEq7, ByteCntGreat2, ByteCntMaxFrame, ByteCntOut, ByteCntSmall7, DlyCrcCnt, IFGCounterEq24);
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
        $dumpvars(0,DlyCrcEn, HugEn, MRxClk, MRxDEqD, MRxDV, MaxFL, Reset, StateData, StateDrop, StateIdle, StatePreamble, StateSFD, Transmitting, r_IFG, ByteCntEq0, ByteCntEq1, ByteCntEq2, ByteCntEq3, ByteCntEq4, ByteCntEq5, ByteCntEq6, ByteCntEq7, ByteCntGreat2, ByteCntMaxFrame, ByteCntOut, ByteCntSmall7, DlyCrcCnt, IFGCounterEq24);
    end

endmodule
