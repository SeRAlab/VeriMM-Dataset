`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] opcode;
    reg [31:0] reg_rs1;
    reg [31:0] rs_value_sign;
    wire branch;
    wire jump;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .opcode(opcode),
        .reg_rs1(reg_rs1),
        .rs_value_sign(rs_value_sign),
        .branch(branch),
        .jump(jump)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: JUMP opcode detection", test_num);
            opcode = 6'b110111;
            reg_rs1 = 32'hAAAA_BBBB;
            rs_value_sign = 32'h1111_2222;

            #1;


            check_outputs(0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: BRA opcode - Successful match (Positive)", test_num);
            opcode = 6'b110000;
            reg_rs1 = 32'd123456;
            rs_value_sign = 32'd123456;

            #1;


            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: BRA opcode - Successful match (Negative/Signed)", test_num);
            opcode = 6'b110000;
            reg_rs1 = -32'd500;
            rs_value_sign = -32'd500;

            #1;


            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: BRA opcode - Mismatch in values", test_num);
            opcode = 6'b110000;
            reg_rs1 = 32'd100;
            rs_value_sign = 32'd200;

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: JUMP opcode - Register values match", test_num);
            opcode = 6'b110111;
            reg_rs1 = 32'hFFFF_FFFF;
            rs_value_sign = 32'hFFFF_FFFF;

            #1;


            check_outputs(0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: No Opcode match (NOP/Other)", test_num);
            opcode = 6'b000000;
            reg_rs1 = 32'd0;
            rs_value_sign = 32'd0;

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: BRA opcode - Zero values match", test_num);
            opcode = 6'b110000;
            reg_rs1 = 32'h0;
            rs_value_sign = 32'h0;
            #1;

            check_outputs(1, 0);
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
        input expected_branch;
        input expected_jump;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_branch === (expected_branch ^ branch ^ expected_branch) &&
                expected_jump === (expected_jump ^ jump ^ expected_jump)) begin
                $display("PASS");
                $display("  Outputs: branch=%b, jump=%b",
                         branch, jump);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: branch=%b, jump=%b",
                         expected_branch, expected_jump);
                $display("  Got:      branch=%b, jump=%b",
                         branch, jump);
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
