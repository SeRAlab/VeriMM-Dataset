`timescale 1ns/1ps

module fifoMux_tb;

    // Testbench signals (combinational circuit)
    reg RxFifoEP0Full;
    reg RxFifoEP1Full;
    reg RxFifoEP2Full;
    reg RxFifoEP3Full;
    reg RxFifoWEn;
    reg [7:0] TxFifoEP0Data;
    reg TxFifoEP0Empty;
    reg [7:0] TxFifoEP1Data;
    reg TxFifoEP1Empty;
    reg [7:0] TxFifoEP2Data;
    reg TxFifoEP2Empty;
    reg [7:0] TxFifoEP3Data;
    reg TxFifoEP3Empty;
    reg TxFifoREn;
    reg [3:0] currEndP;
    wire RxFifoEP0WEn;
    wire RxFifoEP1WEn;
    wire RxFifoEP2WEn;
    wire RxFifoEP3WEn;
    wire RxFifoFull;
    wire [7:0] TxFifoData;
    wire TxFifoEP0REn;
    wire TxFifoEP1REn;
    wire TxFifoEP2REn;
    wire TxFifoEP3REn;
    wire TxFifoEmpty;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifoMux dut (
        .RxFifoEP0Full(RxFifoEP0Full),
        .RxFifoEP1Full(RxFifoEP1Full),
        .RxFifoEP2Full(RxFifoEP2Full),
        .RxFifoEP3Full(RxFifoEP3Full),
        .RxFifoWEn(RxFifoWEn),
        .TxFifoEP0Data(TxFifoEP0Data),
        .TxFifoEP0Empty(TxFifoEP0Empty),
        .TxFifoEP1Data(TxFifoEP1Data),
        .TxFifoEP1Empty(TxFifoEP1Empty),
        .TxFifoEP2Data(TxFifoEP2Data),
        .TxFifoEP2Empty(TxFifoEP2Empty),
        .TxFifoEP3Data(TxFifoEP3Data),
        .TxFifoEP3Empty(TxFifoEP3Empty),
        .TxFifoREn(TxFifoREn),
        .currEndP(currEndP),
        .RxFifoEP0WEn(RxFifoEP0WEn),
        .RxFifoEP1WEn(RxFifoEP1WEn),
        .RxFifoEP2WEn(RxFifoEP2WEn),
        .RxFifoEP3WEn(RxFifoEP3WEn),
        .RxFifoFull(RxFifoFull),
        .TxFifoData(TxFifoData),
        .TxFifoEP0REn(TxFifoEP0REn),
        .TxFifoEP1REn(TxFifoEP1REn),
        .TxFifoEP2REn(TxFifoEP2REn),
        .TxFifoEP3REn(TxFifoEP3REn),
        .TxFifoEmpty(TxFifoEmpty)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fifoMux Testbench");
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
        input expected_RxFifoEP0WEn;
        input expected_RxFifoEP1WEn;
        input expected_RxFifoEP2WEn;
        input expected_RxFifoEP3WEn;
        input expected_RxFifoFull;
        input [7:0] expected_TxFifoData;
        input expected_TxFifoEP0REn;
        input expected_TxFifoEP1REn;
        input expected_TxFifoEP2REn;
        input expected_TxFifoEP3REn;
        input expected_TxFifoEmpty;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RxFifoEP0WEn === (expected_RxFifoEP0WEn ^ RxFifoEP0WEn ^ expected_RxFifoEP0WEn) &&
                expected_RxFifoEP1WEn === (expected_RxFifoEP1WEn ^ RxFifoEP1WEn ^ expected_RxFifoEP1WEn) &&
                expected_RxFifoEP2WEn === (expected_RxFifoEP2WEn ^ RxFifoEP2WEn ^ expected_RxFifoEP2WEn) &&
                expected_RxFifoEP3WEn === (expected_RxFifoEP3WEn ^ RxFifoEP3WEn ^ expected_RxFifoEP3WEn) &&
                expected_RxFifoFull === (expected_RxFifoFull ^ RxFifoFull ^ expected_RxFifoFull) &&
                expected_TxFifoData === (expected_TxFifoData ^ TxFifoData ^ expected_TxFifoData) &&
                expected_TxFifoEP0REn === (expected_TxFifoEP0REn ^ TxFifoEP0REn ^ expected_TxFifoEP0REn) &&
                expected_TxFifoEP1REn === (expected_TxFifoEP1REn ^ TxFifoEP1REn ^ expected_TxFifoEP1REn) &&
                expected_TxFifoEP2REn === (expected_TxFifoEP2REn ^ TxFifoEP2REn ^ expected_TxFifoEP2REn) &&
                expected_TxFifoEP3REn === (expected_TxFifoEP3REn ^ TxFifoEP3REn ^ expected_TxFifoEP3REn) &&
                expected_TxFifoEmpty === (expected_TxFifoEmpty ^ TxFifoEmpty ^ expected_TxFifoEmpty)) begin
                $display("PASS");
                $display("  Outputs: RxFifoEP0WEn=%b, RxFifoEP1WEn=%b, RxFifoEP2WEn=%b, RxFifoEP3WEn=%b, RxFifoFull=%b, TxFifoData=%h, TxFifoEP0REn=%b, TxFifoEP1REn=%b, TxFifoEP2REn=%b, TxFifoEP3REn=%b, TxFifoEmpty=%b",
                         RxFifoEP0WEn, RxFifoEP1WEn, RxFifoEP2WEn, RxFifoEP3WEn, RxFifoFull, TxFifoData, TxFifoEP0REn, TxFifoEP1REn, TxFifoEP2REn, TxFifoEP3REn, TxFifoEmpty);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RxFifoEP0WEn=%b, RxFifoEP1WEn=%b, RxFifoEP2WEn=%b, RxFifoEP3WEn=%b, RxFifoFull=%b, TxFifoData=%h, TxFifoEP0REn=%b, TxFifoEP1REn=%b, TxFifoEP2REn=%b, TxFifoEP3REn=%b, TxFifoEmpty=%b",
                         expected_RxFifoEP0WEn, expected_RxFifoEP1WEn, expected_RxFifoEP2WEn, expected_RxFifoEP3WEn, expected_RxFifoFull, expected_TxFifoData, expected_TxFifoEP0REn, expected_TxFifoEP1REn, expected_TxFifoEP2REn, expected_TxFifoEP3REn, expected_TxFifoEmpty);
                $display("  Got:      RxFifoEP0WEn=%b, RxFifoEP1WEn=%b, RxFifoEP2WEn=%b, RxFifoEP3WEn=%b, RxFifoFull=%b, TxFifoData=%h, TxFifoEP0REn=%b, TxFifoEP1REn=%b, TxFifoEP2REn=%b, TxFifoEP3REn=%b, TxFifoEmpty=%b",
                         RxFifoEP0WEn, RxFifoEP1WEn, RxFifoEP2WEn, RxFifoEP3WEn, RxFifoFull, TxFifoData, TxFifoEP0REn, TxFifoEP1REn, TxFifoEP2REn, TxFifoEP3REn, TxFifoEmpty);
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
