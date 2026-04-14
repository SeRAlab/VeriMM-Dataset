`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Branch;
    reg ControlJump;
    reg [31:0] Fetch;
    reg MemRead;
    reg MemWrite;
    reg MemtoReg;
    reg RegWrite;
    reg [31:0] Res_ALU;
    reg [31:0] Write_Data;
    reg [4:0] Write_Reg;
    reg clk;
    reg [31:0] contadorPc;
    reg [31:0] target;
    reg zero_flag;
    wire SBranch;
    wire [31:0] SContadorPc;
    wire SControlJump;
    wire [31:0] SFetch;
    wire SMemRead;
    wire SMemWrite;
    wire SMemtoReg;
    wire SRegWrite;
    wire [31:0] SRes_ALU;
    wire [31:0] SalWD;
    wire [4:0] Sal_WR;
    wire Sal_zf;
    wire [31:0] Starget;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Branch(Branch),
        .ControlJump(ControlJump),
        .Fetch(Fetch),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .Res_ALU(Res_ALU),
        .Write_Data(Write_Data),
        .Write_Reg(Write_Reg),
        .clk(clk),
        .contadorPc(contadorPc),
        .target(target),
        .zero_flag(zero_flag),
        .SBranch(SBranch),
        .SContadorPc(SContadorPc),
        .SControlJump(SControlJump),
        .SFetch(SFetch),
        .SMemRead(SMemRead),
        .SMemWrite(SMemWrite),
        .SMemtoReg(SMemtoReg),
        .SRegWrite(SRegWrite),
        .SRes_ALU(SRes_ALU),
        .SalWD(SalWD),
        .Sal_WR(Sal_WR),
        .Sal_zf(Sal_zf),
        .Starget(Starget)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            Branch = 0;
            ControlJump = 0;
            Fetch = 0;
            MemRead = 0;
            MemWrite = 0;
            MemtoReg = 0;
            RegWrite = 0;
            Res_ALU = 0;
            Write_Data = 0;
            Write_Reg = 0;
            contadorPc = 0;
            target = 0;
            zero_flag = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            Branch = 1;
            ControlJump = 0;
            Fetch = 32'hDEADBEEF;
            MemRead = 1;
            MemWrite = 0;
            MemtoReg = 1;
            RegWrite = 1;
            Res_ALU = 32'h00001234;
            Write_Data = 32'hCAFEF00D;
            Write_Reg = 5'd15;
            contadorPc = 32'h00400000;
            target = 32'h00400010;
            zero_flag = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(1, 32'h00400000, 0, 32'hDEADBEEF, 1, 0, 1, 1, 32'h00001234, 32'hCAFEF00D, 5'd15, 1, 32'h00400010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            Branch = 0;
            ControlJump = 1;
            Fetch = 32'hFFFFFFFF;
            MemRead = 0;
            MemWrite = 1;
            MemtoReg = 0;
            RegWrite = 0;
            Res_ALU = 32'hFFFFFFFF;
            Write_Data = 32'hAAAAAAAA;
            Write_Reg = 5'd31;
            contadorPc = 32'hFFFFFFFF;
            target = 32'h55555555;
            zero_flag = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 32'hFFFFFFFF, 1, 32'hFFFFFFFF, 0, 1, 0, 0, 32'hFFFFFFFF, 32'hAAAAAAAA, 5'd31, 0, 32'h55555555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            Branch = 1;
            Res_ALU = 32'h11112222;
            Write_Reg = 5'd10;
            @(posedge clk);
            #2;


            Branch = 0;
            Res_ALU = 32'h0;
            Write_Reg = 5'd0;
            #1;


            #1;



            check_outputs(1, 32'h0, 0, 32'h0, 0, 0, 0, 0, 32'h11112222, 32'h0, 5'd10, 0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            Branch = 0;
            ControlJump = 0;
            Fetch = 32'h0;
            MemRead = 0;
            MemWrite = 0;
            MemtoReg = 0;
            RegWrite = 0;
            Res_ALU = 32'h0;
            Write_Data = 32'h0;
            Write_Reg = 5'd0;
            contadorPc = 32'h0;
            target = 32'h0;
            zero_flag = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 32'h0, 0, 32'h0, 0, 0, 0, 0, 32'h0, 32'h0, 5'd0, 0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            Branch = 1;
            ControlJump = 1;
            Fetch = 32'h5555AAAA;
            MemRead = 1;
            MemWrite = 1;
            MemtoReg = 1;
            RegWrite = 1;
            Res_ALU = 32'hAAAA5555;
            Write_Data = 32'h0F0F0F0F;
            Write_Reg = 5'b10101;
            contadorPc = 32'hF0F0F0F0;
            target = 32'hCCCCCCCC;
            zero_flag = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(1, 32'hF0F0F0F0, 1, 32'h5555AAAA, 1, 1, 1, 1, 32'hAAAA5555, 32'h0F0F0F0F, 5'b10101, 1, 32'hCCCCCCCC);
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
        input expected_SBranch;
        input [31:0] expected_SContadorPc;
        input expected_SControlJump;
        input [31:0] expected_SFetch;
        input expected_SMemRead;
        input expected_SMemWrite;
        input expected_SMemtoReg;
        input expected_SRegWrite;
        input [31:0] expected_SRes_ALU;
        input [31:0] expected_SalWD;
        input [4:0] expected_Sal_WR;
        input expected_Sal_zf;
        input [31:0] expected_Starget;
        begin
            if (expected_SBranch === (expected_SBranch ^ SBranch ^ expected_SBranch) &&
                expected_SContadorPc === (expected_SContadorPc ^ SContadorPc ^ expected_SContadorPc) &&
                expected_SControlJump === (expected_SControlJump ^ SControlJump ^ expected_SControlJump) &&
                expected_SFetch === (expected_SFetch ^ SFetch ^ expected_SFetch) &&
                expected_SMemRead === (expected_SMemRead ^ SMemRead ^ expected_SMemRead) &&
                expected_SMemWrite === (expected_SMemWrite ^ SMemWrite ^ expected_SMemWrite) &&
                expected_SMemtoReg === (expected_SMemtoReg ^ SMemtoReg ^ expected_SMemtoReg) &&
                expected_SRegWrite === (expected_SRegWrite ^ SRegWrite ^ expected_SRegWrite) &&
                expected_SRes_ALU === (expected_SRes_ALU ^ SRes_ALU ^ expected_SRes_ALU) &&
                expected_SalWD === (expected_SalWD ^ SalWD ^ expected_SalWD) &&
                expected_Sal_WR === (expected_Sal_WR ^ Sal_WR ^ expected_Sal_WR) &&
                expected_Sal_zf === (expected_Sal_zf ^ Sal_zf ^ expected_Sal_zf) &&
                expected_Starget === (expected_Starget ^ Starget ^ expected_Starget)) begin
                $display("PASS");
                $display("  Outputs: SBranch=%b, SContadorPc=%h, SControlJump=%b, SFetch=%h, SMemRead=%b, SMemWrite=%b, SMemtoReg=%b, SRegWrite=%b, SRes_ALU=%h, SalWD=%h, Sal_WR=%h, Sal_zf=%b, Starget=%h",
                         SBranch, SContadorPc, SControlJump, SFetch, SMemRead, SMemWrite, SMemtoReg, SRegWrite, SRes_ALU, SalWD, Sal_WR, Sal_zf, Starget);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SBranch=%b, SContadorPc=%h, SControlJump=%b, SFetch=%h, SMemRead=%b, SMemWrite=%b, SMemtoReg=%b, SRegWrite=%b, SRes_ALU=%h, SalWD=%h, Sal_WR=%h, Sal_zf=%b, Starget=%h",
                         expected_SBranch, expected_SContadorPc, expected_SControlJump, expected_SFetch, expected_SMemRead, expected_SMemWrite, expected_SMemtoReg, expected_SRegWrite, expected_SRes_ALU, expected_SalWD, expected_Sal_WR, expected_Sal_zf, expected_Starget);
                $display("  Got:      SBranch=%b, SContadorPc=%h, SControlJump=%b, SFetch=%h, SMemRead=%b, SMemWrite=%b, SMemtoReg=%b, SRegWrite=%b, SRes_ALU=%h, SalWD=%h, Sal_WR=%h, Sal_zf=%b, Starget=%h",
                         SBranch, SContadorPc, SControlJump, SFetch, SMemRead, SMemWrite, SMemtoReg, SRegWrite, SRes_ALU, SalWD, Sal_WR, Sal_zf, Starget);
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
        $dumpvars(0,Branch, ControlJump, Fetch, MemRead, MemWrite, MemtoReg, RegWrite, Res_ALU, Write_Data, Write_Reg, clk, contadorPc, target, zero_flag, SBranch, SContadorPc, SControlJump, SFetch, SMemRead, SMemWrite, SMemtoReg, SRegWrite, SRes_ALU, SalWD, Sal_WR, Sal_zf, Starget);
    end

endmodule
