`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg en_mem;
    reg imm;
    reg mem_wait;
    reg rst;
    reg should_branch;
    wire [8:0] control_o;
    wire [1:0] pc_op;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .en_mem(en_mem),
        .imm(imm),
        .mem_wait(mem_wait),
        .rst(rst),
        .should_branch(should_branch),
        .control_o(control_o),
        .pc_op(pc_op)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        en = 0;
        en_mem = 0;
        imm = 0;
        mem_wait = 0;
        should_branch = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Initial Reset Status", test_num);
        reset_dut();

        #1;


        check_outputs(9'h000, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Enabled, ADD mode (imm=0)", test_num);
        reset_dut();
        en = 1;
        imm = 0;
        en_mem = 0;
        should_branch = 0;
        @(posedge clk); #1;
        #1;

        check_outputs(9'b000_000_000, OP_ADD);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Enabled, AND mode (imm=1)", test_num);
        reset_dut();
        en = 1;
        imm = 1;
        en_mem = 0;
        should_branch = 0;
        @(posedge clk); #1;
        #1;

        check_outputs(9'b000_000_100, OP_AND);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Memory Enable and Branching Status", test_num);
        reset_dut();
        en = 1;
        imm = 0;
        en_mem = 1;
        should_branch = 1;
        @(posedge clk); #1;
        #1;

        check_outputs(9'b000_000_011, OP_ADD);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Memory Wait Interaction", test_num);
        reset_dut();
        en = 1;
        imm = 1;
        en_mem = 1;
        should_branch = 0;
        mem_wait = 1;
        @(posedge clk); #1;

        #1;


        check_outputs(9'b000_000_101, OP_AND);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Disabled State", test_num);
        reset_dut();
        en = 0;
        imm = 1;
        en_mem = 1;
        should_branch = 1;
        @(posedge clk); #1;

        #1;


        check_outputs(9'h000, 2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: All Status Signals Active", test_num);
        reset_dut();
        en = 1;
        imm = 1;
        en_mem = 1;
        should_branch = 1;
        mem_wait = 1;
        @(posedge clk); #1;
        #1;

        check_outputs(9'b000_000_111, OP_AND);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: PC Op Transition", test_num);
        reset_dut();
        en = 1;
        imm = 0;
        @(posedge clk); #1;
        if (pc_op !== OP_ADD) $display("Failed ADD transition");

        imm = 1;
        @(posedge clk); #1;
        #1;

        check_outputs(9'b000_000_100, OP_AND);
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
        input [8:0] expected_control_o;
        input [1:0] expected_pc_op;
        begin
            if (expected_control_o === (expected_control_o ^ control_o ^ expected_control_o) &&
                expected_pc_op === (expected_pc_op ^ pc_op ^ expected_pc_op)) begin
                $display("PASS");
                $display("  Outputs: control_o=%h, pc_op=%h",
                         control_o, pc_op);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_o=%h, pc_op=%h",
                         expected_control_o, expected_pc_op);
                $display("  Got:      control_o=%h, pc_op=%h",
                         control_o, pc_op);
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
        $dumpvars(0,clk, en, en_mem, imm, mem_wait, rst, should_branch, control_o, pc_op);
    end

endmodule
