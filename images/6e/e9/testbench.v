`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] OP;
    wire BSEL;
    wire CISEL;
    wire LOGICAL_OP;
    wire [1:0] OSEL;
    wire SHIFT_LA;
    wire SHIFT_LR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .OP(OP),
        .BSEL(BSEL),
        .CISEL(CISEL),
        .LOGICAL_OP(LOGICAL_OP),
        .OSEL(OSEL),
        .SHIFT_LA(SHIFT_LA),
        .SHIFT_LR(SHIFT_LR)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Opcode 000 (Addition)", test_num);
            OP = 3'b000;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Opcode 001 (Subtraction)", test_num);
            OP = 3'b001;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0, 2'b00, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Opcode 010 (Logical OP)", test_num);
            OP = 3'b010;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 2'b01, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Opcode 011 (Logical OP)", test_num);
            OP = 3'b011;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 2'b01, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Opcode 100 (Shift Left)", test_num);
            OP = 3'b100;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 2'b10, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Opcode 101 (Shift Right)", test_num);
            OP = 3'b101;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Opcode 110 (Custom)", test_num);
            OP = 3'b110;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 2'b10, 1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Opcode 111 (Default/Reserved)", test_num);
            OP = 3'b111;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 2'b11, 1'b0, 1'b0);
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
        input expected_BSEL;
        input expected_CISEL;
        input expected_LOGICAL_OP;
        input [1:0] expected_OSEL;
        input expected_SHIFT_LA;
        input expected_SHIFT_LR;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_BSEL === (expected_BSEL ^ BSEL ^ expected_BSEL) &&
                expected_CISEL === (expected_CISEL ^ CISEL ^ expected_CISEL) &&
                expected_LOGICAL_OP === (expected_LOGICAL_OP ^ LOGICAL_OP ^ expected_LOGICAL_OP) &&
                expected_OSEL === (expected_OSEL ^ OSEL ^ expected_OSEL) &&
                expected_SHIFT_LA === (expected_SHIFT_LA ^ SHIFT_LA ^ expected_SHIFT_LA) &&
                expected_SHIFT_LR === (expected_SHIFT_LR ^ SHIFT_LR ^ expected_SHIFT_LR)) begin
                $display("PASS");
                $display("  Outputs: BSEL=%b, CISEL=%b, LOGICAL_OP=%b, OSEL=%h, SHIFT_LA=%b, SHIFT_LR=%b",
                         BSEL, CISEL, LOGICAL_OP, OSEL, SHIFT_LA, SHIFT_LR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BSEL=%b, CISEL=%b, LOGICAL_OP=%b, OSEL=%h, SHIFT_LA=%b, SHIFT_LR=%b",
                         expected_BSEL, expected_CISEL, expected_LOGICAL_OP, expected_OSEL, expected_SHIFT_LA, expected_SHIFT_LR);
                $display("  Got:      BSEL=%b, CISEL=%b, LOGICAL_OP=%b, OSEL=%h, SHIFT_LA=%b, SHIFT_LR=%b",
                         BSEL, CISEL, LOGICAL_OP, OSEL, SHIFT_LA, SHIFT_LR);
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
