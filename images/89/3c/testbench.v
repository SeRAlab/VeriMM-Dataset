`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] branchTarget;
    reg flagsE;
    reg flagsGT;
    reg isBeq;
    reg isBgt;
    reg isRet;
    reg isUBranch;
    reg [31:0] op1;
    wire [31:0] branchPC;
    wire isBranchTaken;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .branchTarget(branchTarget),
        .flagsE(flagsE),
        .flagsGT(flagsGT),
        .isBeq(isBeq),
        .isBgt(isBgt),
        .isRet(isRet),
        .isUBranch(isUBranch),
        .op1(op1),
        .branchPC(branchPC),
        .isBranchTaken(isBranchTaken)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Unconditional Branch", test_num);
        branchTarget = 32'hAAAA_BBBB;
        op1          = 32'h0000_1111;
        isRet        = 1'b0;
        isUBranch    = 1'b1;
        isBeq        = 1'b0;
        flagsE       = 1'b0;
        isBgt        = 1'b0;
        flagsGT      = 1'b0;
        #1;

        check_outputs(32'hAAAA_BBBB, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: BEQ Taken", test_num);
        branchTarget = 32'h1234_5678;
        op1          = 32'h0000_0000;
        isRet        = 1'b0;
        isUBranch    = 1'b0;
        isBeq        = 1'b1;
        flagsE       = 1'b1;
        isBgt        = 1'b0;
        flagsGT      = 1'b0;
        #1;

        check_outputs(32'h1234_5678, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: BEQ Not Taken", test_num);
        branchTarget = 32'h1234_5678;
        op1          = 32'h0000_0000;
        isRet        = 1'b0;
        isUBranch    = 1'b0;
        isBeq        = 1'b1;
        flagsE       = 1'b0;
        isBgt        = 1'b0;
        flagsGT      = 1'b0;
        #1;

        check_outputs(32'h1234_5678, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: BGT Taken", test_num);
        branchTarget = 32'hDEAD_BEEF;
        op1          = 32'hFFFF_FFFF;
        isRet        = 1'b0;
        isUBranch    = 1'b0;
        isBeq        = 1'b0;
        flagsE       = 1'b0;
        isBgt        = 1'b1;
        flagsGT      = 1'b1;
        #1;

        check_outputs(32'hDEAD_BEEF, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: BGT Not Taken", test_num);
        branchTarget = 32'hDEAD_BEEF;
        op1          = 32'hFFFF_FFFF;
        isRet        = 1'b0;
        isUBranch    = 1'b0;
        isBeq        = 1'b0;
        flagsE       = 1'b0;
        isBgt        = 1'b1;
        flagsGT      = 1'b0;
        #1;

        check_outputs(32'hDEAD_BEEF, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Return (Unconditional)", test_num);
        branchTarget = 32'hAAAA_AAAA;
        op1          = 32'h8888_7777;
        isRet        = 1'b1;
        isUBranch    = 1'b1;
        isBeq        = 1'b0;
        flagsE       = 1'b0;
        isBgt        = 1'b0;
        flagsGT      = 1'b0;
        #1;

        check_outputs(32'h8888_7777, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Return (Not Taken)", test_num);
        branchTarget = 32'hAAAA_AAAA;
        op1          = 32'h8888_7777;
        isRet        = 1'b1;
        isUBranch    = 1'b0;
        isBeq        = 1'b0;
        flagsE       = 1'b0;
        isBgt        = 1'b0;
        flagsGT      = 1'b0;
        #1;

        check_outputs(32'h8888_7777, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Default/No Operation", test_num);
        branchTarget = 32'h0000_1234;
        op1          = 32'h0000_5678;
        isRet        = 1'b0;
        isUBranch    = 1'b0;
        isBeq        = 1'b0;
        flagsE       = 1'b1;
        isBgt        = 1'b0;
        flagsGT      = 1'b1;
        #1;

        check_outputs(32'h0000_1234, 1'b0);
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
        input [31:0] expected_branchPC;
        input expected_isBranchTaken;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_branchPC === (expected_branchPC ^ branchPC ^ expected_branchPC) &&
                expected_isBranchTaken === (expected_isBranchTaken ^ isBranchTaken ^ expected_isBranchTaken)) begin
                $display("PASS");
                $display("  Outputs: branchPC=%h, isBranchTaken=%b",
                         branchPC, isBranchTaken);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: branchPC=%h, isBranchTaken=%b",
                         expected_branchPC, expected_isBranchTaken);
                $display("  Got:      branchPC=%h, isBranchTaken=%b",
                         branchPC, isBranchTaken);
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
