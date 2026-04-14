`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] ALUResult_In_FromMem;
    reg Condition_In_FromMem;
    reg [15:0] PCInc_In_FromMem;
    reg [15:0] ReadData_In_FromMem;
    reg [1:0] RegWriteDataSel_In_FromMem;
    reg [2:0] WR_In_FromMem;
    wire [15:0] WD_Out_ToMem;
    wire [2:0] WR_Out_ToMem;
    wire err;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUResult_In_FromMem(ALUResult_In_FromMem),
        .Condition_In_FromMem(Condition_In_FromMem),
        .PCInc_In_FromMem(PCInc_In_FromMem),
        .ReadData_In_FromMem(ReadData_In_FromMem),
        .RegWriteDataSel_In_FromMem(RegWriteDataSel_In_FromMem),
        .WR_In_FromMem(WR_In_FromMem),
        .WD_Out_ToMem(WD_Out_ToMem),
        .WR_Out_ToMem(WR_Out_ToMem),
        .err(err)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Select PC Increment (Sel=00)", test_num);
        RegWriteDataSel_In_FromMem = 2'b00;
        PCInc_In_FromMem = 16'h1234;
        Condition_In_FromMem = 1'b1;
        ReadData_In_FromMem = 16'hABCD;
        ALUResult_In_FromMem = 16'h55AA;
        WR_In_FromMem = 3'b001;


        #1;



        check_outputs(16'h1234, 3'b001, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Select Condition Signal - True (Sel=01)", test_num);
        RegWriteDataSel_In_FromMem = 2'b01;
        PCInc_In_FromMem = 16'h1111;
        Condition_In_FromMem = 1'b1;
        ReadData_In_FromMem = 16'h2222;
        ALUResult_In_FromMem = 16'h3333;
        WR_In_FromMem = 3'b010;


        #1;



        check_outputs(16'h0001, 3'b010, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Select Condition Signal - False (Sel=01)", test_num);
        RegWriteDataSel_In_FromMem = 2'b01;
        PCInc_In_FromMem = 16'h1111;
        Condition_In_FromMem = 1'b0;
        ReadData_In_FromMem = 16'h2222;
        ALUResult_In_FromMem = 16'h3333;
        WR_In_FromMem = 3'b011;


        #1;



        check_outputs(16'h0000, 3'b011, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Select Memory Read Data (Sel=10)", test_num);
        RegWriteDataSel_In_FromMem = 2'b10;
        PCInc_In_FromMem = 16'hAAAA;
        Condition_In_FromMem = 1'b1;
        ReadData_In_FromMem = 16'hBEEF;
        ALUResult_In_FromMem = 16'hCCCC;
        WR_In_FromMem = 3'b100;


        #1;



        check_outputs(16'hBEEF, 3'b100, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Select ALU Result (Sel=11)", test_num);
        RegWriteDataSel_In_FromMem = 2'b11;
        PCInc_In_FromMem = 16'h0000;
        Condition_In_FromMem = 1'b0;
        ReadData_In_FromMem = 16'hFFFF;
        ALUResult_In_FromMem = 16'h789A;
        WR_In_FromMem = 3'b111;


        #1;



        check_outputs(16'h789A, 3'b111, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Verify Write Register Identifier Passthrough", test_num);
        RegWriteDataSel_In_FromMem = 2'b00;
        PCInc_In_FromMem = 16'h600D;
        Condition_In_FromMem = 1'b1;
        ReadData_In_FromMem = 16'h0000;
        ALUResult_In_FromMem = 16'h0000;
        WR_In_FromMem = 3'b101;


        #1;



        check_outputs(16'h600D, 3'b101, 1'b0);
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
        input [15:0] expected_WD_Out_ToMem;
        input [2:0] expected_WR_Out_ToMem;
        input expected_err;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_WD_Out_ToMem === (expected_WD_Out_ToMem ^ WD_Out_ToMem ^ expected_WD_Out_ToMem) &&
                expected_WR_Out_ToMem === (expected_WR_Out_ToMem ^ WR_Out_ToMem ^ expected_WR_Out_ToMem) &&
                expected_err === (expected_err ^ err ^ expected_err)) begin
                $display("PASS");
                $display("  Outputs: WD_Out_ToMem=%h, WR_Out_ToMem=%h, err=%b",
                         WD_Out_ToMem, WR_Out_ToMem, err);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: WD_Out_ToMem=%h, WR_Out_ToMem=%h, err=%b",
                         expected_WD_Out_ToMem, expected_WR_Out_ToMem, expected_err);
                $display("  Got:      WD_Out_ToMem=%h, WR_Out_ToMem=%h, err=%b",
                         WD_Out_ToMem, WR_Out_ToMem, err);
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
