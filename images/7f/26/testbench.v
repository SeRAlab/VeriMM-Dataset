`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] func;
    reg [5:0] opcode;
    wire is_branch;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .func(func),
        .opcode(opcode),
        .is_branch(is_branch)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: BEQ Instruction (Opcode 0x04)", test_num);
        opcode = 6'h04;
        func = 6'h00;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: BNE Instruction (Opcode 0x05)", test_num);
        opcode = 6'h05;
        func = 6'h00;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: BLEZ Instruction (Opcode 0x06)", test_num);
        opcode = 6'h06;
        func = 6'h00;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: BGTZ Instruction (Opcode 0x07)", test_num);
        opcode = 6'h07;
        func = 6'h00;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: REGIMM Instruction (Opcode 0x01)", test_num);
        opcode = 6'h01;
        func = 6'h00;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: R-type ADD (Opcode 0x00, Func 0x20)", test_num);
        opcode = 6'h00;
        func = 6'h20;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: LW Instruction (Opcode 0x23)", test_num);
        opcode = 6'h23;
        func = 6'h00;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: SW Instruction (Opcode 0x2B)", test_num);
        opcode = 6'h2B;
        func = 6'h00;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Jump Instruction (Opcode 0x02)", test_num);
        opcode = 6'h02;
        func = 6'h00;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: ADDI Instruction (Opcode 0x08)", test_num);
        opcode = 6'h08;
        func = 6'h00;
        #1;

        check_outputs(1'b0);
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
        input expected_is_branch;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_is_branch === (expected_is_branch ^ is_branch ^ expected_is_branch)) begin
                $display("PASS");
                $display("  Outputs: is_branch=%b",
                         is_branch);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_branch=%b",
                         expected_is_branch);
                $display("  Got:      is_branch=%b",
                         is_branch);
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
