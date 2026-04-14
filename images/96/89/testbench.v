`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] FuncCode;
    reg [3:0] OpCode;
    wire IFIDImmd;
    wire IFIDMemRead;
    wire IFIDMemWrite;
    wire [1:0] IFIDRegWrite;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .FuncCode(FuncCode),
        .OpCode(OpCode),
        .IFIDImmd(IFIDImmd),
        .IFIDMemRead(IFIDMemRead),
        .IFIDMemWrite(IFIDMemWrite),
        .IFIDRegWrite(IFIDRegWrite)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: OpCode 8 (Memory Read)", test_num);
        OpCode = 4'd8;
        FuncCode = 4'd0;

        #1;


        check_outputs(1'b1, 1'b1, 1'b0, 2'b01);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: OpCode 11 (Memory Write)", test_num);
        OpCode = 4'd11;
        FuncCode = 4'd0;

        #1;


        check_outputs(1'b1, 1'b0, 1'b1, 2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: OpCode 0 (R-Type)", test_num);
        OpCode = 4'd0;
        FuncCode = 4'd5;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: OpCode 9 (I-Type Arithmetic)", test_num);
        OpCode = 4'd9;
        FuncCode = 4'd0;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 2'b01);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: OpCode 7 (Boundary check)", test_num);
        OpCode = 4'd7;
        FuncCode = 4'd2;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 2'b01);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: OpCode 15 (Max OpCode)", test_num);
        OpCode = 4'd15;
        FuncCode = 4'd15;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 2'b00);
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
        input expected_IFIDImmd;
        input expected_IFIDMemRead;
        input expected_IFIDMemWrite;
        input [1:0] expected_IFIDRegWrite;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_IFIDImmd === (expected_IFIDImmd ^ IFIDImmd ^ expected_IFIDImmd) &&
                expected_IFIDMemRead === (expected_IFIDMemRead ^ IFIDMemRead ^ expected_IFIDMemRead) &&
                expected_IFIDMemWrite === (expected_IFIDMemWrite ^ IFIDMemWrite ^ expected_IFIDMemWrite) &&
                expected_IFIDRegWrite === (expected_IFIDRegWrite ^ IFIDRegWrite ^ expected_IFIDRegWrite)) begin
                $display("PASS");
                $display("  Outputs: IFIDImmd=%b, IFIDMemRead=%b, IFIDMemWrite=%b, IFIDRegWrite=%h",
                         IFIDImmd, IFIDMemRead, IFIDMemWrite, IFIDRegWrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IFIDImmd=%b, IFIDMemRead=%b, IFIDMemWrite=%b, IFIDRegWrite=%h",
                         expected_IFIDImmd, expected_IFIDMemRead, expected_IFIDMemWrite, expected_IFIDRegWrite);
                $display("  Got:      IFIDImmd=%b, IFIDMemRead=%b, IFIDMemWrite=%b, IFIDRegWrite=%h",
                         IFIDImmd, IFIDMemRead, IFIDMemWrite, IFIDRegWrite);
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
