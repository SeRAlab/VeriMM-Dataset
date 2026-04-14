`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ALUOp;
    reg [3:0] Func;
    wire [3:0] Operation;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOp(ALUOp),
        .Func(Func),
        .Operation(Operation)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: ALUOp = 00 (Load/Store), Expect Operation = 0010 (ADD)", test_num);
        ALUOp = 2'b00;
        Func = 4'b0000;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: ALUOp = 01 (Branch), Expect Operation = 0110 (SUB)", test_num);
        ALUOp = 2'b01;
        Func = 4'b0000;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: ALUOp = 10, Func = 0000 (R-type ADD), Expect Operation = 0010", test_num);
        ALUOp = 2'b10;
        Func = 4'b0000;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: ALUOp = 10, Func = 0010 (R-type SUB), Expect Operation = 0110", test_num);
        ALUOp = 2'b10;
        Func = 4'b0010;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: ALUOp = 10, Func = 0100 (R-type AND), Expect Operation = 0000", test_num);
        ALUOp = 2'b10;
        Func = 4'b0100;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: ALUOp = 10, Func = 0101 (R-type OR), Expect Operation = 0001", test_num);
        ALUOp = 2'b10;
        Func = 4'b0101;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: ALUOp = 10, Func = 1010 (R-type SLT), Expect Operation = 0111", test_num);
        ALUOp = 2'b10;
        Func = 4'b1010;
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Verifying MSB (Operation[3]) is always 0", test_num);
        ALUOp = 2'b11;
        Func = 4'b1111;
        #1;
        if (Operation[3] === 1'b0) begin
            $display("PASS: Operation[3] is 0");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Operation[3] is not 0");
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
        input [3:0] expected_Operation;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Operation === (expected_Operation ^ Operation ^ expected_Operation)) begin
                $display("PASS");
                $display("  Outputs: Operation=%h",
                         Operation);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Operation=%h",
                         expected_Operation);
                $display("  Got:      Operation=%h",
                         Operation);
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
