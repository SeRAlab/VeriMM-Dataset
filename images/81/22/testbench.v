`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [2:0] ALU_OP;
    reg [31:0] B;
    wire [31:0] F;
    wire OF;
    wire ZF;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .ALU_OP(ALU_OP),
        .B(B),
        .F(F),
        .OF(OF),
        .ZF(ZF)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ADD - Positive + Positive (No Overflow)", test_num);
        A = 32'd10; B = 32'd20; ALU_OP = 3'b000;
        #1;

        check_outputs(32'd30, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ADD - Positive + Positive (With Overflow)", test_num);
        A = 32'h7FFFFFFF; B = 32'h00000001; ALU_OP = 3'b000;
        #1;

        check_outputs(32'h80000000, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SUB - Basic Subtraction", test_num);
        A = 32'd50; B = 32'd20; ALU_OP = 3'b001;
        #1;

        check_outputs(32'd30, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SUB - Result Zero (Zero Flag)", test_num);
        A = 32'hA5A5A5A5; B = 32'hA5A5A5A5; ALU_OP = 3'b001;
        #1;

        check_outputs(32'h00000000, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SUB - Negative - Positive (With Overflow)", test_num);
        A = 32'h80000000; B = 32'h00000001; ALU_OP = 3'b001;
        #1;

        check_outputs(32'h7FFFFFFF, 1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: AND - Bitwise Operation", test_num);
        A = 32'hF0F0F0F0; B = 32'hAAAAFFFF; ALU_OP = 3'b010;
        #1;

        check_outputs(32'hA0A0F0F0, 1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: OR - Bitwise Operation", test_num);
        A = 32'hF0F0F0F0; B = 32'h0F0F0F0F; ALU_OP = 3'b011;
        #1;

        check_outputs(32'hFFFFFFFF, 1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: XOR - Bitwise Operation", test_num);
        A = 32'hF0F0F0F0; B = 32'hF0F0FFFF; ALU_OP = 3'b100;
        #1;

        check_outputs(32'h0000000F, 1'b0, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: NOR - Bitwise Operation", test_num);
        A = 32'h00000000; B = 32'h00000000; ALU_OP = 3'b101;
        #1;

        check_outputs(32'hFFFFFFFF, 1'b0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SLT - Less Than (True)", test_num);
        A = 32'hFFFFFFFF; B = 32'h00000001; ALU_OP = 3'b110;
        #1;

        check_outputs(32'h00000001, 1'b0, 1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SLT - Less Than (False)", test_num);
        A = 32'h00000005; B = 32'h00000002; ALU_OP = 3'b110;
        #1;

        check_outputs(32'h00000000, 1'b0, 1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SLL - Shift Left Logic", test_num);
        A = 32'h00000001; B = 32'd4; ALU_OP = 3'b111;
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
        testcase012();
        
        
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
        input [31:0] expected_F;
        input expected_OF;
        input expected_ZF;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_F === (expected_F ^ F ^ expected_F) &&
                expected_OF === (expected_OF ^ OF ^ expected_OF) &&
                expected_ZF === (expected_ZF ^ ZF ^ expected_ZF)) begin
                $display("PASS");
                $display("  Outputs: F=%h, OF=%b, ZF=%b",
                         F, OF, ZF);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: F=%h, OF=%b, ZF=%b",
                         expected_F, expected_OF, expected_ZF);
                $display("  Got:      F=%h, OF=%b, ZF=%b",
                         F, OF, ZF);
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
