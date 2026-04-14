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
            test_num = 1;
            $display("Testcase %0d: Addition (5 + 10)", test_num);
            inputA = 32'd5;
            inputB = 32'd10;
            ALUop  = 3'b000;
            #1;

            check_outputs(32'd15, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Addition (0 + 0)", test_num);
            inputA = 32'd0;
            inputB = 32'd0;
            ALUop  = 3'b000;
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Subtraction (20 - 5)", test_num);
            inputA = 32'd20;
            inputB = 32'd5;
            ALUop  = 3'b001;
            #1;

            check_outputs(32'd15, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Subtraction (100 - 100)", test_num);
            inputA = 32'd100;
            inputB = 32'd100;
            ALUop  = 3'b001;
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Subtraction (5 - 10)", test_num);
            inputA = 32'd5;
            inputB = 32'd10;
            ALUop  = 3'b001;

            #1;


            check_outputs(32'hFFFF_FFFB, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Bitwise AND", test_num);
            inputA = 32'hF0F0_AAAA;
            inputB = 32'h0F0F_FFFF;
            ALUop  = 3'b010;
            #1;

            check_outputs(32'h0000_AAAA, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Bitwise OR", test_num);
            inputA = 32'hF0F0_0000;
            inputB = 32'h0F0F_FFFF;
            ALUop  = 3'b011;
            #1;

            check_outputs(32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Bitwise XOR", test_num);
            inputA = 32'hAAAA_AAAA;
            inputB = 32'h5555_5555;
            ALUop  = 3'b100;
            #1;

            check_outputs(32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Addition Overflow Check", test_num);
            inputA = 32'hFFFF_FFFF;
            inputB = 32'h0000_0001;
            ALUop  = 3'b000;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: XOR same values", test_num);
            inputA = 32'h1234_5678;
            inputB = 32'h1234_5678;
            ALUop  = 3'b100;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
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
