`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] aluop;
    reg [31:0] instruction;
    wire [3:0] op;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aluop(aluop),
        .instruction(instruction),
        .op(op)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: aluop = 000 (Load/Store - Expected ADD)", test_num);
        aluop = 3'b000;
        instruction = 32'h0;
        #5;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: aluop = 001 (Branch - Expected SUB)", test_num);
        aluop = 3'b001;
        instruction = 32'hFFFFFFFF;
        #5;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: aluop = 010, R-type ADD (funct3=0, bit30=0)", test_num);
        aluop = 3'b010;
        instruction = 32'h00000000;
        instruction[14:12] = 3'b000;
        instruction[30]    = 1'b0;
        #5;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: aluop = 010, R-type SUB (funct3=0, bit30=1)", test_num);
        aluop = 3'b010;
        instruction = 32'h00000000;
        instruction[14:12] = 3'b000;
        instruction[30]    = 1'b1;
        #5;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: aluop = 010, R-type AND (funct3=111, bit30=0)", test_num);
        aluop = 3'b010;
        instruction = 32'h00000000;
        instruction[14:12] = 3'b111;
        instruction[30]    = 1'b0;
        #5;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: aluop = 010, R-type OR (funct3=110, bit30=0)", test_num);
        aluop = 3'b010;
        instruction = 32'h00000000;
        instruction[14:12] = 3'b110;
        instruction[30]    = 1'b0;
        #5;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: aluop = 010, R-type XOR (funct3=100, bit30=0)", test_num);
        aluop = 3'b010;
        instruction = 32'h00000000;
        instruction[14:12] = 3'b100;
        instruction[30]    = 1'b0;
        #5;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: aluop = 010, R-type SLT (funct3=010, bit30=0)", test_num);
        aluop = 3'b010;
        instruction = 32'h00000000;
        instruction[14:12] = 3'b010;
        instruction[30]    = 1'b0;
        #5;
        #1;

        check_outputs(4'b0011);
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
        input [3:0] expected_op;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_op === (expected_op ^ op ^ expected_op)) begin
                $display("PASS");
                $display("  Outputs: op=%h",
                         op);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: op=%h",
                         expected_op);
                $display("  Got:      op=%h",
                         op);
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
