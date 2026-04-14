`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] op1;
    reg [31:0] op2;
    reg [3:0] sel_op;
    wire ZF;
    wire [31:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .op1(op1),
        .op2(op2),
        .sel_op(sel_op),
        .ZF(ZF),
        .res(res)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: bitwise AND (Result Zero)", test_num);
        op1 = 32'hAAAAAAAA;
        op2 = 32'h55555555;
        sel_op = 4'd0;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: bitwise AND (Result Non-Zero)", test_num);
        op1 = 32'hFFFFFFFF;
        op2 = 32'h12345678;
        sel_op = 4'd0;
        #1;

        check_outputs(1'b0, 32'h12345678);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: bitwise OR (Result Zero)", test_num);
        op1 = 32'h00000000;
        op2 = 32'h00000000;
        sel_op = 4'd1;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: bitwise OR (Result Non-Zero)", test_num);
        op1 = 32'hF0F0F0F0;
        op2 = 32'h0F0F0F0F;
        sel_op = 4'd1;
        #1;

        check_outputs(1'b0, 32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (Positive Result)", test_num);
        op1 = 32'd1000;
        op2 = 32'd2000;
        sel_op = 4'd2;
        #1;

        check_outputs(1'b0, 32'd3000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (Zero Result / Overflow wrap)", test_num);
        op1 = 32'hFFFFFFFF;
        op2 = 32'h00000001;
        sel_op = 4'd2;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (Positive Result)", test_num);
        op1 = 32'd500;
        op2 = 32'd100;
        sel_op = 4'd3;
        #1;

        check_outputs(1'b0, 32'd400);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (Zero Result)", test_num);
        op1 = 32'h1234ABCD;
        op2 = 32'h1234ABCD;
        sel_op = 4'd3;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: NOR operation (Result Non-Zero)", test_num);
        op1 = 32'h00000000;
        op2 = 32'h00000000;
        sel_op = 4'd4;
        #1;

        check_outputs(1'b0, 32'hFFFFFFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: NOR operation (Result Zero)", test_num);
        op1 = 32'hFFFFFFFF;
        op2 = 32'h00000000;
        sel_op = 4'd4;
        #1;

        check_outputs(1'b1, 32'h00000000);
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
        input expected_ZF;
        input [31:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ZF === (expected_ZF ^ ZF ^ expected_ZF) &&
                expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: ZF=%b, res=%h",
                         ZF, res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ZF=%b, res=%h",
                         expected_ZF, expected_res);
                $display("  Got:      ZF=%b, res=%h",
                         ZF, res);
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
