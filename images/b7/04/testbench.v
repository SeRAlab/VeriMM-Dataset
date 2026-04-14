`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] aluOp;
    reg [5:0] instructionCodeHighBits;
    reg [5:0] instructionCodeLowBits;
    wire [3:0] aluOperation;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aluOp(aluOp),
        .instructionCodeHighBits(instructionCodeHighBits),
        .instructionCodeLowBits(instructionCodeLowBits),
        .aluOperation(aluOperation)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: ALU Op 00 (Load/Store)", test_num);
        aluOp = 2'b00;
        instructionCodeHighBits = 6'b000000;
        instructionCodeLowBits = 6'b000000;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: ALU Op 01 (Branch)", test_num);
        aluOp = 2'b01;
        instructionCodeHighBits = 6'b000000;
        instructionCodeLowBits = 6'b000000;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: R-type ADD (Op 10, Funct 32)", test_num);
        aluOp = 2'b10;
        instructionCodeHighBits = 6'b000000;
        instructionCodeLowBits = 6'd32;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: R-type SUB (Op 10, Funct 34)", test_num);
        aluOp = 2'b10;
        instructionCodeHighBits = 6'b000000;
        instructionCodeLowBits = 6'd34;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: R-type AND (Op 10, Funct 36)", test_num);
        aluOp = 2'b10;
        instructionCodeHighBits = 6'b000000;
        instructionCodeLowBits = 6'd36;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: R-type OR (Op 10, Funct 37)", test_num);
        aluOp = 2'b10;
        instructionCodeHighBits = 6'b000000;
        instructionCodeLowBits = 6'd37;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: R-type SLT (Op 10, Funct 42)", test_num);
        aluOp = 2'b10;
        instructionCodeHighBits = 6'b000000;
        instructionCodeLowBits = 6'd42;
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: R-type Add with High Bits set", test_num);
        aluOp = 2'b10;
        instructionCodeHighBits = 6'b111111;
        instructionCodeLowBits = 6'd32;
        #1;

        check_outputs(4'b0010);
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
        input [3:0] expected_aluOperation;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_aluOperation === (expected_aluOperation ^ aluOperation ^ expected_aluOperation)) begin
                $display("PASS");
                $display("  Outputs: aluOperation=%h",
                         aluOperation);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluOperation=%h",
                         expected_aluOperation);
                $display("  Got:      aluOperation=%h",
                         aluOperation);
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
