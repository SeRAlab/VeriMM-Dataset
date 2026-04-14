`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] funct;
    reg [5:0] op;
    wire [1:0] alu_ctrl;
    wire alu_src;
    wire branch;
    wire jump;
    wire mem_to_reg;
    wire mem_write;
    wire reg_dst;
    wire reg_write;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .funct(funct),
        .op(op),
        .alu_ctrl(alu_ctrl),
        .alu_src(alu_src),
        .branch(branch),
        .jump(jump),
        .mem_to_reg(mem_to_reg),
        .mem_write(mem_write),
        .reg_dst(reg_dst),
        .reg_write(reg_write)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: R-type Instruction (op=000000)", test_num);
            op = 6'b000000; funct = 6'b100000;

            #1;


            check_outputs(2'b10, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Load Word (lw, op=100011)", test_num);
            op = 6'b100011; funct = 6'b000000;

            #1;


            check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Store Word (sw, op=101011)", test_num);
            op = 6'b101011; funct = 6'b000000;

            #1;


            check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Branch Equal (beq, op=000100)", test_num);
            op = 6'b000100; funct = 6'b000000;

            #1;


            check_outputs(2'b01, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Jump (j, op=000010)", test_num);
            op = 6'b000010; funct = 6'b000000;

            #1;


            check_outputs(2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Add Immediate (addi, op=001000)", test_num);
            op = 6'b001000; funct = 6'b000000;

            #1;


            check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
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
        input [1:0] expected_alu_ctrl;
        input expected_alu_src;
        input expected_branch;
        input expected_jump;
        input expected_mem_to_reg;
        input expected_mem_write;
        input expected_reg_dst;
        input expected_reg_write;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alu_ctrl === (expected_alu_ctrl ^ alu_ctrl ^ expected_alu_ctrl) &&
                expected_alu_src === (expected_alu_src ^ alu_src ^ expected_alu_src) &&
                expected_branch === (expected_branch ^ branch ^ expected_branch) &&
                expected_jump === (expected_jump ^ jump ^ expected_jump) &&
                expected_mem_to_reg === (expected_mem_to_reg ^ mem_to_reg ^ expected_mem_to_reg) &&
                expected_mem_write === (expected_mem_write ^ mem_write ^ expected_mem_write) &&
                expected_reg_dst === (expected_reg_dst ^ reg_dst ^ expected_reg_dst) &&
                expected_reg_write === (expected_reg_write ^ reg_write ^ expected_reg_write)) begin
                $display("PASS");
                $display("  Outputs: alu_ctrl=%h, alu_src=%b, branch=%b, jump=%b, mem_to_reg=%b, mem_write=%b, reg_dst=%b, reg_write=%b",
                         alu_ctrl, alu_src, branch, jump, mem_to_reg, mem_write, reg_dst, reg_write);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_ctrl=%h, alu_src=%b, branch=%b, jump=%b, mem_to_reg=%b, mem_write=%b, reg_dst=%b, reg_write=%b",
                         expected_alu_ctrl, expected_alu_src, expected_branch, expected_jump, expected_mem_to_reg, expected_mem_write, expected_reg_dst, expected_reg_write);
                $display("  Got:      alu_ctrl=%h, alu_src=%b, branch=%b, jump=%b, mem_to_reg=%b, mem_write=%b, reg_dst=%b, reg_write=%b",
                         alu_ctrl, alu_src, branch, jump, mem_to_reg, mem_write, reg_dst, reg_write);
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

endmodule
