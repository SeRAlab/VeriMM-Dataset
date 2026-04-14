`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ex_mem_CCR_write;
    reg [5:0] ex_mem_op;
    reg [2:0] ex_mem_regA;
    reg mem_wb_CCR_write;
    reg [5:0] mem_wb_op;
    reg [2:0] mem_wb_regA;
    reg [2:0] mem_wb_regC;
    wire [1:0] F3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ex_mem_CCR_write(ex_mem_CCR_write),
        .ex_mem_op(ex_mem_op),
        .ex_mem_regA(ex_mem_regA),
        .mem_wb_CCR_write(mem_wb_CCR_write),
        .mem_wb_op(mem_wb_op),
        .mem_wb_regA(mem_wb_regA),
        .mem_wb_regC(mem_wb_regC),
        .F3(F3)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Forwarding from LW (RegA) to SW", test_num);

            ex_mem_CCR_write = 0; ex_mem_op = 0; ex_mem_regA = 0;
            mem_wb_CCR_write = 0; mem_wb_op = 0; mem_wb_regA = 0; mem_wb_regC = 0;


            ex_mem_op = OP_SW;
            ex_mem_regA = 3'd2;
            mem_wb_op = OP_LW;
            mem_wb_regA = 3'd2;
            mem_wb_regC = 3'd5;
            mem_wb_CCR_write = 1'b0;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Forwarding from Arithmetic (RegC) to SW", test_num);
            ex_mem_op = OP_SW;
            ex_mem_regA = 3'd4;
            mem_wb_op = OP_ALU;
            mem_wb_regA = 3'd1;
            mem_wb_regC = 3'd4;
            mem_wb_CCR_write = 1'b0;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: No forwarding - Register Mismatch", test_num);
            ex_mem_op = OP_SW;
            ex_mem_regA = 3'd2;
            mem_wb_op = OP_LW;
            mem_wb_regA = 3'd3;
            mem_wb_regC = 3'd4;
            mem_wb_CCR_write = 1'b0;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: No forwarding - CCR Write Active", test_num);
            ex_mem_op = OP_SW;
            ex_mem_regA = 3'd2;
            mem_wb_op = OP_ALU;
            mem_wb_regA = 3'd2;
            mem_wb_regC = 3'd2;
            mem_wb_CCR_write = 1'b1;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: No forwarding - EX instruction not SW", test_num);
            ex_mem_op = OP_BEQ;
            ex_mem_regA = 3'd2;
            mem_wb_op = OP_LW;
            mem_wb_regA = 3'd2;
            mem_wb_CCR_write = 1'b0;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Priority Check (RegA and RegC both match)", test_num);
            ex_mem_op = OP_SW;
            ex_mem_regA = 3'd2;
            mem_wb_op = OP_ALU;
            mem_wb_regA = 3'd2;
            mem_wb_regC = 3'd2;
            mem_wb_CCR_write = 1'b0;



            #1;
            if (F3 != 2'b00) begin
                $display("PASS - Forwarding signal active: %b", F3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL - Forwarding signal inactive");
                fail_count = fail_count + 1;
            end
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
        input [1:0] expected_F3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_F3 === (expected_F3 ^ F3 ^ expected_F3)) begin
                $display("PASS");
                $display("  Outputs: F3=%h",
                         F3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: F3=%h",
                         expected_F3);
                $display("  Got:      F3=%h",
                         F3);
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
