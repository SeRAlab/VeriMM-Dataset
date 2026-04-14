`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ALU_Control;
    reg [31:0] operand_A;
    reg [31:0] operand_B;
    wire [31:0] ALU_result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_Control(ALU_Control),
        .operand_A(operand_A),
        .operand_B(operand_B),
        .ALU_result(ALU_result),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Bitwise AND", test_num);
            operand_A = 32'hAAAA_5555;
            operand_B = 32'hF0F0_F0F0;
            ALU_Control = 4'b0000;
            #10;
            #1;

            check_outputs(32'hA0A0_5050, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Bitwise OR", test_num);
            operand_A = 32'hAAAA_5555;
            operand_B = 32'hF0F0_F0F0;
            ALU_Control = 4'b0001;
            #10;
            #1;

            check_outputs(32'hFAFA_F5F5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Addition (Positive)", test_num);
            operand_A = 32'd100;
            operand_B = 32'd250;
            ALU_Control = 4'b0010;
            #10;
            #1;

            check_outputs(32'd350, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Addition (Signed/Wrapping)", test_num);
            operand_A = 32'hFFFF_FFFF;
            operand_B = 32'h0000_0001;
            ALU_Control = 4'b0010;
            #10;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Subtraction (Positive)", test_num);
            operand_A = 32'd500;
            operand_B = 32'd100;
            ALU_Control = 4'b0110;
            #10;
            #1;

            check_outputs(32'd400, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Subtraction (Zero Result)", test_num);
            operand_A = 32'h1234_5678;
            operand_B = 32'h1234_5678;
            ALU_Control = 4'b0110;
            #10;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: SLT (True: A < B)", test_num);
            operand_A = 32'd10;
            operand_B = 32'd20;
            ALU_Control = 4'b0111;
            #10;
            #1;

            check_outputs(32'h0000_0001, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: SLT (False: A > B)", test_num);
            operand_A = 32'd20;
            operand_B = 32'd10;
            ALU_Control = 4'b0111;
            #10;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Bitwise NOR", test_num);
            operand_A = 32'h0000_0000;
            operand_B = 32'h0000_0000;
            ALU_Control = 4'b1100;
            #10;
            #1;

            check_outputs(32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Subtraction (Negative Result)", test_num);
            operand_A = 32'd10;
            operand_B = 32'd15;
            ALU_Control = 4'b0110;
            #10;
            #1;

            check_outputs(32'hFFFF_FFFB, 1'b0);
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
        input [31:0] expected_ALU_result;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_result === (expected_ALU_result ^ ALU_result ^ expected_ALU_result) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: ALU_result=%h, zero=%b",
                         ALU_result, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_result=%h, zero=%b",
                         expected_ALU_result, expected_zero);
                $display("  Got:      ALU_result=%h, zero=%b",
                         ALU_result, zero);
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
