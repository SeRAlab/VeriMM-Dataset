`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] branch_tgt;
    reg [2:0] insn_11_9;
    reg is_branch;
    reg is_control_insn;
    reg [2:0] nzp;
    reg [15:0] pc_plus_one;
    wire branch_taken;
    wire [15:0] next_pc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .branch_tgt(branch_tgt),
        .insn_11_9(insn_11_9),
        .is_branch(is_branch),
        .is_control_insn(is_control_insn),
        .nzp(nzp),
        .pc_plus_one(pc_plus_one),
        .branch_taken(branch_taken),
        .next_pc(next_pc)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Not a control instruction", test_num);
            branch_tgt = 16'hAAAA;
            pc_plus_one = 16'h1001;
            insn_11_9 = 3'b111;
            nzp = 3'b111;
            is_branch = 0;
            is_control_insn = 0;
            #1;

            check_outputs(1'b0, 16'h1001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Unconditional control instruction (is_branch=0, is_control_insn=1)", test_num);
            branch_tgt = 16'hBBBB;
            pc_plus_one = 16'h2001;
            insn_11_9 = 3'b000;
            nzp = 3'b001;
            is_branch = 0;
            is_control_insn = 1;
            #1;

            check_outputs(1'b1, 16'hBBBB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Branch instruction - Condition Met (N match)", test_num);
            branch_tgt = 16'hCCCC;
            pc_plus_one = 16'h3001;
            insn_11_9 = 3'b100;
            nzp = 3'b100;
            is_branch = 1;
            is_control_insn = 1;
            #1;

            check_outputs(1'b1, 16'hCCCC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Branch instruction - Condition Met (Z match)", test_num);
            branch_tgt = 16'h4444;
            pc_plus_one = 16'h4001;
            insn_11_9 = 3'b010;
            nzp = 3'b010;
            is_branch = 1;
            is_control_insn = 1;
            #1;

            check_outputs(1'b1, 16'h4444);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Branch instruction - Condition Met (P match)", test_num);
            branch_tgt = 16'h5555;
            pc_plus_one = 16'h5001;
            insn_11_9 = 3'b001;
            nzp = 3'b001;
            is_branch = 1;
            is_control_insn = 1;
            #1;

            check_outputs(1'b1, 16'h5555);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Branch instruction - Condition Met (Multiple conditions, one flag)", test_num);
            branch_tgt = 16'h6666;
            pc_plus_one = 16'h6001;
            insn_11_9 = 3'b110;
            nzp = 3'b010;
            is_branch = 1;
            is_control_insn = 1;
            #1;

            check_outputs(1'b1, 16'h6666);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Branch instruction - Condition NOT Met", test_num);
            branch_tgt = 16'h7777;
            pc_plus_one = 16'h7001;
            insn_11_9 = 3'b100;
            nzp = 3'b001;
            is_branch = 1;
            is_control_insn = 1;
            #1;

            check_outputs(1'b0, 16'h7001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Branch instruction - BRnzp (Always take)", test_num);
            branch_tgt = 16'h8888;
            pc_plus_one = 16'h8001;
            insn_11_9 = 3'b111;
            nzp = 3'b010;
            is_branch = 1;
            is_control_insn = 1;
            #1;

            check_outputs(1'b1, 16'h8888);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Branch instruction - Condition NOT Met (No conditions set in instruction)", test_num);
            branch_tgt = 16'h9999;
            pc_plus_one = 16'h9001;
            insn_11_9 = 3'b000;
            nzp = 3'b111;
            is_branch = 1;
            is_control_insn = 1;
            #1;

            check_outputs(1'b0, 16'h9001);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Control instruction but not branch, ignores NZP match", test_num);
            branch_tgt = 16'hDEAD;
            pc_plus_one = 16'hBEEF;
            insn_11_9 = 3'b000;
            nzp = 3'b111;
            is_branch = 0;
            is_control_insn = 1;
            #1;

            check_outputs(1'b1, 16'hDEAD);
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
        input expected_branch_taken;
        input [15:0] expected_next_pc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_branch_taken === (expected_branch_taken ^ branch_taken ^ expected_branch_taken) &&
                expected_next_pc === (expected_next_pc ^ next_pc ^ expected_next_pc)) begin
                $display("PASS");
                $display("  Outputs: branch_taken=%b, next_pc=%h",
                         branch_taken, next_pc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: branch_taken=%b, next_pc=%h",
                         expected_branch_taken, expected_next_pc);
                $display("  Got:      branch_taken=%b, next_pc=%h",
                         branch_taken, next_pc);
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
