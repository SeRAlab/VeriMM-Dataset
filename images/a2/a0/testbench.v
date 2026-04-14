`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] ByteCnt;
    reg [1:0] DlyCrcCnt;
    reg DlyCrcEn;
    reg [47:0] MAC;
    reg MTxClk;
    reg [15:0] TxPauseTV;
    reg TxReset;
    wire [7:0] ControlData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ByteCnt(ByteCnt),
        .DlyCrcCnt(DlyCrcCnt),
        .DlyCrcEn(DlyCrcEn),
        .MAC(MAC),
        .MTxClk(MTxClk),
        .TxPauseTV(TxPauseTV),
        .TxReset(TxReset),
        .ControlData(ControlData)
    );

    // Clock generation (10ns period)
    initial begin
        MTxClk = 0;
        forever #5 MTxClk = ~MTxClk;
    end

        task reset_dut;

    begin
        TxReset = 1;
        ByteCnt = 0;
        DlyCrcCnt = 0;
        DlyCrcEn = 0;
        MAC = 48'h001122334455;
        TxPauseTV = 16'hAAAA;
        @(posedge MTxClk);
        #2;
        TxReset = 0;
        @(posedge MTxClk);
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Testing Reset state...", test_num);
        TxReset = 1;
        MAC = 48'hFFFFFFFFFFFF;
        ByteCnt = 6'd0;
        @(posedge MTxClk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Destination Address Byte 0 (0x01)", test_num);
        reset_dut();
        ByteCnt = 6'd0;
        @(posedge MTxClk);
        #1;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Destination Address Byte 1 (0x80)", test_num);
        reset_dut();
        ByteCnt = 6'd1;
        @(posedge MTxClk);
        #1;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Source MAC Byte 0", test_num);
        reset_dut();
        MAC = 48'hAABBCCDDEEFF;
        ByteCnt = 6'd6;
        @(posedge MTxClk);
        #1;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Source MAC Byte 5", test_num);
        reset_dut();
        MAC = 48'hAABBCCDDEEFF;
        ByteCnt = 6'd11;
        @(posedge MTxClk);
        #1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Type Field Byte 0 (0x88)", test_num);
        reset_dut();
        ByteCnt = 6'd12;
        @(posedge MTxClk);
        #1;
        #1;

        check_outputs(8'h88);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Opcode Byte 1 (0x01)", test_num);
        reset_dut();
        ByteCnt = 6'd15;
        @(posedge MTxClk);
        #1;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: TxPauseTV High Byte", test_num);
        reset_dut();
        TxPauseTV = 16'h1234;
        ByteCnt = 6'd16;
        @(posedge MTxClk);
        #1;
        #1;

        check_outputs(8'h12);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: TxPauseTV Low Byte", test_num);
        reset_dut();
        TxPauseTV = 16'h1234;
        ByteCnt = 6'd17;
        @(posedge MTxClk);
        #1;
        #1;

        check_outputs(8'h34);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Delayed CRC Enable Logic (Offset 2)", test_num);
        reset_dut();
        MAC = 48'hAABBCCDDEEFF;
        DlyCrcEn = 1;
        DlyCrcCnt = 2'd2;
        ByteCnt = 6'd8;
        @(posedge MTxClk);
        #1;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %0d: Delayed CRC Enable Logic (Offset 1)", test_num);
        reset_dut();
        DlyCrcEn = 1;
        DlyCrcCnt = 2'd1;
        ByteCnt = 6'd1;
        @(posedge MTxClk);
        #1;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase %0d: Out of Range ByteCnt (Padding)", test_num);
        reset_dut();
        ByteCnt = 6'd30;
        @(posedge MTxClk);
        #1;
        #1;

        check_outputs(8'h00);
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
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input [7:0] expected_ControlData;
        begin
            if (expected_ControlData === (expected_ControlData ^ ControlData ^ expected_ControlData)) begin
                $display("PASS");
                $display("  Outputs: ControlData=%h",
                         ControlData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ControlData=%h",
                         expected_ControlData);
                $display("  Got:      ControlData=%h",
                         ControlData);
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
        $dumpvars(0,ByteCnt, DlyCrcCnt, DlyCrcEn, MAC, MTxClk, TxPauseTV, TxReset, ControlData);
    end

endmodule
