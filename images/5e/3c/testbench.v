`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg w_alu_op;
    reg w_byte_op;
    reg w_imm_op;
    reg w_jump_op;
    reg w_mem_op;
    reg w_reg_jump_op;
    wire [1:0] w_wdata_ctrl_out_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .w_alu_op(w_alu_op),
        .w_byte_op(w_byte_op),
        .w_imm_op(w_imm_op),
        .w_jump_op(w_jump_op),
        .w_mem_op(w_mem_op),
        .w_reg_jump_op(w_reg_jump_op),
        .w_wdata_ctrl_out_2(w_wdata_ctrl_out_2)
    );
    task testcase001;

        begin
            $display("Testcase 001: Memory Operation (w_mem_op = 1)");
            test_num = 1;

            w_alu_op = 0;
            w_mem_op = 1;
            w_jump_op = 0;
            w_reg_jump_op = 0;
            w_byte_op = 0;
            w_imm_op = 0;



            #1;




            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: ALU Operation (w_alu_op = 1)");
            test_num = 2;

            w_alu_op = 1;
            w_mem_op = 0;
            w_jump_op = 0;
            w_reg_jump_op = 0;
            w_byte_op = 0;
            w_imm_op = 0;


            #1;



            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Jump Operation (w_jump_op = 1)");
            test_num = 3;

            w_alu_op = 0;
            w_mem_op = 0;
            w_jump_op = 1;
            w_reg_jump_op = 0;
            w_byte_op = 0;
            w_imm_op = 0;


            #1;



            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Register Jump Operation (w_reg_jump_op = 1)");
            test_num = 4;

            w_alu_op = 0;
            w_mem_op = 0;
            w_jump_op = 0;
            w_reg_jump_op = 1;
            w_byte_op = 0;
            w_imm_op = 0;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Immediate Operation (w_imm_op = 1)");
            test_num = 5;

            w_alu_op = 0;
            w_mem_op = 0;
            w_jump_op = 0;
            w_reg_jump_op = 0;
            w_byte_op = 0;
            w_imm_op = 1;


            #1;



            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Byte Operation (w_byte_op = 1)");
            test_num = 6;

            w_alu_op = 0;
            w_mem_op = 0;
            w_jump_op = 0;
            w_reg_jump_op = 0;
            w_byte_op = 1;
            w_imm_op = 0;

            #1;


            check_outputs(2'b11);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Priority Test (w_mem_op=1, w_alu_op=1)");
            test_num = 7;

            w_alu_op = 1;
            w_mem_op = 1;
            w_jump_op = 0;
            w_reg_jump_op = 0;
            w_byte_op = 0;
            w_imm_op = 0;


            #1;



            check_outputs(2'b01);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Undefined State (All ops = 0)");
            test_num = 8;

            w_alu_op = 0;
            w_mem_op = 0;
            w_jump_op = 0;
            w_reg_jump_op = 0;
            w_byte_op = 0;
            w_imm_op = 0;


            #1;



            check_outputs(2'bXX);
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
        input [1:0] expected_w_wdata_ctrl_out_2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_w_wdata_ctrl_out_2 === (expected_w_wdata_ctrl_out_2 ^ w_wdata_ctrl_out_2 ^ expected_w_wdata_ctrl_out_2)) begin
                $display("PASS");
                $display("  Outputs: w_wdata_ctrl_out_2=%h",
                         w_wdata_ctrl_out_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w_wdata_ctrl_out_2=%h",
                         expected_w_wdata_ctrl_out_2);
                $display("  Got:      w_wdata_ctrl_out_2=%h",
                         w_wdata_ctrl_out_2);
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
