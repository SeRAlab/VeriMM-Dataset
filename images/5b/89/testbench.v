`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ALU_operation_i;
    reg [31:0] aluSrc1;
    reg [31:0] aluSrc2;
    wire overflow;
    wire [31:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_operation_i(ALU_operation_i),
        .aluSrc1(aluSrc1),
        .aluSrc2(aluSrc2),
        .overflow(overflow),
        .result(result),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Addition (15 + 25)", test_num);
            aluSrc1 = 32'd15;
            aluSrc2 = 32'd25;
            ALU_operation_i = 4'b0000;
            #1;

            check_outputs(1'b0, 32'd40, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Addition Zero Result (-10 + 10)", test_num);
            aluSrc1 = -32'd10;
            aluSrc2 = 32'd10;
            ALU_operation_i = 4'b0000;
            #1;

            check_outputs(1'b0, 32'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Subtraction (100 - 40)", test_num);
            aluSrc1 = 32'd100;
            aluSrc2 = 32'd40;
            ALU_operation_i = 4'b0001;
            #1;

            check_outputs(1'b0, 32'd60, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Subtraction Zero Result (55 - 55)", test_num);
            aluSrc1 = 32'd55;
            aluSrc2 = 32'd55;
            ALU_operation_i = 4'b0001;
            #1;

            check_outputs(1'b0, 32'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Bitwise AND", test_num);
            aluSrc1 = 32'hAAAA_AAAA;
            aluSrc2 = 32'hFFFF_0000;
            ALU_operation_i = 4'b0010;
            #1;

            check_outputs(1'b0, 32'hAAAA_0000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Bitwise OR", test_num);
            aluSrc1 = 32'h1234_0000;
            aluSrc2 = 32'h0000_5678;
            ALU_operation_i = 4'b0011;
            #1;

            check_outputs(1'b0, 32'h1234_5678, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Bitwise NOT (Source 1)", test_num);
            aluSrc1 = 32'h0000_FFFF;
            aluSrc2 = 32'hFFFF_FFFF;
            ALU_operation_i = 4'b0100;
            #1;

            check_outputs(1'b0, 32'hFFFF_0000, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Comparison SLT (5 < 10)", test_num);
            aluSrc1 = 32'd5;
            aluSrc2 = 32'd10;
            ALU_operation_i = 4'b0101;
            #1;

            check_outputs(1'b0, 32'd1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Comparison SLT (20 < 10)", test_num);
            aluSrc1 = 32'd20;
            aluSrc2 = 32'd10;
            ALU_operation_i = 4'b0101;
            #1;

            check_outputs(1'b0, 32'd0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Subtraction (0 - 1)", test_num);
            aluSrc1 = 32'd0;
            aluSrc2 = 32'd1;
            ALU_operation_i = 4'b0001;
            #1;

            check_outputs(1'b0, 32'hFFFF_FFFF, 1'b0);
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
        input expected_overflow;
        input [31:0] expected_result;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, result=%h, zero=%b",
                         overflow, result, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, result=%h, zero=%b",
                         expected_overflow, expected_result, expected_zero);
                $display("  Got:      overflow=%b, result=%h, zero=%b",
                         overflow, result, zero);
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
