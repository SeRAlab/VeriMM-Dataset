`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] instruction;
    wire BC;
    wire JB;
    wire PL;
    wire [2:0] dest_reg;
    wire [6:0] opcode;
    wire [2:0] src_reg_a;
    wire [2:0] src_reg_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .instruction(instruction),
        .BC(BC),
        .JB(JB),
        .PL(PL),
        .dest_reg(dest_reg),
        .opcode(opcode),
        .src_reg_a(src_reg_a),
        .src_reg_b(src_reg_b)
    );
    task testcase001;

        begin
            test_num = 1;


            instruction = 16'h0000;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 3'b000, 7'b0000000, 3'b000, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;



            instruction = 16'hFFFF;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 3'b111, 7'b1111111, 3'b111, 3'b111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;




            instruction = 16'b1000000101010011;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 3'b101, 7'b1000000, 3'b010, 3'b011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;




            instruction = 16'b0100000111110101;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 3'b111, 7'b0100000, 3'b110, 3'b101);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;




            instruction = 16'b0010000011001100;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0, 3'b011, 7'b0010000, 3'b001, 3'b100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;




            instruction = 16'b1110101010101011;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 3'b010, 7'b1110101, 3'b101, 3'b011);
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
        input expected_BC;
        input expected_JB;
        input expected_PL;
        input [2:0] expected_dest_reg;
        input [6:0] expected_opcode;
        input [2:0] expected_src_reg_a;
        input [2:0] expected_src_reg_b;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_BC === (expected_BC ^ BC ^ expected_BC) &&
                expected_JB === (expected_JB ^ JB ^ expected_JB) &&
                expected_PL === (expected_PL ^ PL ^ expected_PL) &&
                expected_dest_reg === (expected_dest_reg ^ dest_reg ^ expected_dest_reg) &&
                expected_opcode === (expected_opcode ^ opcode ^ expected_opcode) &&
                expected_src_reg_a === (expected_src_reg_a ^ src_reg_a ^ expected_src_reg_a) &&
                expected_src_reg_b === (expected_src_reg_b ^ src_reg_b ^ expected_src_reg_b)) begin
                $display("PASS");
                $display("  Outputs: BC=%b, JB=%b, PL=%b, dest_reg=%h, opcode=%h, src_reg_a=%h, src_reg_b=%h",
                         BC, JB, PL, dest_reg, opcode, src_reg_a, src_reg_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BC=%b, JB=%b, PL=%b, dest_reg=%h, opcode=%h, src_reg_a=%h, src_reg_b=%h",
                         expected_BC, expected_JB, expected_PL, expected_dest_reg, expected_opcode, expected_src_reg_a, expected_src_reg_b);
                $display("  Got:      BC=%b, JB=%b, PL=%b, dest_reg=%h, opcode=%h, src_reg_a=%h, src_reg_b=%h",
                         BC, JB, PL, dest_reg, opcode, src_reg_a, src_reg_b);
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
