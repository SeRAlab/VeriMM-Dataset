`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] funCode;
    reg [3:0] opCode;
    wire [2:0] aluOp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .funCode(funCode),
        .opCode(opCode),
        .aluOp(aluOp)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: R-type ADD (opCode=0, funCode=0)", test_num);
            opCode = 4'b0000;
            funCode = 4'b0000;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: R-type SUB (opCode=0, funCode=1)", test_num);
            opCode = 4'b0000;
            funCode = 4'b0001;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: LW Instruction (opCode=4)", test_num);
            opCode = 4'b0100;
            funCode = 4'b1111;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: BEQ Instruction (opCode=8)", test_num);
            opCode = 4'b1000;
            funCode = 4'b0000;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Undefined OpCode Fallback", test_num);
            opCode = 4'b1111;
            funCode = 4'b1111;
            #1;

            check_outputs(3'b000);
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
        input [2:0] expected_aluOp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_aluOp === (expected_aluOp ^ aluOp ^ expected_aluOp)) begin
                $display("PASS");
                $display("  Outputs: aluOp=%h",
                         aluOp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluOp=%h",
                         expected_aluOp);
                $display("  Got:      aluOp=%h",
                         aluOp);
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
