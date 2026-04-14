`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] aluop_i;
    reg [5:0] funct_i;
    wire [2:0] aluctrl_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aluop_i(aluop_i),
        .funct_i(funct_i),
        .aluctrl_o(aluctrl_o)
    );
    task testcase001;

    begin
        test_num = 1;
        aluop_i = 2'b00;
        funct_i = 6'bXXXXXX;
        $display("Test %0d: ALUOp=00 (LW/SW) -> Expected: 010", test_num);
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        aluop_i = 2'b01;
        funct_i = 6'bXXXXXX;
        $display("Test %0d: ALUOp=01 (BEQ) -> Expected: 110", test_num);
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        aluop_i = 2'b10;
        funct_i = 6'b100000;
        $display("Test %0d: ALUOp=10, Funct=100000 (ADD) -> Expected: 010", test_num);
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        aluop_i = 2'b10;
        funct_i = 6'b100010;
        $display("Test %0d: ALUOp=10, Funct=100010 (SUB) -> Expected: 110", test_num);
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        aluop_i = 2'b10;
        funct_i = 6'b100100;
        $display("Test %0d: ALUOp=10, Funct=100100 (AND) -> Expected: 000", test_num);
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        aluop_i = 2'b10;
        funct_i = 6'b100101;
        $display("Test %0d: ALUOp=10, Funct=100101 (OR) -> Expected: 001", test_num);
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        aluop_i = 2'b10;
        funct_i = 6'b101010;
        $display("Test %0d: ALUOp=10, Funct=101010 (SLT) -> Expected: 111", test_num);
        #1;

        check_outputs(3'b111);
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
        input [2:0] expected_aluctrl_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_aluctrl_o === (expected_aluctrl_o ^ aluctrl_o ^ expected_aluctrl_o)) begin
                $display("PASS");
                $display("  Outputs: aluctrl_o=%h",
                         aluctrl_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluctrl_o=%h",
                         expected_aluctrl_o);
                $display("  Got:      aluctrl_o=%h",
                         aluctrl_o);
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
