`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] lhs;
    reg [2:0] op;
    reg [63:0] rhs;
    wire [63:0] result;
    wire sign;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .lhs(lhs),
        .op(op),
        .rhs(rhs),
        .result(result),
        .sign(sign),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Addition (Small positive numbers)", test_num);
            op = 3'b000;
            lhs = 64'd100;
            rhs = 64'd155;
            #1;

            check_outputs(64'd255, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Addition (Result zero)", test_num);
            op = 3'b000;
            lhs = 64'd0;
            rhs = 64'd0;
            #1;

            check_outputs(64'd0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Subtraction (Positive result)", test_num);
            op = 3'b001;
            lhs = 64'hF000000000000000;
            rhs = 64'h1000000000000000;
            #1;

            check_outputs(64'hE000000000000000, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Subtraction (Result zero)", test_num);
            op = 3'b001;
            lhs = 64'hFFFFFFFFFFFFFFFF;
            rhs = 64'hFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(64'd0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Subtraction (Negative result)", test_num);
            op = 3'b001;
            lhs = 64'd10;
            rhs = 64'd20;

            #1;


            check_outputs(64'hFFFFFFFFFFFFFFF6, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Bitwise AND", test_num);
            op = 3'b010;
            lhs = 64'hAAAAAAAAAAAAAAAA;
            rhs = 64'h5555555555555555;
            #1;

            check_outputs(64'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Bitwise OR", test_num);
            op = 3'b011;
            lhs = 64'hF0F0F0F0F0F0F0F0;
            rhs = 64'h0F0F0F0F0F0F0F0F;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Bitwise XOR", test_num);
            op = 3'b100;
            lhs = 64'h123456789ABCDEFF;
            rhs = 64'h123456789ABCDEFF;
            #1;

            check_outputs(64'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Addition (Overflow into sign bit)", test_num);
            op = 3'b000;
            lhs = 64'h7FFFFFFFFFFFFFFF;
            rhs = 64'h1;
            #1;

            check_outputs(64'h8000000000000000, 1'b1, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Bitwise AND (Masking)", test_num);
            op = 3'b010;
            lhs = 64'hFEDCBA9876543210;
            rhs = 64'hFFFFFFFF00000000;
            #1;

            check_outputs(64'hFEDCBA9800000000, 1'b1, 1'b0);
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
        input [63:0] expected_result;
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
