`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] instruction;
    wire [2:0] condition;
    wire halt;
    wire [7:0] immediate_8bit;
    wire [8:0] offset_9bit;
    wire [3:0] opcode;
    wire [3:0] rd;
    wire [3:0] rs;
    wire [3:0] rt;
    wire writem_en;
    wire writer_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .instruction(instruction),
        .condition(condition),
        .halt(halt),
        .immediate_8bit(immediate_8bit),
        .offset_9bit(offset_9bit),
        .opcode(opcode),
        .rd(rd),
        .rs(rs),
        .rt(rt),
        .writem_en(writem_en),
        .writer_en(writer_en)
    );
    task testcase001;

        begin
            test_num = 1;
            instruction = 16'h1234;

            #1;


            check_outputs(3'h1, 1'b0, 8'h34, 9'h034, 4'h1, 4'h4, 4'h2, 4'h3, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            instruction = 16'h7567;

            #1;


            check_outputs(3'h2, 1'b0, 8'h67, 9'h167, 4'h7, 4'h7, 4'h5, 4'h6, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            instruction = 16'h8ABC;

            #1;


            check_outputs(3'h5, 1'b0, 8'hBC, 9'h0BC, 4'h8, 4'hC, 4'hA, 4'hB, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            instruction = 16'hC0FF;

            #1;


            check_outputs(3'h0, 1'b0, 8'hFF, 9'h0FF, 4'hC, 4'hF, 4'h0, 4'hF, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            instruction = 16'hF000;

            #1;


            check_outputs(3'h0, 1'b1, 8'h00, 9'h000, 4'hF, 4'h0, 4'h0, 4'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            instruction = 16'h1F11;

            #1;


            check_outputs(3'h7, 1'b0, 8'h11, 9'h111, 4'h1, 4'h1, 4'hF, 4'h1, 1'b0, 1'b1);
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
        input [2:0] expected_condition;
        input expected_halt;
        input [7:0] expected_immediate_8bit;
        input [8:0] expected_offset_9bit;
        input [3:0] expected_opcode;
        input [3:0] expected_rd;
        input [3:0] expected_rs;
        input [3:0] expected_rt;
        input expected_writem_en;
        input expected_writer_en;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_condition === (expected_condition ^ condition ^ expected_condition) &&
                expected_halt === (expected_halt ^ halt ^ expected_halt) &&
                expected_immediate_8bit === (expected_immediate_8bit ^ immediate_8bit ^ expected_immediate_8bit) &&
                expected_offset_9bit === (expected_offset_9bit ^ offset_9bit ^ expected_offset_9bit) &&
                expected_opcode === (expected_opcode ^ opcode ^ expected_opcode) &&
                expected_rd === (expected_rd ^ rd ^ expected_rd) &&
                expected_rs === (expected_rs ^ rs ^ expected_rs) &&
                expected_rt === (expected_rt ^ rt ^ expected_rt) &&
                expected_writem_en === (expected_writem_en ^ writem_en ^ expected_writem_en) &&
                expected_writer_en === (expected_writer_en ^ writer_en ^ expected_writer_en)) begin
                $display("PASS");
                $display("  Outputs: condition=%h, halt=%b, immediate_8bit=%h, offset_9bit=%h, opcode=%h, rd=%h, rs=%h, rt=%h, writem_en=%b, writer_en=%b",
                         condition, halt, immediate_8bit, offset_9bit, opcode, rd, rs, rt, writem_en, writer_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: condition=%h, halt=%b, immediate_8bit=%h, offset_9bit=%h, opcode=%h, rd=%h, rs=%h, rt=%h, writem_en=%b, writer_en=%b",
                         expected_condition, expected_halt, expected_immediate_8bit, expected_offset_9bit, expected_opcode, expected_rd, expected_rs, expected_rt, expected_writem_en, expected_writer_en);
                $display("  Got:      condition=%h, halt=%b, immediate_8bit=%h, offset_9bit=%h, opcode=%h, rd=%h, rs=%h, rt=%h, writem_en=%b, writer_en=%b",
                         condition, halt, immediate_8bit, offset_9bit, opcode, rd, rs, rt, writem_en, writer_en);
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
