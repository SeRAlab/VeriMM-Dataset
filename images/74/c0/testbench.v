`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] ALUOPID;
    reg ALUsrcID;
    reg CLK;
    reg [31:0] ImmExtID;
    reg MemReadID;
    reg MemtoregID;
    reg MemwriteID;
    reg [4:0] Rd;
    reg [31:0] ReadData1;
    reg [31:0] ReadData2;
    reg RegDstID;
    reg RegWriteID;
    reg [4:0] Rs;
    reg [4:0] Rt;
    wire [1:0] ALUOPEX;
    wire ALUsrcEX;
    wire [31:0] ImmExtEX;
    wire MemReadEX;
    wire MemtoregEX;
    wire MemwriteEX;
    wire [4:0] RdEX;
    wire [31:0] ReadData1EX;
    wire [31:0] ReadData2EX;
    wire RegDstEX;
    wire RegWriteEX;
    wire [4:0] RsEX;
    wire [4:0] RtEX;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOPID(ALUOPID),
        .ALUsrcID(ALUsrcID),
        .CLK(CLK),
        .ImmExtID(ImmExtID),
        .MemReadID(MemReadID),
        .MemtoregID(MemtoregID),
        .MemwriteID(MemwriteID),
        .Rd(Rd),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2),
        .RegDstID(RegDstID),
        .RegWriteID(RegWriteID),
        .Rs(Rs),
        .Rt(Rt),
        .ALUOPEX(ALUOPEX),
        .ALUsrcEX(ALUsrcEX),
        .ImmExtEX(ImmExtEX),
        .MemReadEX(MemReadEX),
        .MemtoregEX(MemtoregEX),
        .MemwriteEX(MemwriteEX),
        .RdEX(RdEX),
        .ReadData1EX(ReadData1EX),
        .ReadData2EX(ReadData2EX),
        .RegDstEX(RegDstEX),
        .RegWriteEX(RegWriteEX),
        .RsEX(RsEX),
        .RtEX(RtEX)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            ALUOPID    = 2'b0;
            ALUsrcID   = 1'b0;
            ImmExtID   = 32'b0;
            MemReadID  = 1'b0;
            MemtoregID = 1'b0;
            MemwriteID = 1'b0;
            Rd         = 5'b0;
            ReadData1  = 32'b0;
            ReadData2  = 32'b0;
            RegDstID   = 1'b0;
            RegWriteID = 1'b0;
            Rs         = 5'b0;
            Rt         = 5'b0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic R-type Instruction signals", test_num);
            reset_dut();


            ALUOPID    = 2'b10;
            ALUsrcID   = 1'b0;
            ImmExtID   = 32'h0000_0000;
            MemReadID  = 1'b0;
            MemtoregID = 1'b0;
            MemwriteID = 1'b0;
            Rd         = 5'd16;
            ReadData1  = 32'hAAAA_BBBB;
            ReadData2  = 32'hCCCC_DDDD;
            RegDstID   = 1'b1;
            RegWriteID = 1'b1;
            Rs         = 5'd8;
            Rt         = 5'd9;

            @(posedge CLK);
            #2;

            #1;


            check_outputs(2'b10, 1'b0, 32'h0000_0000, 1'b0, 1'b0, 1'b0, 5'd16, 32'hAAAA_BBBB, 32'hCCCC_DDDD, 1'b1, 1'b1, 5'd8, 5'd9);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Load Word (LW) Instruction signals", test_num);
            reset_dut();


            ALUOPID    = 2'b00;
            ALUsrcID   = 1'b1;
            ImmExtID   = 32'h0000_0004;
            MemReadID  = 1'b1;
            MemtoregID = 1'b1;
            MemwriteID = 1'b0;
            Rd         = 5'd0;
            ReadData1  = 32'h1000_0000;
            ReadData2  = 32'h0000_0000;
            RegDstID   = 1'b0;
            RegWriteID = 1'b1;
            Rs         = 5'd10;
            Rt         = 5'd11;

            @(posedge CLK);
            #2;

            #1;


            check_outputs(2'b00, 1'b1, 32'h0000_0004, 1'b1, 1'b1, 1'b0, 5'd0, 32'h1000_0000, 32'h0000_0000, 1'b0, 1'b1, 5'd10, 5'd11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Store Word (SW) Instruction signals", test_num);
            reset_dut();


            ALUOPID    = 2'b00;
            ALUsrcID   = 1'b1;
            ImmExtID   = 32'hFFFF_FFF0;
            MemReadID  = 1'b0;
            MemtoregID = 1'b0;
            MemwriteID = 1'b1;
            Rd         = 5'd0;
            ReadData1  = 32'h2000_0000;
            ReadData2  = 32'h5555_6666;
            RegDstID   = 1'b0;
            RegWriteID = 1'b0;
            Rs         = 5'd12;
            Rt         = 5'd13;

            @(posedge CLK);
            #2;

            #1;


            check_outputs(2'b00, 1'b1, 32'hFFFF_FFF0, 1'b0, 1'b0, 1'b1, 5'd0, 32'h2000_0000, 32'h5555_6666, 1'b0, 1'b0, 5'd12, 5'd13);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Branch/ALU Imm Instruction (Max values)", test_num);
            reset_dut();


            ALUOPID    = 2'b11;
            ALUsrcID   = 1'b1;
            ImmExtID   = 32'hFFFF_FFFF;
            MemReadID  = 1'b1;
            MemtoregID = 1'b1;
            MemwriteID = 1'b1;
            Rd         = 5'h1F;
            ReadData1  = 32'hFFFF_FFFF;
            ReadData2  = 32'hFFFF_FFFF;
            RegDstID   = 1'b1;
            RegWriteID = 1'b1;
            Rs         = 5'h1F;
            Rt         = 5'h1F;

            @(posedge CLK);
            #2;

            #1;


            check_outputs(2'b11, 1'b1, 32'hFFFF_FFFF, 1'b1, 1'b1, 1'b1, 5'h1F, 32'hFFFF_FFFF, 32'hFFFF_FFFF, 1'b1, 1'b1, 5'h1F, 5'h1F);
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
        input [1:0] expected_ALUOPEX;
        input expected_ALUsrcEX;
        input [31:0] expected_ImmExtEX;
        input expected_MemReadEX;
        input expected_MemtoregEX;
        input expected_MemwriteEX;
        input [4:0] expected_RdEX;
        input [31:0] expected_ReadData1EX;
        input [31:0] expected_ReadData2EX;
        input expected_RegDstEX;
        input expected_RegWriteEX;
        input [4:0] expected_RsEX;
        input [4:0] expected_RtEX;
        begin
            if (expected_ALUOPEX === (expected_ALUOPEX ^ ALUOPEX ^ expected_ALUOPEX) &&
                expected_ALUsrcEX === (expected_ALUsrcEX ^ ALUsrcEX ^ expected_ALUsrcEX) &&
                expected_ImmExtEX === (expected_ImmExtEX ^ ImmExtEX ^ expected_ImmExtEX) &&
                expected_MemReadEX === (expected_MemReadEX ^ MemReadEX ^ expected_MemReadEX) &&
                expected_MemtoregEX === (expected_MemtoregEX ^ MemtoregEX ^ expected_MemtoregEX) &&
                expected_MemwriteEX === (expected_MemwriteEX ^ MemwriteEX ^ expected_MemwriteEX) &&
                expected_RdEX === (expected_RdEX ^ RdEX ^ expected_RdEX) &&
                expected_ReadData1EX === (expected_ReadData1EX ^ ReadData1EX ^ expected_ReadData1EX) &&
                expected_ReadData2EX === (expected_ReadData2EX ^ ReadData2EX ^ expected_ReadData2EX) &&
                expected_RegDstEX === (expected_RegDstEX ^ RegDstEX ^ expected_RegDstEX) &&
                expected_RegWriteEX === (expected_RegWriteEX ^ RegWriteEX ^ expected_RegWriteEX) &&
                expected_RsEX === (expected_RsEX ^ RsEX ^ expected_RsEX) &&
                expected_RtEX === (expected_RtEX ^ RtEX ^ expected_RtEX)) begin
                $display("PASS");
                $display("  Outputs: ALUOPEX=%h, ALUsrcEX=%b, ImmExtEX=%h, MemReadEX=%b, MemtoregEX=%b, MemwriteEX=%b, RdEX=%h, ReadData1EX=%h, ReadData2EX=%h, RegDstEX=%b, RegWriteEX=%b, RsEX=%h, RtEX=%h",
                         ALUOPEX, ALUsrcEX, ImmExtEX, MemReadEX, MemtoregEX, MemwriteEX, RdEX, ReadData1EX, ReadData2EX, RegDstEX, RegWriteEX, RsEX, RtEX);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUOPEX=%h, ALUsrcEX=%b, ImmExtEX=%h, MemReadEX=%b, MemtoregEX=%b, MemwriteEX=%b, RdEX=%h, ReadData1EX=%h, ReadData2EX=%h, RegDstEX=%b, RegWriteEX=%b, RsEX=%h, RtEX=%h",
                         expected_ALUOPEX, expected_ALUsrcEX, expected_ImmExtEX, expected_MemReadEX, expected_MemtoregEX, expected_MemwriteEX, expected_RdEX, expected_ReadData1EX, expected_ReadData2EX, expected_RegDstEX, expected_RegWriteEX, expected_RsEX, expected_RtEX);
                $display("  Got:      ALUOPEX=%h, ALUsrcEX=%b, ImmExtEX=%h, MemReadEX=%b, MemtoregEX=%b, MemwriteEX=%b, RdEX=%h, ReadData1EX=%h, ReadData2EX=%h, RegDstEX=%b, RegWriteEX=%b, RsEX=%h, RtEX=%h",
                         ALUOPEX, ALUsrcEX, ImmExtEX, MemReadEX, MemtoregEX, MemwriteEX, RdEX, ReadData1EX, ReadData2EX, RegDstEX, RegWriteEX, RsEX, RtEX);
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
        $dumpvars(0,ALUOPID, ALUsrcID, CLK, ImmExtID, MemReadID, MemtoregID, MemwriteID, Rd, ReadData1, ReadData2, RegDstID, RegWriteID, Rs, Rt, ALUOPEX, ALUsrcEX, ImmExtEX, MemReadEX, MemtoregEX, MemwriteEX, RdEX, ReadData1EX, ReadData2EX, RegDstEX, RegWriteEX, RsEX, RtEX);
    end

endmodule
