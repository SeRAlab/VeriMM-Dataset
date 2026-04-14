`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ALUOp;
    reg [5:0] Func;
    wire [2:0] Op;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOp(ALUOp),
        .Func(Func),
        .Op(Op)
    );
    task testcase001;

    begin
        ALUOp = 2'b00;
        Func = 6'b111111;
        $display("Test Case 001: ALUOp 00 (Load/Store) - Expect Op 010");
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase002;

    begin
        ALUOp = 2'b01;
        Func = 6'b000000;
        $display("Test Case 002: ALUOp 01 (Branch) - Expect Op 110");
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase003;

    begin
        ALUOp = 2'b10;
        Func = 6'b100000;
        $display("Test Case 003: R-type ADD (ALUOp 10, Func 100000) - Expect Op 010");
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        ALUOp = 2'b10;
        Func = 6'b100010;
        $display("Test Case 004: R-type SUB (ALUOp 10, Func 100010) - Expect Op 110");
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase005;

    begin
        ALUOp = 2'b10;
        Func = 6'b100100;
        $display("Test Case 005: R-type AND (ALUOp 10, Func 100100) - Expect Op 000");
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase006;

    begin
        ALUOp = 2'b10;
        Func = 6'b100101;
        $display("Test Case 006: R-type OR (ALUOp 10, Func 100101) - Expect Op 001");
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase007;

    begin
        ALUOp = 2'b10;
        Func = 6'b101010;
        $display("Test Case 007: R-type SLT (ALUOp 10, Func 101010) - Expect Op 111");
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase008;

    begin
        ALUOp = 2'b00;
        Func = 6'b100101;
        $display("Test Case 008: ALUOp 00 (Ignoring Func) - Expect Op 010");
        #1;

        check_outputs(3'b010);
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
        input [2:0] expected_Op;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Op === (expected_Op ^ Op ^ expected_Op)) begin
                $display("PASS");
                $display("  Outputs: Op=%h",
                         Op);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Op=%h",
                         expected_Op);
                $display("  Got:      Op=%h",
                         Op);
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
