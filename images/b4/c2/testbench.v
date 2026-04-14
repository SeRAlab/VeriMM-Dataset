`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ALUOp;
    reg [5:0] func;
    wire [2:0] operALU;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOp(ALUOp),
        .func(func),
        .operALU(operALU)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALUOp=00 (Predefined - Addition expected)", test_num);
        ALUOp = 2'b00;
        func = 6'b000000;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALUOp=01 (Predefined - Subtraction expected)", test_num);
        ALUOp = 2'b01;
        func = 6'b000000;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALUOp=11, func=100000 (Addition)", test_num);
        ALUOp = 2'b11;
        func = 6'b100000;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALUOp=11, func=100010 (Subtraction)", test_num);
        ALUOp = 2'b11;
        func = 6'b100010;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALUOp=11, func=100100 (Bitwise AND)", test_num);
        ALUOp = 2'b11;
        func = 6'b100100;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALUOp=11, func=100101 (Bitwise OR)", test_num);
        ALUOp = 2'b11;
        func = 6'b100101;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALUOp=11, func=101010 (Set Less Than)", test_num);
        ALUOp = 2'b11;
        func = 6'b101010;
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
        input [2:0] expected_operALU;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_operALU === (expected_operALU ^ operALU ^ expected_operALU)) begin
                $display("PASS");
                $display("  Outputs: operALU=%h",
                         operALU);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: operALU=%h",
                         expected_operALU);
                $display("  Got:      operALU=%h",
                         operALU);
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
