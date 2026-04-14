`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a_in;
    reg [4:0] alu_ctl;
    reg [31:0] b_in;
    wire [31:0] result;
    wire zero_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_in(a_in),
        .alu_ctl(alu_ctl),
        .b_in(b_in),
        .result(result),
        .zero_flag(zero_flag)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise AND", test_num);
        alu_ctl = ALU_AND;
        a_in = 32'hFFFF0000;
        b_in = 32'hAAAAFFFF;
        #1;

        check_outputs(32'hAAAA0000, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise OR", test_num);
        alu_ctl = ALU_OR;
        a_in = 32'hF0F0F0F0;
        b_in = 32'h0F0F0F0F;
        #1;

        check_outputs(32'hFFFFFFFF, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (Positive)", test_num);
        alu_ctl = ALU_ADD;
        a_in = 32'd1234;
        b_in = 32'd5678;
        #1;

        check_outputs(32'd6912, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (Zero Result/Overflow)", test_num);
        alu_ctl = ALU_ADD;
        a_in = 32'hFFFFFFFF;
        b_in = 32'h00000001;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (A > B)", test_num);
        alu_ctl = ALU_SUB;
        a_in = 32'd1000;
        b_in = 32'd300;
        #1;

        check_outputs(32'd700, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (A == B, Zero Flag)", test_num);
        alu_ctl = ALU_SUB;
        a_in = 32'hCAFE_BABE;
        b_in = 32'hCAFE_BABE;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Set Less Than (10 < 20)", test_num);
        alu_ctl = ALU_SLT;
        a_in = 32'd10;
        b_in = 32'd20;
        #1;

        check_outputs(32'h00000001, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Set Less Than (20 < 10)", test_num);
        alu_ctl = ALU_SLT;
        a_in = 32'd20;
        b_in = 32'd10;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise NOR", test_num);
        alu_ctl = ALU_NOR;
        a_in = 32'h00000000;
        b_in = 32'h00000000;
        #1;

        check_outputs(32'hFFFFFFFF, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise XOR", test_num);
        alu_ctl = ALU_XOR;
        a_in = 32'hAAAAAAAA;
        b_in = 32'h55555555;
        #1;

        check_outputs(32'hFFFFFFFF, 1'b0);
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
        input expected_zero_flag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero_flag === (expected_zero_flag ^ zero_flag ^ expected_zero_flag)) begin
                $display("PASS");
                $display("  Outputs: result=%h, zero_flag=%b",
                         result, zero_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, zero_flag=%b",
                         expected_result, expected_zero_flag);
                $display("  Got:      result=%h, zero_flag=%b",
                         result, zero_flag);
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
