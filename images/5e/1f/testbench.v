`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [63:0] ALU_Resultin;
    reg MemtoReg;
    reg [63:0] ReadDatain;
    reg RegWrite;
    reg clk;
    reg [4:0] rd;
    reg reset;
    wire [63:0] ALU_Resultout;
    wire MemtoRegOut;
    wire [63:0] ReadDataout;
    wire RegWriteOut;
    wire [4:0] rdOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_Resultin(ALU_Resultin),
        .MemtoReg(MemtoReg),
        .ReadDatain(ReadDatain),
        .RegWrite(RegWrite),
        .clk(clk),
        .rd(rd),
        .reset(reset),
        .ALU_Resultout(ALU_Resultout),
        .MemtoRegOut(MemtoRegOut),
        .ReadDataout(ReadDataout),
        .RegWriteOut(RegWriteOut),
        .rdOut(rdOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        ReadDatain = 64'd0;
        ALU_Resultin = 64'd0;
        MemtoReg = 1'b0;
        RegWrite = 1'b0;
        rd = 5'd0;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Verify Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(64'h0, 1'b0, 64'h0, 1'b0, 5'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Latching ALU Result", test_num);
        reset_dut();

        ReadDatain = 64'h0;
        ALU_Resultin = 64'hFEDCBA9876543210;
        MemtoReg = 1'b0;
        RegWrite = 1'b1;
        rd = 5'd15;

        @(posedge clk);
        #2;
        #1;

        check_outputs(64'hFEDCBA9876543210, 1'b0, 64'h0, 1'b1, 5'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Latching Read Data", test_num);
        reset_dut();

        ReadDatain = 64'h0123456789ABCDEF;
        ALU_Resultin = 64'hA5A5A5A55A5A5A5A;
        MemtoReg = 1'b1;
        RegWrite = 1'b1;
        rd = 5'd31;

        @(posedge clk);
        #2;
        #1;

        check_outputs(64'hA5A5A5A55A5A5A5A, 1'b1, 64'h0123456789ABCDEF, 1'b1, 5'd31);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: All-Ones Boundary Test", test_num);
        reset_dut();

        ReadDatain = 64'hFFFFFFFFFFFFFFFF;
        ALU_Resultin = 64'hFFFFFFFFFFFFFFFF;
        MemtoReg = 1'b1;
        RegWrite = 1'b1;
        rd = 5'b11111;

        @(posedge clk);
        #2;
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFFF, 1'b1, 64'hFFFFFFFFFFFFFFFF, 1'b1, 5'b11111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Control Signal Toggling", test_num);
        reset_dut();


        ReadDatain = 64'hDEADBEEFCAFEBABE;
        ALU_Resultin = 64'h1122334455667788;
        MemtoReg = 1'b0;
        RegWrite = 1'b0;
        rd = 5'd10;

        @(posedge clk);
        #2;
        #1;

        check_outputs(64'h1122334455667788, 1'b0, 64'hDEADBEEFCAFEBABE, 1'b0, 5'd10);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Sequential Data Flow", test_num);
        reset_dut();


        ReadDatain = 64'h1;
        ALU_Resultin = 64'hA;
        rd = 5'd1;
        MemtoReg = 1; RegWrite = 1;
        @(posedge clk);
        #1;


        ReadDatain = 64'h2;
        ALU_Resultin = 64'hB;
        rd = 5'd2;
        MemtoReg = 0; RegWrite = 0;


        #1;
        #1;

        check_outputs(64'hA, 1'b1, 64'h1, 1'b1, 5'd1);


        @(posedge clk);
        #2;
        #1;

        check_outputs(64'hB, 1'b0, 64'h2, 1'b0, 5'd2);
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
        input [63:0] expected_ALU_Resultout;
        input expected_MemtoRegOut;
        input [63:0] expected_ReadDataout;
        input expected_RegWriteOut;
        input [4:0] expected_rdOut;
        begin
            if (expected_ALU_Resultout === (expected_ALU_Resultout ^ ALU_Resultout ^ expected_ALU_Resultout) &&
                expected_MemtoRegOut === (expected_MemtoRegOut ^ MemtoRegOut ^ expected_MemtoRegOut) &&
                expected_ReadDataout === (expected_ReadDataout ^ ReadDataout ^ expected_ReadDataout) &&
                expected_RegWriteOut === (expected_RegWriteOut ^ RegWriteOut ^ expected_RegWriteOut) &&
                expected_rdOut === (expected_rdOut ^ rdOut ^ expected_rdOut)) begin
                $display("PASS");
                $display("  Outputs: ALU_Resultout=%h, MemtoRegOut=%b, ReadDataout=%h, RegWriteOut=%b, rdOut=%h",
                         ALU_Resultout, MemtoRegOut, ReadDataout, RegWriteOut, rdOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_Resultout=%h, MemtoRegOut=%b, ReadDataout=%h, RegWriteOut=%b, rdOut=%h",
                         expected_ALU_Resultout, expected_MemtoRegOut, expected_ReadDataout, expected_RegWriteOut, expected_rdOut);
                $display("  Got:      ALU_Resultout=%h, MemtoRegOut=%b, ReadDataout=%h, RegWriteOut=%b, rdOut=%h",
                         ALU_Resultout, MemtoRegOut, ReadDataout, RegWriteOut, rdOut);
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
        $dumpvars(0,ALU_Resultin, MemtoReg, ReadDatain, RegWrite, clk, rd, reset, ALU_Resultout, MemtoRegOut, ReadDataout, RegWriteOut, rdOut);
    end

endmodule
