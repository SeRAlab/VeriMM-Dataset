`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ALUResultIn;
    reg Clk;
    reg [4:0] DstMuxIn;
    reg [1:0] MIn;
    reg [31:0] MemDataIn;
    reg [31:0] PCIn;
    reg Reset;
    reg [2:0] WBIn;
    wire [31:0] ALUResultOut;
    wire [4:0] DstMuxOut;
    wire [1:0] MOut;
    wire [31:0] MemDataOut;
    wire [31:0] PCOut;
    wire [2:0] WBOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUResultIn(ALUResultIn),
        .Clk(Clk),
        .DstMuxIn(DstMuxIn),
        .MIn(MIn),
        .MemDataIn(MemDataIn),
        .PCIn(PCIn),
        .Reset(Reset),
        .WBIn(WBIn),
        .ALUResultOut(ALUResultOut),
        .DstMuxOut(DstMuxOut),
        .MOut(MOut),
        .MemDataOut(MemDataOut),
        .PCOut(PCOut),
        .WBOut(WBOut)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

    begin
        Reset = 1;
        PCIn = 32'h0;
        WBIn = 3'h0;
        MIn = 2'h0;
        ALUResultIn = 32'h0;
        MemDataIn = 32'h0;
        DstMuxIn = 5'h0;
        @(posedge Clk);
        #1;
        Reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset verification", test_num);
        reset_dut();


        #1;



        check_outputs(32'h0, 5'h0, 2'h0, 32'h0, 32'h0, 3'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic data transfer", test_num);
        reset_dut();

        PCIn = 32'h12345678;
        WBIn = 3'h7;
        MIn = 2'h2;
        ALUResultIn = 32'hDEADBEEF;
        MemDataIn = 32'hCAFEBABE;
        DstMuxIn = 5'h1F;

        @(posedge Clk);
        #1;
        #1;

        check_outputs(32'hDEADBEEF, 5'h1F, 2'h2, 32'hCAFEBABE, 32'h12345678, 3'h7);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Pattern 0xAAAA_AAAA", test_num);
        reset_dut();

        PCIn = 32'hAAAAAAAA;
        WBIn = 3'h5;
        MIn = 2'h1;
        ALUResultIn = 32'hAAAAAAAA;
        MemDataIn = 32'hAAAAAAAA;
        DstMuxIn = 5'h0A;

        @(posedge Clk);
        #1;
        #1;

        check_outputs(32'hAAAAAAAA, 5'h0A, 2'h1, 32'hAAAAAAAA, 32'hAAAAAAAA, 3'h5);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All ones verification", test_num);
        reset_dut();

        PCIn = 32'hFFFFFFFF;
        WBIn = 3'h7;
        MIn = 2'h3;
        ALUResultIn = 32'hFFFFFFFF;
        MemDataIn = 32'hFFFFFFFF;
        DstMuxIn = 5'h1F;

        @(posedge Clk);
        #1;
        #1;

        check_outputs(32'hFFFFFFFF, 5'h1F, 2'h3, 32'hFFFFFFFF, 32'hFFFFFFFF, 3'h7);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple cycle stability", test_num);
        reset_dut();


        PCIn = 32'h1; WBIn = 3'h1; MIn = 2'h1; ALUResultIn = 32'h1; MemDataIn = 32'h1; DstMuxIn = 5'h1;
        @(posedge Clk);
        #1;


        PCIn = 32'h2; WBIn = 3'h2; MIn = 2'h2; ALUResultIn = 32'h2; MemDataIn = 32'h2; DstMuxIn = 5'h2;
        @(posedge Clk);
        #1;


        #1;



        check_outputs(32'h2, 5'h2, 2'h2, 32'h2, 32'h2, 3'h2);
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
        input [31:0] expected_ALUResultOut;
        input [4:0] expected_DstMuxOut;
        input [1:0] expected_MOut;
        input [31:0] expected_MemDataOut;
        input [31:0] expected_PCOut;
        input [2:0] expected_WBOut;
        begin
            if (expected_ALUResultOut === (expected_ALUResultOut ^ ALUResultOut ^ expected_ALUResultOut) &&
                expected_DstMuxOut === (expected_DstMuxOut ^ DstMuxOut ^ expected_DstMuxOut) &&
                expected_MOut === (expected_MOut ^ MOut ^ expected_MOut) &&
                expected_MemDataOut === (expected_MemDataOut ^ MemDataOut ^ expected_MemDataOut) &&
                expected_PCOut === (expected_PCOut ^ PCOut ^ expected_PCOut) &&
                expected_WBOut === (expected_WBOut ^ WBOut ^ expected_WBOut)) begin
                $display("PASS");
                $display("  Outputs: ALUResultOut=%h, DstMuxOut=%h, MOut=%h, MemDataOut=%h, PCOut=%h, WBOut=%h",
                         ALUResultOut, DstMuxOut, MOut, MemDataOut, PCOut, WBOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUResultOut=%h, DstMuxOut=%h, MOut=%h, MemDataOut=%h, PCOut=%h, WBOut=%h",
                         expected_ALUResultOut, expected_DstMuxOut, expected_MOut, expected_MemDataOut, expected_PCOut, expected_WBOut);
                $display("  Got:      ALUResultOut=%h, DstMuxOut=%h, MOut=%h, MemDataOut=%h, PCOut=%h, WBOut=%h",
                         ALUResultOut, DstMuxOut, MOut, MemDataOut, PCOut, WBOut);
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
        $dumpvars(0,ALUResultIn, Clk, DstMuxIn, MIn, MemDataIn, PCIn, Reset, WBIn, ALUResultOut, DstMuxOut, MOut, MemDataOut, PCOut, WBOut);
    end

endmodule
