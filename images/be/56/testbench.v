`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [63:0] ALUResult1;
    reg Branch1;
    reg MemRead1;
    reg MemWrite1;
    reg MemtoReg1;
    reg [63:0] PC_sum1;
    reg [4:0] Rd1;
    reg [63:0] ReadData2in;
    reg RegWrite1;
    reg Zero1;
    reg clk;
    reg reset;
    wire [63:0] ALUResult2;
    wire Branch2;
    wire MemRead2;
    wire MemWrite2;
    wire MemtoReg2;
    wire [63:0] PC_sum2;
    wire [4:0] Rd2;
    wire [63:0] ReadData2out;
    wire RegWrite2;
    wire Zero2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUResult1(ALUResult1),
        .Branch1(Branch1),
        .MemRead1(MemRead1),
        .MemWrite1(MemWrite1),
        .MemtoReg1(MemtoReg1),
        .PC_sum1(PC_sum1),
        .Rd1(Rd1),
        .ReadData2in(ReadData2in),
        .RegWrite1(RegWrite1),
        .Zero1(Zero1),
        .clk(clk),
        .reset(reset),
        .ALUResult2(ALUResult2),
        .Branch2(Branch2),
        .MemRead2(MemRead2),
        .MemWrite2(MemWrite2),
        .MemtoReg2(MemtoReg2),
        .PC_sum2(PC_sum2),
        .Rd2(Rd2),
        .ReadData2out(ReadData2out),
        .RegWrite2(RegWrite2),
        .Zero2(Zero2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        PC_sum1 = 0;
        ALUResult1 = 0;
        ReadData2in = 0;
        Branch1 = 0;
        MemRead1 = 0;
        MemtoReg1 = 0;
        MemWrite1 = 0;
        RegWrite1 = 0;
        Zero1 = 0;
        Rd1 = 0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(64'd0, 1'b0, 1'b0, 1'b0, 1'b0, 64'd0, 5'd0, 64'd0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();


        PC_sum1 = 64'hAAAA_BBBB_CCCC_DDDD;
        ALUResult1 = 64'h1234_5678_9ABC_DEF0;
        ReadData2in = 64'h0000_1111_2222_3333;
        Rd1 = 5'd15;
        RegWrite1 = 1'b1;
        MemtoReg1 = 1'b0;
        Branch1 = 1'b0;
        MemRead1 = 1'b0;
        MemWrite1 = 1'b0;
        Zero1 = 1'b1;

        @(posedge clk);
        #1;

        #1;


        check_outputs(64'h1234_5678_9ABC_DEF0, 1'b0, 1'b0, 1'b0, 1'b0, 64'hAAAA_BBBB_CCCC_DDDD, 5'd15, 64'h0000_1111_2222_3333, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        PC_sum1 = 64'h0000_0000_0000_0004;
        ALUResult1 = 64'h0000_0000_0000_1000;
        ReadData2in = 64'hFFFF_FFFF_FFFF_FFFF;
        Rd1 = 5'd0;
        RegWrite1 = 1'b0;
        MemRead1 = 1'b0;
        MemWrite1 = 1'b1;
        MemtoReg1 = 1'b0;
        Branch1 = 1'b0;
        Zero1 = 1'b0;

        @(posedge clk);
        #1;

        #1;


        check_outputs(64'h0000_0000_0000_1000, 1'b0, 1'b0, 1'b1, 1'b0, 64'h0000_0000_0000_0004, 5'd0, 64'hFFFF_FFFF_FFFF_FFFF, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        PC_sum1 = 64'h0000_0000_0000_0008;
        ALUResult1 = 64'h0000_0000_0000_2000;
        ReadData2in = 64'h0;
        Rd1 = 5'd31;
        RegWrite1 = 1'b1;
        MemRead1 = 1'b1;
        MemWrite1 = 1'b0;
        MemtoReg1 = 1'b1;
        Branch1 = 1'b0;
        Zero1 = 1'b0;

        @(posedge clk);
        #1;

        #1;


        check_outputs(64'h0000_0000_0000_2000, 1'b0, 1'b1, 1'b0, 1'b1, 64'h0000_0000_0000_0008, 5'd31, 64'h0, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        PC_sum1 = 64'h0000_0000_0000_0100;
        ALUResult1 = 64'h0;
        ReadData2in = 64'h0;
        Rd1 = 5'd0;
        RegWrite1 = 1'b0;
        MemRead1 = 1'b0;
        MemWrite1 = 1'b0;
        MemtoReg1 = 1'b0;
        Branch1 = 1'b1;
        Zero1 = 1'b1;

        @(posedge clk);
        #1;

        #1;


        check_outputs(64'h0, 1'b1, 1'b0, 1'b0, 1'b0, 64'h0000_0000_0000_0100, 5'd0, 64'h0, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();

        PC_sum1 = 64'hFFFF_FFFF_FFFF_FFFF;
        ALUResult1 = 64'hFFFF_FFFF_FFFF_FFFF;
        ReadData2in = 64'hFFFF_FFFF_FFFF_FFFF;
        Rd1 = 5'b11111;
        Branch1 = 1'b1;
        MemRead1 = 1'b1;
        MemtoReg1 = 1'b1;
        MemWrite1 = 1'b1;
        RegWrite1 = 1'b1;
        Zero1 = 1'b1;

        @(posedge clk);
        #1;

        #1;


        check_outputs(64'hFFFF_FFFF_FFFF_FFFF, 1'b1, 1'b1, 1'b1, 1'b1, 64'hFFFF_FFFF_FFFF_FFFF, 5'b11111, 64'hFFFF_FFFF_FFFF_FFFF, 1'b1, 1'b1);
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
        input [63:0] expected_ALUResult2;
        input expected_Branch2;
        input expected_MemRead2;
        input expected_MemWrite2;
        input expected_MemtoReg2;
        input [63:0] expected_PC_sum2;
        input [4:0] expected_Rd2;
        input [63:0] expected_ReadData2out;
        input expected_RegWrite2;
        input expected_Zero2;
        begin
            if (expected_ALUResult2 === (expected_ALUResult2 ^ ALUResult2 ^ expected_ALUResult2) &&
                expected_Branch2 === (expected_Branch2 ^ Branch2 ^ expected_Branch2) &&
                expected_MemRead2 === (expected_MemRead2 ^ MemRead2 ^ expected_MemRead2) &&
                expected_MemWrite2 === (expected_MemWrite2 ^ MemWrite2 ^ expected_MemWrite2) &&
                expected_MemtoReg2 === (expected_MemtoReg2 ^ MemtoReg2 ^ expected_MemtoReg2) &&
                expected_PC_sum2 === (expected_PC_sum2 ^ PC_sum2 ^ expected_PC_sum2) &&
                expected_Rd2 === (expected_Rd2 ^ Rd2 ^ expected_Rd2) &&
                expected_ReadData2out === (expected_ReadData2out ^ ReadData2out ^ expected_ReadData2out) &&
                expected_RegWrite2 === (expected_RegWrite2 ^ RegWrite2 ^ expected_RegWrite2) &&
                expected_Zero2 === (expected_Zero2 ^ Zero2 ^ expected_Zero2)) begin
                $display("PASS");
                $display("  Outputs: ALUResult2=%h, Branch2=%b, MemRead2=%b, MemWrite2=%b, MemtoReg2=%b, PC_sum2=%h, Rd2=%h, ReadData2out=%h, RegWrite2=%b, Zero2=%b",
                         ALUResult2, Branch2, MemRead2, MemWrite2, MemtoReg2, PC_sum2, Rd2, ReadData2out, RegWrite2, Zero2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUResult2=%h, Branch2=%b, MemRead2=%b, MemWrite2=%b, MemtoReg2=%b, PC_sum2=%h, Rd2=%h, ReadData2out=%h, RegWrite2=%b, Zero2=%b",
                         expected_ALUResult2, expected_Branch2, expected_MemRead2, expected_MemWrite2, expected_MemtoReg2, expected_PC_sum2, expected_Rd2, expected_ReadData2out, expected_RegWrite2, expected_Zero2);
                $display("  Got:      ALUResult2=%h, Branch2=%b, MemRead2=%b, MemWrite2=%b, MemtoReg2=%b, PC_sum2=%h, Rd2=%h, ReadData2out=%h, RegWrite2=%b, Zero2=%b",
                         ALUResult2, Branch2, MemRead2, MemWrite2, MemtoReg2, PC_sum2, Rd2, ReadData2out, RegWrite2, Zero2);
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
        $dumpvars(0,ALUResult1, Branch1, MemRead1, MemWrite1, MemtoReg1, PC_sum1, Rd1, ReadData2in, RegWrite1, Zero1, clk, reset, ALUResult2, Branch2, MemRead2, MemWrite2, MemtoReg2, PC_sum2, Rd2, ReadData2out, RegWrite2, Zero2);
    end

endmodule
