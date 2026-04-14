`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ALUout;
    reg XM_MemToReg;
    reg XM_MemWrite;
    reg [4:0] XM_RD;
    reg [31:0] XM_RT;
    reg bnoWB;
    reg clk;
    reg en;
    reg rst;
    wire [31:0] MW_ALUout;
    wire [4:0] MW_RD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUout(ALUout),
        .XM_MemToReg(XM_MemToReg),
        .XM_MemWrite(XM_MemWrite),
        .XM_RD(XM_RD),
        .XM_RT(XM_RT),
        .bnoWB(bnoWB),
        .clk(clk),
        .en(en),
        .rst(rst),
        .MW_ALUout(MW_ALUout),
        .MW_RD(MW_RD)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        ALUout = 0;
        XM_MemToReg = 0;
        XM_MemWrite = 0;
        XM_RD = 0;
        XM_RT = 0;
        bnoWB = 0;
        en = 0;
        #20;
        rst = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Test Case 001: Reset Initialization");
        #1;

        check_outputs(32'h0, 5'h0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Test Case 002: ALU Pass-through (XM_MemToReg=0)");
        en = 1;
        ALUout = 32'hABCDEF01;
        XM_RD = 5'd10;
        XM_MemToReg = 0;
        bnoWB = 0;
        #10;
        #1;

        check_outputs(32'hABCDEF01, 5'd10);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Test Case 003: Memory Write then Read");
        en = 1;

        ALUout = 32'h4;
        XM_RT = 32'hDEADBEEF;
        XM_MemWrite = 1;
        @(posedge clk);
        #2;


        XM_MemWrite = 0;
        XM_MemToReg = 1;
        ALUout = 32'h4;
        XM_RD = 5'd15;
        bnoWB = 0;
        #10;
        #1;

        check_outputs(32'hDEADBEEF, 5'd15);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Test Case 004: bnoWB Logic Check");
        en = 1;
        ALUout = 32'h20;
        XM_RD = 5'd31;
        XM_MemToReg = 0;
        bnoWB = 1;
        #10;
        #1;

        check_outputs(32'h20, 5'h0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Test Case 005: Module Disable Check (en=0)");

        en = 1;
        ALUout = 32'h10;
        XM_RT = 32'h12345678;
        XM_MemWrite = 1;
        @(posedge clk);
        #2;


        en = 0;
        XM_MemWrite = 0;
        XM_MemToReg = 1;
        ALUout = 32'h10;
        XM_RD = 5'd5;
        bnoWB = 0;
        #10;

        #1;


        check_outputs(32'h10, 5'd5);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        $display("Test Case 006: Multiple Memory Addresses");
        en = 1;

        ALUout = 32'h1;
        XM_RT = 32'hAAAA_AAAA;
        XM_MemWrite = 1;
        @(posedge clk); #2;


        ALUout = 32'h2;
        XM_RT = 32'hBBBB_BBBB;
        XM_MemWrite = 1;
        @(posedge clk); #2;


        XM_MemWrite = 0;
        XM_MemToReg = 1;
        ALUout = 32'h1;
        XM_RD = 5'd1;
        #10;
        #1;

        check_outputs(32'hAAAA_AAAA, 5'd1);
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
        input [31:0] expected_MW_ALUout;
        input [4:0] expected_MW_RD;
        begin
            if (expected_MW_ALUout === (expected_MW_ALUout ^ MW_ALUout ^ expected_MW_ALUout) &&
                expected_MW_RD === (expected_MW_RD ^ MW_RD ^ expected_MW_RD)) begin
                $display("PASS");
                $display("  Outputs: MW_ALUout=%h, MW_RD=%h",
                         MW_ALUout, MW_RD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MW_ALUout=%h, MW_RD=%h",
                         expected_MW_ALUout, expected_MW_RD);
                $display("  Got:      MW_ALUout=%h, MW_RD=%h",
                         MW_ALUout, MW_RD);
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
        $dumpvars(0,ALUout, XM_MemToReg, XM_MemWrite, XM_RD, XM_RT, bnoWB, clk, en, rst, MW_ALUout, MW_RD);
    end

endmodule
