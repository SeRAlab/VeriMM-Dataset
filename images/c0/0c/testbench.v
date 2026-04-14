`timescale 1ns/1ps

module EXMEM_Stage_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] EX_ALU_Result;
    reg EX_BZero;
    reg EX_Flush;
    reg EX_IsBDS;
    reg EX_KernelMode;
    reg EX_LLSC;
    reg EX_Left;
    reg EX_M_CanErr;
    reg EX_MemByte;
    reg EX_MemHalf;
    reg EX_MemRead;
    reg EX_MemSignExtend;
    reg EX_MemWrite;
    reg EX_MemtoReg;
    reg EX_Movn;
    reg EX_Movz;
    reg [31:0] EX_ReadData2;
    reg EX_RegWrite;
    reg [31:0] EX_RestartPC;
    reg EX_ReverseEndian;
    reg EX_Right;
    reg [4:0] EX_RtRd;
    reg EX_Stall;
    reg EX_Trap;
    reg EX_TrapCond;
    reg M_Stall;
    reg clock;
    reg reset;
    wire [31:0] M_ALU_Result;
    wire M_IsBDS;
    wire M_KernelMode;
    wire M_LLSC;
    wire M_Left;
    wire M_M_CanErr;
    wire M_MemByte;
    wire M_MemHalf;
    wire M_MemRead;
    wire M_MemSignExtend;
    wire M_MemWrite;
    wire M_MemtoReg;
    wire [31:0] M_ReadData2;
    wire M_RegWrite;
    wire [31:0] M_RestartPC;
    wire M_ReverseEndian;
    wire M_Right;
    wire [4:0] M_RtRd;
    wire M_Trap;
    wire M_TrapCond;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    EXMEM_Stage dut (
        .EX_ALU_Result(EX_ALU_Result),
        .EX_BZero(EX_BZero),
        .EX_Flush(EX_Flush),
        .EX_IsBDS(EX_IsBDS),
        .EX_KernelMode(EX_KernelMode),
        .EX_LLSC(EX_LLSC),
        .EX_Left(EX_Left),
        .EX_M_CanErr(EX_M_CanErr),
        .EX_MemByte(EX_MemByte),
        .EX_MemHalf(EX_MemHalf),
        .EX_MemRead(EX_MemRead),
        .EX_MemSignExtend(EX_MemSignExtend),
        .EX_MemWrite(EX_MemWrite),
        .EX_MemtoReg(EX_MemtoReg),
        .EX_Movn(EX_Movn),
        .EX_Movz(EX_Movz),
        .EX_ReadData2(EX_ReadData2),
        .EX_RegWrite(EX_RegWrite),
        .EX_RestartPC(EX_RestartPC),
        .EX_ReverseEndian(EX_ReverseEndian),
        .EX_Right(EX_Right),
        .EX_RtRd(EX_RtRd),
        .EX_Stall(EX_Stall),
        .EX_Trap(EX_Trap),
        .EX_TrapCond(EX_TrapCond),
        .M_Stall(M_Stall),
        .clock(clock),
        .reset(reset),
        .M_ALU_Result(M_ALU_Result),
        .M_IsBDS(M_IsBDS),
        .M_KernelMode(M_KernelMode),
        .M_LLSC(M_LLSC),
        .M_Left(M_Left),
        .M_M_CanErr(M_M_CanErr),
        .M_MemByte(M_MemByte),
        .M_MemHalf(M_MemHalf),
        .M_MemRead(M_MemRead),
        .M_MemSignExtend(M_MemSignExtend),
        .M_MemWrite(M_MemWrite),
        .M_MemtoReg(M_MemtoReg),
        .M_ReadData2(M_ReadData2),
        .M_RegWrite(M_RegWrite),
        .M_RestartPC(M_RestartPC),
        .M_ReverseEndian(M_ReverseEndian),
        .M_Right(M_Right),
        .M_RtRd(M_RtRd),
        .M_Trap(M_Trap),
        .M_TrapCond(M_TrapCond)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            EX_ALU_Result = 0;
            EX_BZero = 0;
            EX_Flush = 0;
            EX_IsBDS = 0;
            EX_KernelMode = 0;
            EX_LLSC = 0;
            EX_Left = 0;
            EX_M_CanErr = 0;
            EX_MemByte = 0;
            EX_MemHalf = 0;
            EX_MemRead = 0;
            EX_MemSignExtend = 0;
            EX_MemWrite = 0;
            EX_MemtoReg = 0;
            EX_Movn = 0;
            EX_Movz = 0;
            EX_ReadData2 = 0;
            EX_RegWrite = 0;
            EX_RestartPC = 0;
            EX_ReverseEndian = 0;
            EX_Right = 0;
            EX_RtRd = 0;
            EX_Stall = 0;
            EX_Trap = 0;
            EX_TrapCond = 0;
            M_Stall = 0;
            @(posedge clock);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            EX_ALU_Result = 32'hDEADBEEF;
            EX_ReadData2  = 32'h12345678;
            EX_RestartPC  = 32'h00400000;
            EX_RtRd       = 5'd15;
            EX_RegWrite   = 1;
            EX_MemRead    = 1;

            @(posedge clock);
            #2;
            #1;

            check_outputs(32'hDEADBEEF, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 32'h12345678, 1, 32'h00400000, 0, 0, 5'd15, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            EX_ALU_Result = 32'hAAAA_BBBB;
            EX_RegWrite   = 1;
            EX_Flush      = 1;

            @(posedge clock);
            #2;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            EX_ALU_Result = 32'h1111_1111;
            EX_RtRd       = 5'd1;
            @(posedge clock);
            #2;


            M_Stall = 1;
            EX_ALU_Result = 32'h2222_2222;
            EX_RtRd       = 5'd2;
            @(posedge clock);
            #2;


            #1;



            check_outputs(32'h1111_1111, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5'd1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            EX_Movn       = 1;
            EX_BZero      = 0;
            EX_RegWrite   = 1;
            EX_ALU_Result = 32'hC0DE_C0DE;
            EX_RtRd       = 5'd10;

            @(posedge clock);
            #2;
            #1;

            check_outputs(32'hC0DE_C0DE, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 5'd10, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            EX_Movn       = 1;
            EX_BZero      = 1;
            EX_RegWrite   = 1;
            EX_ALU_Result = 32'h0000_0000;
            EX_RtRd       = 5'd10;

            @(posedge clock);
            #2;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5'd10, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            EX_Movz       = 1;
            EX_BZero      = 1;
            EX_RegWrite   = 1;
            EX_ALU_Result = 32'h0000_0000;
            EX_RtRd       = 5'd20;

            @(posedge clock);
            #2;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 5'd20, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();

            EX_Movz       = 1;
            EX_BZero      = 0;
            EX_RegWrite   = 1;
            EX_ALU_Result = 32'hBEEF_BEEF;
            EX_RtRd       = 5'd20;

            @(posedge clock);
            #2;

            #1;


            check_outputs(32'hBEEF_BEEF, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5'd20, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();

            EX_MemByte       = 1;
            EX_MemSignExtend = 1;
            EX_LLSC          = 1;
            EX_KernelMode    = 1;
            EX_IsBDS         = 1;
            EX_ReverseEndian = 1;
            EX_Trap          = 1;
            EX_TrapCond      = 1;
            EX_ALU_Result    = 32'hF00D_F00D;

            @(posedge clock);
            #2;
            #1;

            check_outputs(32'hF00D_F00D, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();

            EX_Stall      = 1;
            EX_ALU_Result = 32'hFFFF_FFFF;
            EX_RegWrite   = 1;

            @(posedge clock);
            #2;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();

            EX_ALU_Result = 32'h1234_5678;
            EX_RegWrite   = 1;
            reset = 1;

            @(posedge clock);
            #2;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("EXMEM_Stage Testbench");
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
        input [31:0] expected_M_ALU_Result;
        input expected_M_IsBDS;
        input expected_M_KernelMode;
        input expected_M_LLSC;
        input expected_M_Left;
        input expected_M_M_CanErr;
        input expected_M_MemByte;
        input expected_M_MemHalf;
        input expected_M_MemRead;
        input expected_M_MemSignExtend;
        input expected_M_MemWrite;
        input expected_M_MemtoReg;
        input [31:0] expected_M_ReadData2;
        input expected_M_RegWrite;
        input [31:0] expected_M_RestartPC;
        input expected_M_ReverseEndian;
        input expected_M_Right;
        input [4:0] expected_M_RtRd;
        input expected_M_Trap;
        input expected_M_TrapCond;
        begin
            if (expected_M_ALU_Result === (expected_M_ALU_Result ^ M_ALU_Result ^ expected_M_ALU_Result) &&
                expected_M_IsBDS === (expected_M_IsBDS ^ M_IsBDS ^ expected_M_IsBDS) &&
                expected_M_KernelMode === (expected_M_KernelMode ^ M_KernelMode ^ expected_M_KernelMode) &&
                expected_M_LLSC === (expected_M_LLSC ^ M_LLSC ^ expected_M_LLSC) &&
                expected_M_Left === (expected_M_Left ^ M_Left ^ expected_M_Left) &&
                expected_M_M_CanErr === (expected_M_M_CanErr ^ M_M_CanErr ^ expected_M_M_CanErr) &&
                expected_M_MemByte === (expected_M_MemByte ^ M_MemByte ^ expected_M_MemByte) &&
                expected_M_MemHalf === (expected_M_MemHalf ^ M_MemHalf ^ expected_M_MemHalf) &&
                expected_M_MemRead === (expected_M_MemRead ^ M_MemRead ^ expected_M_MemRead) &&
                expected_M_MemSignExtend === (expected_M_MemSignExtend ^ M_MemSignExtend ^ expected_M_MemSignExtend) &&
                expected_M_MemWrite === (expected_M_MemWrite ^ M_MemWrite ^ expected_M_MemWrite) &&
                expected_M_MemtoReg === (expected_M_MemtoReg ^ M_MemtoReg ^ expected_M_MemtoReg) &&
                expected_M_ReadData2 === (expected_M_ReadData2 ^ M_ReadData2 ^ expected_M_ReadData2) &&
                expected_M_RegWrite === (expected_M_RegWrite ^ M_RegWrite ^ expected_M_RegWrite) &&
                expected_M_RestartPC === (expected_M_RestartPC ^ M_RestartPC ^ expected_M_RestartPC) &&
                expected_M_ReverseEndian === (expected_M_ReverseEndian ^ M_ReverseEndian ^ expected_M_ReverseEndian) &&
                expected_M_Right === (expected_M_Right ^ M_Right ^ expected_M_Right) &&
                expected_M_RtRd === (expected_M_RtRd ^ M_RtRd ^ expected_M_RtRd) &&
                expected_M_Trap === (expected_M_Trap ^ M_Trap ^ expected_M_Trap) &&
                expected_M_TrapCond === (expected_M_TrapCond ^ M_TrapCond ^ expected_M_TrapCond)) begin
                $display("PASS");
                $display("  Outputs: M_ALU_Result=%h, M_IsBDS=%b, M_KernelMode=%b, M_LLSC=%b, M_Left=%b, M_M_CanErr=%b, M_MemByte=%b, M_MemHalf=%b, M_MemRead=%b, M_MemSignExtend=%b, M_MemWrite=%b, M_MemtoReg=%b, M_ReadData2=%h, M_RegWrite=%b, M_RestartPC=%h, M_ReverseEndian=%b, M_Right=%b, M_RtRd=%h, M_Trap=%b, M_TrapCond=%b",
                         M_ALU_Result, M_IsBDS, M_KernelMode, M_LLSC, M_Left, M_M_CanErr, M_MemByte, M_MemHalf, M_MemRead, M_MemSignExtend, M_MemWrite, M_MemtoReg, M_ReadData2, M_RegWrite, M_RestartPC, M_ReverseEndian, M_Right, M_RtRd, M_Trap, M_TrapCond);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: M_ALU_Result=%h, M_IsBDS=%b, M_KernelMode=%b, M_LLSC=%b, M_Left=%b, M_M_CanErr=%b, M_MemByte=%b, M_MemHalf=%b, M_MemRead=%b, M_MemSignExtend=%b, M_MemWrite=%b, M_MemtoReg=%b, M_ReadData2=%h, M_RegWrite=%b, M_RestartPC=%h, M_ReverseEndian=%b, M_Right=%b, M_RtRd=%h, M_Trap=%b, M_TrapCond=%b",
                         expected_M_ALU_Result, expected_M_IsBDS, expected_M_KernelMode, expected_M_LLSC, expected_M_Left, expected_M_M_CanErr, expected_M_MemByte, expected_M_MemHalf, expected_M_MemRead, expected_M_MemSignExtend, expected_M_MemWrite, expected_M_MemtoReg, expected_M_ReadData2, expected_M_RegWrite, expected_M_RestartPC, expected_M_ReverseEndian, expected_M_Right, expected_M_RtRd, expected_M_Trap, expected_M_TrapCond);
                $display("  Got:      M_ALU_Result=%h, M_IsBDS=%b, M_KernelMode=%b, M_LLSC=%b, M_Left=%b, M_M_CanErr=%b, M_MemByte=%b, M_MemHalf=%b, M_MemRead=%b, M_MemSignExtend=%b, M_MemWrite=%b, M_MemtoReg=%b, M_ReadData2=%h, M_RegWrite=%b, M_RestartPC=%h, M_ReverseEndian=%b, M_Right=%b, M_RtRd=%h, M_Trap=%b, M_TrapCond=%b",
                         M_ALU_Result, M_IsBDS, M_KernelMode, M_LLSC, M_Left, M_M_CanErr, M_MemByte, M_MemHalf, M_MemRead, M_MemSignExtend, M_MemWrite, M_MemtoReg, M_ReadData2, M_RegWrite, M_RestartPC, M_ReverseEndian, M_Right, M_RtRd, M_Trap, M_TrapCond);
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
        $dumpvars(0,EX_ALU_Result, EX_BZero, EX_Flush, EX_IsBDS, EX_KernelMode, EX_LLSC, EX_Left, EX_M_CanErr, EX_MemByte, EX_MemHalf, EX_MemRead, EX_MemSignExtend, EX_MemWrite, EX_MemtoReg, EX_Movn, EX_Movz, EX_ReadData2, EX_RegWrite, EX_RestartPC, EX_ReverseEndian, EX_Right, EX_RtRd, EX_Stall, EX_Trap, EX_TrapCond, M_Stall, clock, reset, M_ALU_Result, M_IsBDS, M_KernelMode, M_LLSC, M_Left, M_M_CanErr, M_MemByte, M_MemHalf, M_MemRead, M_MemSignExtend, M_MemWrite, M_MemtoReg, M_ReadData2, M_RegWrite, M_RestartPC, M_ReverseEndian, M_Right, M_RtRd, M_Trap, M_TrapCond);
    end

endmodule
