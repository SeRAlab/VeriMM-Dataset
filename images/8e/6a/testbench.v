`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg MemtoReg;
    reg [31:0] Read_Data;
    reg RegWrite;
    reg [31:0] ResALU;
    reg [4:0] Write_Reg;
    reg clk;
    wire SMemtoReg;
    wire SRegWrite;
    wire [31:0] SResALU;
    wire [31:0] Sal_RD;
    wire [4:0] Sal_WR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MemtoReg(MemtoReg),
        .Read_Data(Read_Data),
        .RegWrite(RegWrite),
        .ResALU(ResALU),
        .Write_Reg(Write_Reg),
        .clk(clk),
        .SMemtoReg(SMemtoReg),
        .SRegWrite(SRegWrite),
        .SResALU(SResALU),
        .Sal_RD(Sal_RD),
        .Sal_WR(Sal_WR)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        MemtoReg = 0;
        Read_Data = 0;
        RegWrite = 0;
        ResALU = 0;
        Write_Reg = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Data Retention", test_num);
        reset_dut();
        MemtoReg = 1;
        RegWrite = 1;
        Read_Data = 32'h12345678;
        ResALU = 32'h87654321;
        Write_Reg = 5'h1F;

        @(posedge clk);
        #2;
        #1;

        check_outputs(1, 1, 32'h87654321, 32'h12345678, 5'h1F);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Zeros check", test_num);
        reset_dut();
        MemtoReg = 0;
        RegWrite = 0;
        Read_Data = 32'h00000000;
        ResALU = 32'h00000000;
        Write_Reg = 5'h00;

        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 0, 32'h0, 32'h0, 5'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum Values check", test_num);
        reset_dut();
        MemtoReg = 1;
        RegWrite = 1;
        Read_Data = 32'hFFFFFFFF;
        ResALU = 32'hFFFFFFFF;
        Write_Reg = 5'h1F;

        @(posedge clk);
        #2;
        #1;

        check_outputs(1, 1, 32'hFFFFFFFF, 32'hFFFFFFFF, 5'h1F);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating Bits pattern", test_num);
        reset_dut();
        MemtoReg = 0;
        RegWrite = 1;
        Read_Data = 32'hAAAAAAAA;
        ResALU = 32'h55555555;
        Write_Reg = 5'h0A;

        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 1, 32'h55555555, 32'hAAAAAAAA, 5'h0A);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Control Signal MemtoReg high, RegWrite low", test_num);
        reset_dut();
        MemtoReg = 1;
        RegWrite = 0;
        Read_Data = 32'hCAFEFEED;
        ResALU = 32'hBADC0FFEE;
        Write_Reg = 5'h05;

        @(posedge clk);
        #2;
        #1;

        check_outputs(1, 0, 32'hBADC0FFEE, 32'hCAFEFEED, 5'h05);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Rapid sequential changes", test_num);
        reset_dut();


        MemtoReg = 1;
        RegWrite = 1;
        Read_Data = 32'h11111111;
        ResALU = 32'h22222222;
        Write_Reg = 5'h01;
        @(posedge clk);
        #1;


        MemtoReg = 0;
        RegWrite = 0;
        Read_Data = 32'h33333333;
        ResALU = 32'h44444444;
        Write_Reg = 5'h02;


        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 0, 32'h44444444, 32'h33333333, 5'h02);
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
        input expected_SMemtoReg;
        input expected_SRegWrite;
        input [31:0] expected_SResALU;
        input [31:0] expected_Sal_RD;
        input [4:0] expected_Sal_WR;
        begin
            if (expected_SMemtoReg === (expected_SMemtoReg ^ SMemtoReg ^ expected_SMemtoReg) &&
                expected_SRegWrite === (expected_SRegWrite ^ SRegWrite ^ expected_SRegWrite) &&
                expected_SResALU === (expected_SResALU ^ SResALU ^ expected_SResALU) &&
                expected_Sal_RD === (expected_Sal_RD ^ Sal_RD ^ expected_Sal_RD) &&
                expected_Sal_WR === (expected_Sal_WR ^ Sal_WR ^ expected_Sal_WR)) begin
                $display("PASS");
                $display("  Outputs: SMemtoReg=%b, SRegWrite=%b, SResALU=%h, Sal_RD=%h, Sal_WR=%h",
                         SMemtoReg, SRegWrite, SResALU, Sal_RD, Sal_WR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SMemtoReg=%b, SRegWrite=%b, SResALU=%h, Sal_RD=%h, Sal_WR=%h",
                         expected_SMemtoReg, expected_SRegWrite, expected_SResALU, expected_Sal_RD, expected_Sal_WR);
                $display("  Got:      SMemtoReg=%b, SRegWrite=%b, SResALU=%h, Sal_RD=%h, Sal_WR=%h",
                         SMemtoReg, SRegWrite, SResALU, Sal_RD, Sal_WR);
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
        $dumpvars(0,MemtoReg, Read_Data, RegWrite, ResALU, Write_Reg, clk, SMemtoReg, SRegWrite, SResALU, Sal_RD, Sal_WR);
    end

endmodule
