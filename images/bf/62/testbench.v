`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] aluCtr;
    reg [31:0] input1;
    reg [31:0] input2;
    wire [31:0] aluRes;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aluCtr(aluCtr),
        .input1(input1),
        .input2(input2),
        .aluRes(aluRes),
        .zero(zero)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %03d: Addition (Positive)", test_num);
        aluCtr = ALU_ADD;
        input1 = 32'd150;
        input2 = 32'd350;
        #1;

        check_outputs(32'd500, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %03d: Addition (Result Zero / Overflow case)", test_num);
        aluCtr = ALU_ADD;
        input1 = 32'hFFFFFFFF;
        input2 = 32'h00000001;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %03d: Subtraction (Positive result)", test_num);
        aluCtr = ALU_SUB;
        input1 = 32'd1000;
        input2 = 32'd400;
        #1;

        check_outputs(32'd600, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %03d: Subtraction (Result Zero)", test_num);
        aluCtr = ALU_SUB;
        input1 = 32'hABCDE;
        input2 = 32'hABCDE;
        #1;

        check_outputs(32'h0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %03d: Bitwise AND", test_num);
        aluCtr = ALU_AND;
        input1 = 32'hF0F0AAAA;
        input2 = 32'h0F0F5555;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %03d: Bitwise OR", test_num);
        aluCtr = ALU_OR;
        input1 = 32'hF0F00000;
        input2 = 32'h0000AAAA;
        #1;

        check_outputs(32'hF0F0AAAA, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %03d: Bitwise XOR", test_num);
        aluCtr = ALU_XOR;
        input1 = 32'hFFFFFFFF;
        input2 = 32'hAAAAAAAA;
        #1;

        check_outputs(32'h55555555, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %03d: Shift Left Logical", test_num);
        aluCtr = ALU_SLL;
        input1 = 32'h00000001;
        input2 = 32'd4;
        #1;

        check_outputs(32'h00000010, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %03d: Shift Right Logical", test_num);
        aluCtr = ALU_SRL;
        input1 = 32'h80000000;
        input2 = 32'd1;
        #1;

        check_outputs(32'h40000000, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %03d: Shift Right Arithmetic (Sign Extension)", test_num);
        aluCtr = ALU_SRA;
        input1 = 32'h80000000;
        input2 = 32'd2;
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
        input [31:0] expected_aluRes;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_aluRes === (expected_aluRes ^ aluRes ^ expected_aluRes) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: aluRes=%h, zero=%b",
                         aluRes, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluRes=%h, zero=%b",
                         expected_aluRes, expected_zero);
                $display("  Got:      aluRes=%h, zero=%b",
                         aluRes, zero);
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
