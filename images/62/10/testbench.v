`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Branch;
    reg [1:0] BranchOp;
    reg Jump;
    reg PCImm;
    reg [15:0] Rs;
    wire PCSrc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Branch(Branch),
        .BranchOp(BranchOp),
        .Jump(Jump),
        .PCImm(PCImm),
        .Rs(Rs),
        .PCSrc(PCSrc)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Jump instruction", test_num);
        Rs = 16'h1234;
        BranchOp = 2'b00;
        Branch = 0;
        PCImm = 0;
        Jump = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: PCImm instruction", test_num);
        Rs = 16'h1234;
        BranchOp = 2'b00;
        Branch = 0;
        PCImm = 1;
        Jump = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Branch if Zero (True)", test_num);
        Rs = 16'h0000;
        BranchOp = 2'b00;
        Branch = 1;
        PCImm = 0;
        Jump = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Branch if Zero (False)", test_num);
        Rs = 16'h0001;
        BranchOp = 2'b00;
        Branch = 1;
        PCImm = 0;
        Jump = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Branch if Not Zero (True)", test_num);
        Rs = 16'hFFFF;
        BranchOp = 2'b01;
        Branch = 1;
        PCImm = 0;
        Jump = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Branch if Not Zero (False)", test_num);
        Rs = 16'h0000;
        BranchOp = 2'b01;
        Branch = 1;
        PCImm = 0;
        Jump = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Branch if Less than Zero (True)", test_num);
        Rs = 16'h8001;
        BranchOp = 2'b10;
        Branch = 1;
        PCImm = 0;
        Jump = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Branch if Less than Zero (False)", test_num);
        Rs = 16'h0000;
        BranchOp = 2'b10;
        Branch = 1;
        PCImm = 0;
        Jump = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Branch if Greater/Equal Zero (True)", test_num);
        Rs = 16'h0005;
        BranchOp = 2'b11;
        Branch = 1;
        PCImm = 0;
        Jump = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Branch if Greater/Equal Zero (False)", test_num);
        Rs = 16'hFFFF;
        BranchOp = 2'b11;
        Branch = 1;
        PCImm = 0;
        Jump = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %0d: Branch logic disabled, condition met", test_num);
        Rs = 16'h0000;
        BranchOp = 2'b00;
        Branch = 0;
        PCImm = 0;
        Jump = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase %0d: Mixed signals (Jump=1, Condition False)", test_num);
        Rs = 16'h1111;
        BranchOp = 2'b00;
        Branch = 1;
        PCImm = 0;
        Jump = 1;
        #1;

        check_outputs(1'b1);
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
        input expected_PCSrc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PCSrc === (expected_PCSrc ^ PCSrc ^ expected_PCSrc)) begin
                $display("PASS");
                $display("  Outputs: PCSrc=%b",
                         PCSrc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PCSrc=%b",
                         expected_PCSrc);
                $display("  Got:      PCSrc=%b",
                         PCSrc);
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
