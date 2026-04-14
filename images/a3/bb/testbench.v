`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [5:0] opcode;
    wire [1:0] alu_op;
    wire alu_src;
    wire branch;
    wire ctrl_mem_read;
    wire ctrl_mem_write;
    wire jump;
    wire mem_to_reg;
    wire reg_dst;
    wire reg_write;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .opcode(opcode),
        .alu_op(alu_op),
        .alu_src(alu_src),
        .branch(branch),
        .ctrl_mem_read(ctrl_mem_read),
        .ctrl_mem_write(ctrl_mem_write),
        .jump(jump),
        .mem_to_reg(mem_to_reg),
        .reg_dst(reg_dst),
        .reg_write(reg_write)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            opcode = 6'b111111;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: R-type Instruction (opcode 000000)", test_num);
            opcode = 6'b000000;
            @(posedge clk);
            #2;

            #1;


            check_outputs(2'b10, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Load Word (LW, opcode 100011)", test_num);
            opcode = 6'b100011;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b00, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Store Word (SW, opcode 101011)", test_num);
            opcode = 6'b101011;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Branch on Equal (BEQ, opcode 000100)", test_num);
            opcode = 6'b000100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b01, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Jump (J, opcode 000010)", test_num);
            opcode = 6'b000010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: Add Immediate (ADDI, opcode 001000)", test_num);
            opcode = 6'b001000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
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
        input [1:0] expected_alu_op;
        input expected_alu_src;
        input expected_branch;
        input expected_ctrl_mem_read;
        input expected_ctrl_mem_write;
        input expected_jump;
        input expected_mem_to_reg;
        input expected_reg_dst;
        input expected_reg_write;
        begin
            if (expected_alu_op === (expected_alu_op ^ alu_op ^ expected_alu_op) &&
                expected_alu_src === (expected_alu_src ^ alu_src ^ expected_alu_src) &&
                expected_branch === (expected_branch ^ branch ^ expected_branch) &&
                expected_ctrl_mem_read === (expected_ctrl_mem_read ^ ctrl_mem_read ^ expected_ctrl_mem_read) &&
                expected_ctrl_mem_write === (expected_ctrl_mem_write ^ ctrl_mem_write ^ expected_ctrl_mem_write) &&
                expected_jump === (expected_jump ^ jump ^ expected_jump) &&
                expected_mem_to_reg === (expected_mem_to_reg ^ mem_to_reg ^ expected_mem_to_reg) &&
                expected_reg_dst === (expected_reg_dst ^ reg_dst ^ expected_reg_dst) &&
                expected_reg_write === (expected_reg_write ^ reg_write ^ expected_reg_write)) begin
                $display("PASS");
                $display("  Outputs: alu_op=%h, alu_src=%b, branch=%b, ctrl_mem_read=%b, ctrl_mem_write=%b, jump=%b, mem_to_reg=%b, reg_dst=%b, reg_write=%b",
                         alu_op, alu_src, branch, ctrl_mem_read, ctrl_mem_write, jump, mem_to_reg, reg_dst, reg_write);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_op=%h, alu_src=%b, branch=%b, ctrl_mem_read=%b, ctrl_mem_write=%b, jump=%b, mem_to_reg=%b, reg_dst=%b, reg_write=%b",
                         expected_alu_op, expected_alu_src, expected_branch, expected_ctrl_mem_read, expected_ctrl_mem_write, expected_jump, expected_mem_to_reg, expected_reg_dst, expected_reg_write);
                $display("  Got:      alu_op=%h, alu_src=%b, branch=%b, ctrl_mem_read=%b, ctrl_mem_write=%b, jump=%b, mem_to_reg=%b, reg_dst=%b, reg_write=%b",
                         alu_op, alu_src, branch, ctrl_mem_read, ctrl_mem_write, jump, mem_to_reg, reg_dst, reg_write);
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
        $dumpvars(0,clk, opcode, alu_op, alu_src, branch, ctrl_mem_read, ctrl_mem_write, jump, mem_to_reg, reg_dst, reg_write);
    end

endmodule
