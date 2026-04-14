`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ALUOp;
    reg [3:0] Opcode;
    wire [2:0] ALU_Cnt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOp(ALUOp),
        .Opcode(Opcode),
        .ALU_Cnt(ALU_Cnt)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ALUOp=00 (Load/Store) - Expected: 010", test_num);
        ALUOp = 2'b00;
        Opcode = 4'b0000;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ALUOp=01 (Branch) - Expected: 110", test_num);
        ALUOp = 2'b01;
        Opcode = 4'b0000;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ALUOp=10, Opcode=0000 (R-type ADD) - Expected: 010", test_num);
        ALUOp = 2'b10;
        Opcode = 4'b0000;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ALUOp=10, Opcode=0010 (R-type SUB) - Expected: 110", test_num);
        ALUOp = 2'b10;
        Opcode = 4'b0010;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ALUOp=10, Opcode=0100 (R-type AND) - Expected: 000", test_num);
        ALUOp = 2'b10;
        Opcode = 4'b0100;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ALUOp=10, Opcode=0101 (R-type OR) - Expected: 001", test_num);
        ALUOp = 2'b10;
        Opcode = 4'b0101;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ALUOp=10, Opcode=1010 (R-type SLT) - Expected: 111", test_num);
        ALUOp = 2'b10;
        Opcode = 4'b1010;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ALUOp=00 with different Opcode (Should still be 010)", test_num);
        ALUOp = 2'b00;
        Opcode = 4'b1111;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ALUOp=01 with different Opcode (Should still be 110)", test_num);
        ALUOp = 2'b01;
        Opcode = 4'b1010;
        #1;

        check_outputs(3'b110);
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
        input [2:0] expected_ALU_Cnt;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_Cnt === (expected_ALU_Cnt ^ ALU_Cnt ^ expected_ALU_Cnt)) begin
                $display("PASS");
                $display("  Outputs: ALU_Cnt=%h",
                         ALU_Cnt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_Cnt=%h",
                         expected_ALU_Cnt);
                $display("  Got:      ALU_Cnt=%h",
                         ALU_Cnt);
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
