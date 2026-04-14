`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] op;
    wire [1:0] aluop;
    wire alusrcD;
    wire branchD;
    wire memtoregD;
    wire memwriteD;
    wire reg_destD;
    wire regwriteD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .op(op),
        .aluop(aluop),
        .alusrcD(alusrcD),
        .branchD(branchD),
        .memtoregD(memtoregD),
        .memwriteD(memwriteD),
        .reg_destD(reg_destD),
        .regwriteD(regwriteD)
    );
    task testcase001;

    begin
        test_num = 1;
        op = 7'b0000000;
        #1;

        check_outputs(2'b10, 0, 0, 0, 0, 1, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        op = 7'b0100011;
        #1;

        check_outputs(2'b00, 1, 0, 1, 0, 0, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        op = 7'b0101011;
        #1;

        check_outputs(2'b00, 1, 0, 0, 1, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        op = 7'b0000100;
        #1;

        check_outputs(2'b01, 0, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        op = 7'b0001000;
        #1;

        check_outputs(2'b00, 1, 0, 0, 0, 0, 1);
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
        input [1:0] expected_aluop;
        input expected_alusrcD;
        input expected_branchD;
        input expected_memtoregD;
        input expected_memwriteD;
        input expected_reg_destD;
        input expected_regwriteD;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_aluop === (expected_aluop ^ aluop ^ expected_aluop) &&
                expected_alusrcD === (expected_alusrcD ^ alusrcD ^ expected_alusrcD) &&
                expected_branchD === (expected_branchD ^ branchD ^ expected_branchD) &&
                expected_memtoregD === (expected_memtoregD ^ memtoregD ^ expected_memtoregD) &&
                expected_memwriteD === (expected_memwriteD ^ memwriteD ^ expected_memwriteD) &&
                expected_reg_destD === (expected_reg_destD ^ reg_destD ^ expected_reg_destD) &&
                expected_regwriteD === (expected_regwriteD ^ regwriteD ^ expected_regwriteD)) begin
                $display("PASS");
                $display("  Outputs: aluop=%h, alusrcD=%b, branchD=%b, memtoregD=%b, memwriteD=%b, reg_destD=%b, regwriteD=%b",
                         aluop, alusrcD, branchD, memtoregD, memwriteD, reg_destD, regwriteD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluop=%h, alusrcD=%b, branchD=%b, memtoregD=%b, memwriteD=%b, reg_destD=%b, regwriteD=%b",
                         expected_aluop, expected_alusrcD, expected_branchD, expected_memtoregD, expected_memwriteD, expected_reg_destD, expected_regwriteD);
                $display("  Got:      aluop=%h, alusrcD=%b, branchD=%b, memtoregD=%b, memwriteD=%b, reg_destD=%b, regwriteD=%b",
                         aluop, alusrcD, branchD, memtoregD, memwriteD, reg_destD, regwriteD);
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
