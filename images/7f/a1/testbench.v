`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] ALUOp_i;
    reg [5:0] funct_i;
    wire [3:0] ALU_operation_o;
    wire [1:0] FURslt_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOp_i(ALUOp_i),
        .funct_i(funct_i),
        .ALU_operation_o(ALU_operation_o),
        .FURslt_o(FURslt_o)
    );
    task testcase001;

        begin
            test_num = 1;
            ALUOp_i = 3'b000;
            funct_i = 6'bxxxxxx;
            $display("Test %0d: ALUOp=000 (Load/Store - Expected ADD)", test_num);
            #1;

            check_outputs(4'b0010, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            ALUOp_i = 3'b001;
            funct_i = 6'bxxxxxx;
            $display("Test %0d: ALUOp=001 (Branch - Expected SUB)", test_num);
            #1;

            check_outputs(4'b0110, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            ALUOp_i = 3'b010;
            funct_i = 6'b100000;
            $display("Test %0d: R-type ADD (funct 0x20)", test_num);
            #1;

            check_outputs(4'b0010, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            ALUOp_i = 3'b010;
            funct_i = 6'b100010;
            $display("Test %0d: R-type SUB (funct 0x22)", test_num);
            #1;

            check_outputs(4'b0110, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            ALUOp_i = 3'b010;
            funct_i = 6'b100100;
            $display("Test %0d: R-type AND (funct 0x24)", test_num);
            #1;

            check_outputs(4'b0000, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            ALUOp_i = 3'b010;
            funct_i = 6'b100101;
            $display("Test %0d: R-type OR (funct 0x25)", test_num);
            #1;

            check_outputs(4'b0001, 2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            ALUOp_i = 3'b010;
            funct_i = 6'b101010;
            $display("Test %0d: R-type SLT (funct 0x2A)", test_num);
            #1;

            check_outputs(4'b0111, 2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            ALUOp_i = 3'b011;
            funct_i = 6'b000000;
            $display("Test %0d: ALUOp=011 (ORI instruction)", test_num);
            #1;

            check_outputs(4'b0001, 2'b00);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            ALUOp_i = 3'b100;
            funct_i = 6'b000000;
            $display("Test %0d: ALUOp=100 (ANDI instruction)", test_num);
            #1;

            check_outputs(4'b0000, 2'b00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            ALUOp_i = 3'b000;
            funct_i = 6'b100010;
            $display("Test %0d: ALUOp=000 with SUB funct code (Should still be ADD)", test_num);
            #1;

            check_outputs(4'b0010, 2'b00);
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
        input [3:0] expected_ALU_operation_o;
        input [1:0] expected_FURslt_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_operation_o === (expected_ALU_operation_o ^ ALU_operation_o ^ expected_ALU_operation_o) &&
                expected_FURslt_o === (expected_FURslt_o ^ FURslt_o ^ expected_FURslt_o)) begin
                $display("PASS");
                $display("  Outputs: ALU_operation_o=%h, FURslt_o=%h",
                         ALU_operation_o, FURslt_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_operation_o=%h, FURslt_o=%h",
                         expected_ALU_operation_o, expected_FURslt_o);
                $display("  Got:      ALU_operation_o=%h, FURslt_o=%h",
                         ALU_operation_o, FURslt_o);
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
