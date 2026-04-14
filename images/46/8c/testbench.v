`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ALUOp;
    reg [4:0] shamt;
    reg [31:0] src1;
    reg [31:0] src2;
    wire [31:0] ALU_result;
    wire Zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOp(ALUOp),
        .shamt(shamt),
        .src1(src1),
        .src2(src2),
        .ALU_result(ALU_result),
        .Zero(Zero)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Basic Addition", test_num);
            ALUOp = OP_ADD;
            src1  = 32'd100;
            src2  = 32'd250;
            shamt = 5'd0;
            #1;

            check_outputs(32'd350, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Addition with Negative Result", test_num);
            ALUOp = OP_ADD;
            src1  = 32'hFFFFFFFF;
            src2  = 32'h00000005;
            shamt = 5'd0;
            #1;

            check_outputs(32'd4, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Subtraction", test_num);
            ALUOp = OP_SUB;
            src1  = 32'd500;
            src2  = 32'd200;
            shamt = 5'd0;
            #1;

            check_outputs(32'd300, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Subtraction Resulting in Zero", test_num);
            ALUOp = OP_SUB;
            src1  = 32'hABCDE;
            src2  = 32'hABCDE;
            shamt = 5'd0;
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Bitwise AND", test_num);
            ALUOp = OP_AND;
            src1  = 32'hF0F0F0F0;
            src2  = 32'hAAAA5555;
            shamt = 5'd0;
            #1;

            check_outputs(32'hA0A05050, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Bitwise OR", test_num);
            ALUOp = OP_OR;
            src1  = 32'hF0F0F0F0;
            src2  = 32'h0F0F0F0F;
            shamt = 5'd0;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Bitwise XOR (Self)", test_num);
            ALUOp = OP_XOR;
            src1  = 32'h12345678;
            src2  = 32'h12345678;
            shamt = 5'd0;
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Bitwise NOR", test_num);
            ALUOp = OP_NOR;
            src1  = 32'h00000000;
            src2  = 32'h00000000;
            shamt = 5'd0;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: SLT (True case: -5 < 10)", test_num);
            ALUOp = OP_SLT;
            src1  = 32'hFFFFFFFB;
            src2  = 32'h0000000A;
            shamt = 5'd0;
            #1;

            check_outputs(32'd1, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: SLT (False case: 10 < -5)", test_num);
            ALUOp = OP_SLT;
            src1  = 32'h0000000A;
            src2  = 32'hFFFFFFFB;
            shamt = 5'd0;
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test %0d: SLL (Shift Left Logical)", test_num);
            ALUOp = OP_SLL;
            src1  = 32'h0;
            src2  = 32'h00000001;
            shamt = 5'd4;
            #1;

            check_outputs(32'h00000010, 1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test %0d: SRL (Shift Right Logical)", test_num);
            ALUOp = OP_SRL;
            src1  = 32'h0;
            src2  = 32'h80000000;
            shamt = 5'd2;
            #1;

            check_outputs(32'h20000000, 1'b0);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            $display("Test %0d: SRA (Shift Right Arithmetic)", test_num);
            ALUOp = OP_SRA;
            src1  = 32'h0;
            src2  = 32'h80000000;
            shamt = 5'd2;
            #1;

            check_outputs(32'hE0000000, 1'b0);
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
        testcase011();
        testcase012();
        testcase013();
        
        
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
        input [31:0] expected_ALU_result;
        input expected_Zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_result === (expected_ALU_result ^ ALU_result ^ expected_ALU_result) &&
                expected_Zero === (expected_Zero ^ Zero ^ expected_Zero)) begin
                $display("PASS");
                $display("  Outputs: ALU_result=%h, Zero=%b",
                         ALU_result, Zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_result=%h, Zero=%b",
                         expected_ALU_result, expected_Zero);
                $display("  Got:      ALU_result=%h, Zero=%b",
                         ALU_result, Zero);
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
