`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [31:0] DataIn1;
    reg [31:0] DataIn2;
    reg [4:0] EXIn;
    reg [31:0] ImmediateIn;
    reg [1:0] MIn;
    reg [31:0] PCIn;
    reg Reset;
    reg [2:0] WBIn;
    reg [4:0] rsIn;
    reg [4:0] rtIn;
    wire [31:0] DataOut1;
    wire [31:0] DataOut2;
    wire [4:0] EXOut;
    wire [31:0] ImmediateOut;
    wire [1:0] MOut;
    wire [31:0] PCOut;
    wire [2:0] WBOut;
    wire [4:0] rsOut;
    wire [4:0] rtOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .DataIn1(DataIn1),
        .DataIn2(DataIn2),
        .EXIn(EXIn),
        .ImmediateIn(ImmediateIn),
        .MIn(MIn),
        .PCIn(PCIn),
        .Reset(Reset),
        .WBIn(WBIn),
        .rsIn(rsIn),
        .rtIn(rtIn),
        .DataOut1(DataOut1),
        .DataOut2(DataOut2),
        .EXOut(EXOut),
        .ImmediateOut(ImmediateOut),
        .MOut(MOut),
        .PCOut(PCOut),
        .WBOut(WBOut),
        .rsOut(rsOut),
        .rtOut(rtOut)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

    begin
        Reset = 1;
        PCIn = 0;
        DataIn1 = 0;
        DataIn2 = 0;
        rsIn = 0;
        ImmediateIn = 0;
        rtIn = 0;
        WBIn = 0;
        MIn = 0;
        EXIn = 0;
        @(posedge Clk);
        #1;
        Reset = 0;
        @(posedge Clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Reset functionality", test_num);

        PCIn = 32'hFFFFFFFF;
        DataIn1 = 32'hFFFFFFFF;
        Reset = 1;
        @(posedge Clk);
        #1;
        Reset = 0;

        #1;


        check_outputs(32'h0, 32'h0, 5'h0, 32'h0, 2'h0, 32'h0, 3'h0, 5'h0, 5'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Normal data forwarding", test_num);
        reset_dut();
        PCIn = 32'h00001000;
        DataIn1 = 32'hAAAA_AAAA;
        DataIn2 = 32'h5555_5555;
        rsIn = 5'd10;
        ImmediateIn = 32'h1234_5678;
        rtIn = 5'd11;
        WBIn = 3'b101;
        MIn = 2'b10;
        EXIn = 5'b01010;

        @(posedge Clk);
        #1;
        #1;

        check_outputs(32'hAAAA_AAAA, 32'h5555_5555, 5'b01010, 32'h1234_5678, 2'b10, 32'h00001000, 3'b101, 5'd10, 5'd11);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Boundary values (All 1s)", test_num);
        reset_dut();
        PCIn = 32'hFFFFFFFF;
        DataIn1 = 32'hFFFFFFFF;
        DataIn2 = 32'hFFFFFFFF;
        rsIn = 5'h1F;
        ImmediateIn = 32'hFFFFFFFF;
        rtIn = 5'h1F;
        WBIn = 3'b111;
        MIn = 2'b11;
        EXIn = 5'h1F;

        @(posedge Clk);
        #1;
        #1;

        check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF, 5'h1F, 32'hFFFFFFFF, 2'b11, 32'hFFFFFFFF, 3'b111, 5'h1F, 5'h1F);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Signal integrity check (Distinct patterns)", test_num);
        reset_dut();
        PCIn = 32'h11111111;
        DataIn1 = 32'h22222222;
        DataIn2 = 32'h33333333;
        rsIn = 5'h01;
        ImmediateIn = 32'h44444444;
        rtIn = 5'h02;
        WBIn = 3'b011;
        MIn = 2'b01;
        EXIn = 5'h03;

        @(posedge Clk);
        #1;

        #1;


        check_outputs(32'h22222222, 32'h33333333, 5'h03, 32'h44444444, 2'b01, 32'h11111111, 3'b011, 5'h01, 5'h02);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Register stability check", test_num);
        reset_dut();


        PCIn = 32'hA; DataIn1 = 32'hA; DataIn2 = 32'hA; rsIn = 5'hA; ImmediateIn = 32'hA; rtIn = 5'hA; WBIn = 3'hA; MIn = 2'hA; EXIn = 5'hA;
        @(posedge Clk);
        #1;


        PCIn = 32'hB; DataIn1 = 32'hB; DataIn2 = 32'hB;
        #2;


        #1;



        check_outputs(32'hA, 32'hA, 5'hA, 32'hA, 2'hA, 32'hA, 3'hA, 5'hA, 5'hA);
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
        input [31:0] expected_DataOut1;
        input [31:0] expected_DataOut2;
        input [4:0] expected_EXOut;
        input [31:0] expected_ImmediateOut;
        input [1:0] expected_MOut;
        input [31:0] expected_PCOut;
        input [2:0] expected_WBOut;
        input [4:0] expected_rsOut;
        input [4:0] expected_rtOut;
        begin
            if (expected_DataOut1 === (expected_DataOut1 ^ DataOut1 ^ expected_DataOut1) &&
                expected_DataOut2 === (expected_DataOut2 ^ DataOut2 ^ expected_DataOut2) &&
                expected_EXOut === (expected_EXOut ^ EXOut ^ expected_EXOut) &&
                expected_ImmediateOut === (expected_ImmediateOut ^ ImmediateOut ^ expected_ImmediateOut) &&
                expected_MOut === (expected_MOut ^ MOut ^ expected_MOut) &&
                expected_PCOut === (expected_PCOut ^ PCOut ^ expected_PCOut) &&
                expected_WBOut === (expected_WBOut ^ WBOut ^ expected_WBOut) &&
                expected_rsOut === (expected_rsOut ^ rsOut ^ expected_rsOut) &&
                expected_rtOut === (expected_rtOut ^ rtOut ^ expected_rtOut)) begin
                $display("PASS");
                $display("  Outputs: DataOut1=%h, DataOut2=%h, EXOut=%h, ImmediateOut=%h, MOut=%h, PCOut=%h, WBOut=%h, rsOut=%h, rtOut=%h",
                         DataOut1, DataOut2, EXOut, ImmediateOut, MOut, PCOut, WBOut, rsOut, rtOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DataOut1=%h, DataOut2=%h, EXOut=%h, ImmediateOut=%h, MOut=%h, PCOut=%h, WBOut=%h, rsOut=%h, rtOut=%h",
                         expected_DataOut1, expected_DataOut2, expected_EXOut, expected_ImmediateOut, expected_MOut, expected_PCOut, expected_WBOut, expected_rsOut, expected_rtOut);
                $display("  Got:      DataOut1=%h, DataOut2=%h, EXOut=%h, ImmediateOut=%h, MOut=%h, PCOut=%h, WBOut=%h, rsOut=%h, rtOut=%h",
                         DataOut1, DataOut2, EXOut, ImmediateOut, MOut, PCOut, WBOut, rsOut, rtOut);
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
        $dumpvars(0,Clk, DataIn1, DataIn2, EXIn, ImmediateIn, MIn, PCIn, Reset, WBIn, rsIn, rtIn, DataOut1, DataOut2, EXOut, ImmediateOut, MOut, PCOut, WBOut, rsOut, rtOut);
    end

endmodule
