`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] logic_op_x;
    reg [31:0] operand_0_x;
    reg [31:0] operand_1_x;
    wire [31:0] logic_result_x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .logic_op_x(logic_op_x),
        .operand_0_x(operand_0_x),
        .operand_1_x(operand_1_x),
        .logic_result_x(logic_result_x)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Bitwise AND (selector 00)", test_num);
        logic_op_x = 2'b00;
        operand_0_x = 32'hFFFF0000;
        operand_1_x = 32'hAAAA5555;
        #1;

        check_outputs(32'hAAAA0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Bitwise OR (selector 01)", test_num);
        logic_op_x = 2'b01;
        operand_0_x = 32'hF0F0F0F0;
        operand_1_x = 32'h0F0F0F0F;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Bitwise XOR (selector 10)", test_num);
        logic_op_x = 2'b10;
        operand_0_x = 32'h12345678;
        operand_1_x = 32'hFFFFFFFF;
        #1;

        check_outputs(32'hEDCBA987);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Selector 11 (Expected Zero)", test_num);
        logic_op_x = 2'b11;
        operand_0_x = 32'hFFFFFFFF;
        operand_1_x = 32'hFFFFFFFF;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Bitwise AND with zero result", test_num);
        logic_op_x = 2'b00;
        operand_0_x = 32'hAAAAAAAA;
        operand_1_x = 32'h55555555;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Bitwise OR with identical operands", test_num);
        logic_op_x = 2'b01;
        operand_0_x = 32'h12344321;
        operand_1_x = 32'h12344321;
        #1;

        check_outputs(32'h12344321);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Bitwise XOR with identical operands (Zero)", test_num);
        logic_op_x = 2'b10;
        operand_0_x = 32'hABCDE123;
        operand_1_x = 32'hABCDE123;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Default case with alternating bits", test_num);
        logic_op_x = 2'b11;
        operand_0_x = 32'h10101010;
        operand_1_x = 32'h01010101;
        #1;

        check_outputs(32'h00000000);
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
        input [31:0] expected_logic_result_x;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_logic_result_x === (expected_logic_result_x ^ logic_result_x ^ expected_logic_result_x)) begin
                $display("PASS");
                $display("  Outputs: logic_result_x=%h",
                         logic_result_x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: logic_result_x=%h",
                         expected_logic_result_x);
                $display("  Got:      logic_result_x=%h",
                         logic_result_x);
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
