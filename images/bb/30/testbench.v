`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ALUResultE;
    reg [31:0] ExtImm;
    reg InstWrite;
    reg PCSrc;
    reg PCWrite;
    reg RegWriteE;
    reg [3:0] WriteAddrE;
    reg clk;
    reg [31:0] inst;
    reg nop;
    reg [31:0] pc;
    reg reset;
    wire [31:0] instD;
    wire [31:0] pc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUResultE(ALUResultE),
        .ExtImm(ExtImm),
        .InstWrite(InstWrite),
        .PCSrc(PCSrc),
        .PCWrite(PCWrite),
        .RegWriteE(RegWriteE),
        .WriteAddrE(WriteAddrE),
        .clk(clk),
        .inst(inst),
        .nop(nop),
        .pc(pc),
        .reset(reset),
        .instD(instD),
        .pc_out(pc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            PCWrite = 0;
            PCSrc = 0;
            pc = 0;
            inst = 0;
            InstWrite = 0;
            nop = 0;
            ExtImm = 0;
            ALUResultE = 0;
            RegWriteE = 0;
            WriteAddrE = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Reset Logic");
            reset_dut();

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: PC Increment (PCSrc=0)");
            reset_dut();
            pc = 32'h00001000;
            PCWrite = 1;
            PCSrc = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0, 32'h00001004);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: PC Branch (PCSrc=1)");
            reset_dut();
            ExtImm = 32'h0000ABCD;
            PCWrite = 1;
            PCSrc = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0, 32'h0000ABCD);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Instruction Write");
            reset_dut();
            inst = 32'h12345678;
            InstWrite = 1;
            nop = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h12345678, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: NOP Signal Triggered");
            reset_dut();
            inst = 32'hAABBCCDD;
            InstWrite = 1;
            nop = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: ALU Result PC Update");
            reset_dut();
            ALUResultE = 32'hFFFF0000;
            PCWrite = 1;




            PCSrc = 1;


            ExtImm = 32'hFFFF0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0, 32'hFFFF0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Stall (PCWrite=0, InstWrite=0)");
            reset_dut();

            pc = 32'h00001000;
            inst = 32'hCAFEBABE;
            PCWrite = 1;
            InstWrite = 1;
            @(posedge clk);
            #2;

            PCWrite = 0;
            InstWrite = 0;
            pc = 32'h00002000;
            inst = 32'hDEADBEEF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hCAFEBABE, 32'h00001004);
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
        testcase007();
        
        
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
        input [31:0] expected_instD;
        input [31:0] expected_pc_out;
        begin
            if (expected_instD === (expected_instD ^ instD ^ expected_instD) &&
                expected_pc_out === (expected_pc_out ^ pc_out ^ expected_pc_out)) begin
                $display("PASS");
                $display("  Outputs: instD=%h, pc_out=%h",
                         instD, pc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instD=%h, pc_out=%h",
                         expected_instD, expected_pc_out);
                $display("  Got:      instD=%h, pc_out=%h",
                         instD, pc_out);
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
        $dumpvars(0,ALUResultE, ExtImm, InstWrite, PCSrc, PCWrite, RegWriteE, WriteAddrE, clk, inst, nop, pc, reset, instD, pc_out);
    end

endmodule
