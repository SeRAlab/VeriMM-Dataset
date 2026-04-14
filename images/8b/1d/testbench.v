`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ALUSrcA;
    reg [31:0] ALUSrcB;
    reg [2:0] ALUop;
    wire [31:0] result;
    wire sign;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ALUop(ALUop),
        .result(result),
        .sign(sign),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (100 + 200)", test_num);
            ALUSrcA = 32'd100;
            ALUSrcB = 32'd200;
            ALUop   = 3'b000;

            #1;


            check_outputs(32'h0000012C, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction Zero (50 - 50)", test_num);
            ALUSrcA = 32'd50;
            ALUSrcB = 32'd50;
            ALUop   = 3'b001;

            #1;


            check_outputs(32'h00000000, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction Negative (50 - 100)", test_num);
            ALUSrcA = 32'd50;
            ALUSrcB = 32'd100;
            ALUop   = 3'b001;

            #1;


            check_outputs(32'hFFFFFFCE, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise AND", test_num);
            ALUSrcA = 32'hF0F0F0F0;
            ALUSrcB = 32'h0F0F0F0F;
            ALUop   = 3'b010;

            #1;


            check_outputs(32'h00000000, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise OR", test_num);
            ALUSrcA = 32'hAAAA0000;
            ALUSrcB = 32'h00005555;
            ALUop   = 3'b011;

            #1;


            check_outputs(32'hAAAA5555, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise XOR", test_num);
            ALUSrcA = 32'hFFFFFFFF;
            ALUSrcB = 32'hF0F0F0F0;
            ALUop   = 3'b100;

            #1;


            check_outputs(32'h0F0F0F0F, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Signed Comparison (SLT) -1 < 1", test_num);
            ALUSrcA = 32'hFFFFFFFF;
            ALUSrcB = 32'h00000001;
            ALUop   = 3'b101;

            #1;


            check_outputs(32'h00000001, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Signed Comparison (SLT) 1 < -1", test_num);
            ALUSrcA = 32'h00000001;
            ALUSrcB = 32'hFFFFFFFF;
            ALUop   = 3'b101;

            #1;


            check_outputs(32'h00000000, 1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Unsigned Comparison (SLTU) 1 < MAX", test_num);
            ALUSrcA = 32'h00000001;
            ALUSrcB = 32'hFFFFFFFF;
            ALUop   = 3'b110;

            #1;


            check_outputs(32'h00000001, 1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Unsigned Comparison (SLTU) MAX < 1", test_num);
            ALUSrcA = 32'hFFFFFFFF;
            ALUSrcB = 32'h00000001;
            ALUop   = 3'b110;

            #1;


            check_outputs(32'h00000000, 1'b0, 1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise Shift (SLL) 1 << 4", test_num);
            ALUSrcA = 32'h00000001;
            ALUSrcB = 32'h00000004;
            ALUop   = 3'b111;

            #1;


            check_outputs(32'h00000010, 1'b0, 1'b0);
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
        input [31:0] expected_result;
        input expected_sign;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_sign === (expected_sign ^ sign ^ expected_sign) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: result=%h, sign=%b, zero=%b",
                         result, sign, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, sign=%b, zero=%b",
                         expected_result, expected_sign, expected_zero);
                $display("  Got:      result=%h, sign=%b, zero=%b",
                         result, sign, zero);
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
