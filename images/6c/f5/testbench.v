`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] inst_op;
    reg reset;
    reg z;
    wire B_write;
    wire ir_write;
    wire mem_src;
    wire mem_write;
    wire pc_src;
    wire pc_write;
    wire pop;
    wire push;
    wire stack_src;
    wire tos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .inst_op(inst_op),
        .reset(reset),
        .z(z),
        .B_write(B_write),
        .ir_write(ir_write),
        .mem_src(mem_src),
        .mem_write(mem_write),
        .pc_src(pc_src),
        .pc_write(pc_write),
        .pop(pop),
        .push(push),
        .stack_src(stack_src),
        .tos(tos)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            inst_op = 3'b000;
            z = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            inst_op = 3'b000;
            z = 0;
            repeat(4) @(posedge clk);
            $display("Testcase %03d: Opcode 000", test_num);

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            inst_op = 3'b001;
            z = 0;
            repeat(4) @(posedge clk);
            $display("Testcase %03d: Opcode 001, Z=0", test_num);
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            inst_op = 3'b001;
            z = 1;
            repeat(4) @(posedge clk);
            $display("Testcase %03d: Opcode 001, Z=1", test_num);

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            inst_op = 3'b010;
            repeat(4) @(posedge clk);
            $display("Testcase %03d: Opcode 010 (Push)", test_num);
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            inst_op = 3'b011;
            repeat(4) @(posedge clk);
            $display("Testcase %03d: Opcode 011 (Pop)", test_num);
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            inst_op = 3'b100;
            repeat(4) @(posedge clk);
            $display("Testcase %03d: Opcode 100 (Store)", test_num);
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            inst_op = 3'b101;
            repeat(4) @(posedge clk);
            $display("Testcase %03d: Opcode 101 (ALU)", test_num);
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            inst_op = 3'b110;
            repeat(4) @(posedge clk);
            $display("Testcase %03d: Opcode 110 (Jump)", test_num);
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            inst_op = 3'b111;
            repeat(4) @(posedge clk);
            $display("Testcase %03d: Opcode 111", test_num);
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            inst_op = 3'b101;
            @(posedge clk);
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            $display("Testcase %03d: Mid-op Reset", test_num);
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
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
        input expected_B_write;
        input expected_ir_write;
        input expected_mem_src;
        input expected_mem_write;
        input expected_pc_src;
        input expected_pc_write;
        input expected_pop;
        input expected_push;
        input expected_stack_src;
        input expected_tos;
        begin
            if (expected_B_write === (expected_B_write ^ B_write ^ expected_B_write) &&
                expected_ir_write === (expected_ir_write ^ ir_write ^ expected_ir_write) &&
                expected_mem_src === (expected_mem_src ^ mem_src ^ expected_mem_src) &&
                expected_mem_write === (expected_mem_write ^ mem_write ^ expected_mem_write) &&
                expected_pc_src === (expected_pc_src ^ pc_src ^ expected_pc_src) &&
                expected_pc_write === (expected_pc_write ^ pc_write ^ expected_pc_write) &&
                expected_pop === (expected_pop ^ pop ^ expected_pop) &&
                expected_push === (expected_push ^ push ^ expected_push) &&
                expected_stack_src === (expected_stack_src ^ stack_src ^ expected_stack_src) &&
                expected_tos === (expected_tos ^ tos ^ expected_tos)) begin
                $display("PASS");
                $display("  Outputs: B_write=%b, ir_write=%b, mem_src=%b, mem_write=%b, pc_src=%b, pc_write=%b, pop=%b, push=%b, stack_src=%b, tos=%b",
                         B_write, ir_write, mem_src, mem_write, pc_src, pc_write, pop, push, stack_src, tos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B_write=%b, ir_write=%b, mem_src=%b, mem_write=%b, pc_src=%b, pc_write=%b, pop=%b, push=%b, stack_src=%b, tos=%b",
                         expected_B_write, expected_ir_write, expected_mem_src, expected_mem_write, expected_pc_src, expected_pc_write, expected_pop, expected_push, expected_stack_src, expected_tos);
                $display("  Got:      B_write=%b, ir_write=%b, mem_src=%b, mem_write=%b, pc_src=%b, pc_write=%b, pop=%b, push=%b, stack_src=%b, tos=%b",
                         B_write, ir_write, mem_src, mem_write, pc_src, pc_write, pop, push, stack_src, tos);
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
        $dumpvars(0,clk, inst_op, reset, z, B_write, ir_write, mem_src, mem_write, pc_src, pc_write, pop, push, stack_src, tos);
    end

endmodule
