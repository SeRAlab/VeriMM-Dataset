`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] ALUop;
    reg [31:0] inputA;
    reg [31:0] inputB;
    wire [31:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUop(ALUop),
        .inputA(inputA),
        .inputB(inputB),
        .result(result),
        .zero(zero)
    );
    task testcase001;

    begin
        $display("Testcase 001: Addition (10 + 20)");
        ALUop = 3'b000; inputA = 32'd10; inputB = 32'd20;
        #1;

        check_outputs(32'd30, 1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Addition resulting in Zero (-5 + 5)");
        ALUop = 3'b000; inputA = 32'hFFFFFFF8; inputB = 32'h00000008;
        #1;

        check_outputs(32'd0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Subtraction (100 - 40)");
        ALUop = 3'b001; inputA = 32'd100; inputB = 32'd40;
        #1;

        check_outputs(32'd60, 1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Subtraction resulting in Zero (50 - 50)");
        ALUop = 3'b001; inputA = 32'd50; inputB = 32'd50;
        #1;

        check_outputs(32'd0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Bitwise AND (0xAAAA5555 & 0xFFFF0000)");
        ALUop = 3'b010; inputA = 32'hAAAA5555; inputB = 32'hFFFF0000;
        #1;

        check_outputs(32'hAAAA0000, 1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Bitwise AND resulting in Zero");
        ALUop = 3'b010; inputA = 32'hF0F0F0F0; inputB = 32'h0F0F0F0F;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Bitwise OR (0x0F0F0F0F | 0xF0F0F0F0)");
        ALUop = 3'b011; inputA = 32'h0F0F0F0F; inputB = 32'hF0F0F0F0;
        #1;

        check_outputs(32'hFFFFFFFF, 1'b0);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Bitwise OR resulting in Zero (0 | 0)");
        ALUop = 3'b011; inputA = 32'h0; inputB = 32'h0;
        #1;

        check_outputs(32'h0, 1'b1);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: SLT (5 < 10)");
        ALUop = 3'b100; inputA = 32'd5; inputB = 32'd10;
        #1;

        check_outputs(32'd1, 1'b0);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: SLT (10 < 5)");
        ALUop = 3'b100; inputA = 32'd10; inputB = 32'd5;
        #1;

        check_outputs(32'd0, 1'b1);
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
        input [31:0] expected_result;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: result=%h, zero=%b",
                         result, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, zero=%b",
                         expected_result, expected_zero);
                $display("  Got:      result=%h, zero=%b",
                         result, zero);
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
