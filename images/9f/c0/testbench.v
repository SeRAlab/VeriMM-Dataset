`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instr;
    reg ir_we;
    wire [31:0] hi16;
    wire [5:0] opcode;
    wire [4:0] reg1;
    wire [4:0] reg2;
    wire [4:0] reg3;
    wire [31:0] sx16;
    wire [31:0] sx16s2;
    wire [31:0] sx26s2;
    wire [31:0] zx16;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .instr(instr),
        .ir_we(ir_we),
        .hi16(hi16),
        .opcode(opcode),
        .reg1(reg1),
        .reg2(reg2),
        .reg3(reg3),
        .sx16(sx16),
        .sx16s2(sx16s2),
        .sx26s2(sx26s2),
        .zx16(zx16)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ir_we = 1;
            instr = 32'h0;
            @(posedge clk);
            #1;
            ir_we = 0;
            instr = 32'h0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            instr = 32'h8C010004;
            ir_we = 1;
            @(posedge clk); #1;
            ir_we = 0;

            #1;


            check_outputs(32'h00040000, 6'h23, 5'h00, 5'h01, 5'h00, 32'h00000004, 32'h00000010, 32'h00040010, 32'h00000004);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            instr = 32'hAD08FFFC;
            ir_we = 1;
            @(posedge clk); #1;
            ir_we = 0;

            #1;


            check_outputs(32'hFFFC0000, 6'h2B, 5'h08, 5'h08, 5'h1F, 32'hFFFFFFFC, 32'hFFFFFFF0, 32'h0423FFF0, 32'h0000FFFC);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            instr = 32'hFFFFFFFF;
            ir_we = 1;
            @(posedge clk); #1;

            instr = 32'h00000000;
            ir_we = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(32'hFFFF0000, 6'h3F, 5'h1F, 5'h1F, 5'h1F, 32'hFFFFFFFF, 32'hFFFFFFFC, 32'hFFFFFFFC, 32'h0000FFFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            instr = 32'h00000000;
            ir_we = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            instr = 32'hFBE00001;


            ir_we = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(32'h00010000, 6'h3E, 5'h1F, 5'h10, 5'h00, 32'h00000001, 32'h00000004, 32'hFF800004, 32'h00000001);
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
        input [31:0] expected_hi16;
        input [5:0] expected_opcode;
        input [4:0] expected_reg1;
        input [4:0] expected_reg2;
        input [4:0] expected_reg3;
        input [31:0] expected_sx16;
        input [31:0] expected_sx16s2;
        input [31:0] expected_sx26s2;
        input [31:0] expected_zx16;
        begin
            if (expected_hi16 === (expected_hi16 ^ hi16 ^ expected_hi16) &&
                expected_opcode === (expected_opcode ^ opcode ^ expected_opcode) &&
                expected_reg1 === (expected_reg1 ^ reg1 ^ expected_reg1) &&
                expected_reg2 === (expected_reg2 ^ reg2 ^ expected_reg2) &&
                expected_reg3 === (expected_reg3 ^ reg3 ^ expected_reg3) &&
                expected_sx16 === (expected_sx16 ^ sx16 ^ expected_sx16) &&
                expected_sx16s2 === (expected_sx16s2 ^ sx16s2 ^ expected_sx16s2) &&
                expected_sx26s2 === (expected_sx26s2 ^ sx26s2 ^ expected_sx26s2) &&
                expected_zx16 === (expected_zx16 ^ zx16 ^ expected_zx16)) begin
                $display("PASS");
                $display("  Outputs: hi16=%h, opcode=%h, reg1=%h, reg2=%h, reg3=%h, sx16=%h, sx16s2=%h, sx26s2=%h, zx16=%h",
                         hi16, opcode, reg1, reg2, reg3, sx16, sx16s2, sx26s2, zx16);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hi16=%h, opcode=%h, reg1=%h, reg2=%h, reg3=%h, sx16=%h, sx16s2=%h, sx26s2=%h, zx16=%h",
                         expected_hi16, expected_opcode, expected_reg1, expected_reg2, expected_reg3, expected_sx16, expected_sx16s2, expected_sx26s2, expected_zx16);
                $display("  Got:      hi16=%h, opcode=%h, reg1=%h, reg2=%h, reg3=%h, sx16=%h, sx16s2=%h, sx26s2=%h, zx16=%h",
                         hi16, opcode, reg1, reg2, reg3, sx16, sx16s2, sx26s2, zx16);
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
        $dumpvars(0,clk, instr, ir_we, hi16, opcode, reg1, reg2, reg3, sx16, sx16s2, sx26s2, zx16);
    end

endmodule
