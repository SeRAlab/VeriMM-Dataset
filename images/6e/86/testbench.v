`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ins_d;
    wire [5:0] func_d;
    wire [15:0] imm_d;
    wire [5:0] op_d;
    wire [4:0] rd_d;
    wire [4:0] rs_d;
    wire [4:0] rt_d;
    wire [4:0] shamt_d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ins_d(ins_d),
        .func_d(func_d),
        .imm_d(imm_d),
        .op_d(op_d),
        .rd_d(rd_d),
        .rs_d(rs_d),
        .rt_d(rt_d),
        .shamt_d(shamt_d)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: R-type ADD", test_num);
        ins_d = 32'h02324020;
        #1;

        check_outputs(6'h20, 16'h4020, 6'h00, 5'h08, 5'h11, 5'h12, 5'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: I-type ADDI", test_num);
        ins_d = 32'h22281234;



        #1;




        check_outputs(6'h34, 16'h1234, 6'h08, 5'h02, 5'h11, 5'h08, 5'h08);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Shift SLL", test_num);
        ins_d = 32'h000A2900;
        #1;

        check_outputs(6'h00, 16'h2900, 6'h00, 5'h05, 5'h00, 5'h0A, 5'h04);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: LW instruction", test_num);
        ins_d = 32'h8C620014;

        #1;


        check_outputs(6'h14, 16'h0014, 6'h23, 5'h00, 5'h03, 5'h02, 5'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All Zeros", test_num);
        ins_d = 32'h00000000;
        #1;

        check_outputs(6'h00, 16'h0000, 6'h00, 5'h00, 5'h00, 5'h00, 5'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All Ones", test_num);
        ins_d = 32'hFFFFFFFF;
        #1;

        check_outputs(6'h3F, 16'hFFFF, 6'h3F, 5'h1F, 5'h1F, 5'h1F, 5'h1F);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: J-type partial fields", test_num);
        ins_d = 32'h080048D5;




        #1;





        check_outputs(6'h15, 16'h48D5, 6'h02, 5'h09, 5'h00, 5'h00, 5'h03);
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
        input [5:0] expected_func_d;
        input [15:0] expected_imm_d;
        input [5:0] expected_op_d;
        input [4:0] expected_rd_d;
        input [4:0] expected_rs_d;
        input [4:0] expected_rt_d;
        input [4:0] expected_shamt_d;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_func_d === (expected_func_d ^ func_d ^ expected_func_d) &&
                expected_imm_d === (expected_imm_d ^ imm_d ^ expected_imm_d) &&
                expected_op_d === (expected_op_d ^ op_d ^ expected_op_d) &&
                expected_rd_d === (expected_rd_d ^ rd_d ^ expected_rd_d) &&
                expected_rs_d === (expected_rs_d ^ rs_d ^ expected_rs_d) &&
                expected_rt_d === (expected_rt_d ^ rt_d ^ expected_rt_d) &&
                expected_shamt_d === (expected_shamt_d ^ shamt_d ^ expected_shamt_d)) begin
                $display("PASS");
                $display("  Outputs: func_d=%h, imm_d=%h, op_d=%h, rd_d=%h, rs_d=%h, rt_d=%h, shamt_d=%h",
                         func_d, imm_d, op_d, rd_d, rs_d, rt_d, shamt_d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: func_d=%h, imm_d=%h, op_d=%h, rd_d=%h, rs_d=%h, rt_d=%h, shamt_d=%h",
                         expected_func_d, expected_imm_d, expected_op_d, expected_rd_d, expected_rs_d, expected_rt_d, expected_shamt_d);
                $display("  Got:      func_d=%h, imm_d=%h, op_d=%h, rd_d=%h, rs_d=%h, rt_d=%h, shamt_d=%h",
                         func_d, imm_d, op_d, rd_d, rs_d, rt_d, shamt_d);
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
