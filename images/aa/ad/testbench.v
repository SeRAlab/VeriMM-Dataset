`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] instruction;
    wire [63:0] signExtended;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .instruction(instruction),
        .signExtended(signExtended)
    );
    task testcase001;

    begin
        test_num = 1;
        instruction = 32'h12300003;
        $display("Test Case %0d: Load Instruction Positive Imm (0x123)", test_num);
        #1;

        check_outputs(64'h0000000000000123);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        instruction = 32'hFFF00003;
        $display("Test Case %0d: Load Instruction Negative Imm (-1)", test_num);
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        instruction = 32'h3E000FA3;
        $display("Test Case %0d: Store Instruction Positive Imm (0x3FF)", test_num);
        #1;

        check_outputs(64'h00000000000003FF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        instruction = 32'hFE000FA3;
        $display("Test Case %0d: Store Instruction Negative Imm (-1)", test_num);
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        instruction = 32'h00000863;
        $display("Test Case %0d: Branch Instruction Positive Imm (0x10)", test_num);
        #1;

        check_outputs(64'h0000000000000010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        instruction = 32'hFE000FF3;
        $display("Test Case %0d: Branch Instruction Negative Imm (-2)", test_num);
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFFE);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        instruction = 32'h80000003;
        $display("Test Case %0d: Load Instruction Max Negative Imm (-2048)", test_num);
        #1;

        check_outputs(64'hFFFFFFFFFFFFF800);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        instruction = 32'h80000063;
        $display("Test Case %0d: Branch Instruction Max Negative Imm (-4096)", test_num);
        #1;

        check_outputs(64'hFFFFFFFFFFFFF000);
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
        input [63:0] expected_signExtended;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_signExtended === (expected_signExtended ^ signExtended ^ expected_signExtended)) begin
                $display("PASS");
                $display("  Outputs: signExtended=%h",
                         signExtended);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: signExtended=%h",
                         expected_signExtended);
                $display("  Got:      signExtended=%h",
                         signExtended);
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
