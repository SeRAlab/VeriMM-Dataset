`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ALU_out;
    reg MemtoReg;
    reg [31:0] RD;
    reg RegWrite;
    reg [4:0] WN;
    reg clk;
    wire [31:0] MEM_WB_ALU_out;
    wire MEM_WB_MemtoReg;
    wire [31:0] MEM_WB_RD;
    wire MEM_WB_RegWrite;
    wire [4:0] MEM_WB_WN;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_out(ALU_out),
        .MemtoReg(MemtoReg),
        .RD(RD),
        .RegWrite(RegWrite),
        .WN(WN),
        .clk(clk),
        .MEM_WB_ALU_out(MEM_WB_ALU_out),
        .MEM_WB_MemtoReg(MEM_WB_MemtoReg),
        .MEM_WB_RD(MEM_WB_RD),
        .MEM_WB_RegWrite(MEM_WB_RegWrite),
        .MEM_WB_WN(MEM_WB_WN)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ALU_out = 32'h0;
            MemtoReg = 1'b0;
            RD = 32'h0;
            RegWrite = 1'b0;
            WN = 5'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: ALU operation write-back");
            reset_dut();
            ALU_out = 32'hA5A5A5A5;
            RD = 32'h0;
            WN = 5'd10;
            MemtoReg = 1'b0;
            RegWrite = 1'b1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hA5A5A5A5, 1'b0, 32'h0, 1'b1, 5'd10);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Memory load operation write-back");
            reset_dut();
            ALU_out = 32'h11223344;
            RD = 32'hCAFEBABE;
            WN = 5'd31;
            MemtoReg = 1'b1;
            RegWrite = 1'b1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h11223344, 1'b1, 32'hCAFEBABE, 1'b1, 5'd31);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: No register write (RegWrite = 0)");
            reset_dut();
            ALU_out = 32'hFFFFFFFF;
            RD = 32'hEEEEEEEE;
            WN = 5'd0;
            MemtoReg = 1'b0;
            RegWrite = 1'b0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b0, 32'hEEEEEEEE, 1'b0, 5'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Back-to-back pipeline updates");
            reset_dut();


            ALU_out = 32'h1; RD = 32'h2; WN = 5'h1; MemtoReg = 0; RegWrite = 1;
            @(posedge clk);
            #1;


            ALU_out = 32'h3; RD = 32'h4; WN = 5'h2; MemtoReg = 1; RegWrite = 0;


            #1;
            #1;

            check_outputs(32'h1, 1'b0, 32'h2, 1'b1, 5'h1);


            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h3, 1'b1, 32'h4, 1'b0, 5'h2);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: All bits toggling test");
            reset_dut();
            ALU_out = 32'hAAAAAAAA;
            RD = 32'h55555555;
            WN = 5'h1F;
            MemtoReg = 1'b1;
            RegWrite = 1'b1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hAAAAAAAA, 1'b1, 32'h55555555, 1'b1, 5'h1F);
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
        input [31:0] expected_MEM_WB_ALU_out;
        input expected_MEM_WB_MemtoReg;
        input [31:0] expected_MEM_WB_RD;
        input expected_MEM_WB_RegWrite;
        input [4:0] expected_MEM_WB_WN;
        begin
            if (expected_MEM_WB_ALU_out === (expected_MEM_WB_ALU_out ^ MEM_WB_ALU_out ^ expected_MEM_WB_ALU_out) &&
                expected_MEM_WB_MemtoReg === (expected_MEM_WB_MemtoReg ^ MEM_WB_MemtoReg ^ expected_MEM_WB_MemtoReg) &&
                expected_MEM_WB_RD === (expected_MEM_WB_RD ^ MEM_WB_RD ^ expected_MEM_WB_RD) &&
                expected_MEM_WB_RegWrite === (expected_MEM_WB_RegWrite ^ MEM_WB_RegWrite ^ expected_MEM_WB_RegWrite) &&
                expected_MEM_WB_WN === (expected_MEM_WB_WN ^ MEM_WB_WN ^ expected_MEM_WB_WN)) begin
                $display("PASS");
                $display("  Outputs: MEM_WB_ALU_out=%h, MEM_WB_MemtoReg=%b, MEM_WB_RD=%h, MEM_WB_RegWrite=%b, MEM_WB_WN=%h",
                         MEM_WB_ALU_out, MEM_WB_MemtoReg, MEM_WB_RD, MEM_WB_RegWrite, MEM_WB_WN);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MEM_WB_ALU_out=%h, MEM_WB_MemtoReg=%b, MEM_WB_RD=%h, MEM_WB_RegWrite=%b, MEM_WB_WN=%h",
                         expected_MEM_WB_ALU_out, expected_MEM_WB_MemtoReg, expected_MEM_WB_RD, expected_MEM_WB_RegWrite, expected_MEM_WB_WN);
                $display("  Got:      MEM_WB_ALU_out=%h, MEM_WB_MemtoReg=%b, MEM_WB_RD=%h, MEM_WB_RegWrite=%b, MEM_WB_WN=%h",
                         MEM_WB_ALU_out, MEM_WB_MemtoReg, MEM_WB_RD, MEM_WB_RegWrite, MEM_WB_WN);
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
        $dumpvars(0,ALU_out, MemtoReg, RD, RegWrite, WN, clk, MEM_WB_ALU_out, MEM_WB_MemtoReg, MEM_WB_RD, MEM_WB_RegWrite, MEM_WB_WN);
    end

endmodule
