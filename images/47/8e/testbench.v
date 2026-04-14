`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ALU_Ctrl;
    reg [15:0] Source1;
    reg [15:0] Source2;
    wire [15:0] Result;
    wire Zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_Ctrl(ALU_Ctrl),
        .Source1(Source1),
        .Source2(Source2),
        .Result(Result),
        .Zero(Zero)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Addition (5 + 10)", test_num);
        ALU_Ctrl = 4'b0010;
        Source1 = 16'd5;
        Source2 = 16'd10;
        #1;

        check_outputs(16'd15, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Addition Overflow (FFFF + 1)", test_num);
        ALU_Ctrl = 4'b0010;
        Source1 = 16'hFFFF;
        Source2 = 16'h0001;
        #1;

        check_outputs(16'h0000, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Subtraction (20 - 5)", test_num);
        ALU_Ctrl = 4'b0100;
        Source1 = 16'd20;
        Source2 = 16'd5;
        #1;

        check_outputs(16'd15, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Subtraction Result Zero (10 - 10)", test_num);
        ALU_Ctrl = 4'b0100;
        Source1 = 16'd10;
        Source2 = 16'd10;
        #1;

        check_outputs(16'h0000, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Less Than Comparison (5 < 10)", test_num);
        ALU_Ctrl = 4'b0001;
        Source1 = 16'd5;
        Source2 = 16'd10;
        #1;

        check_outputs(16'h0001, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Less Than Comparison (10 < 5)", test_num);
        ALU_Ctrl = 4'b0001;
        Source1 = 16'd10;
        Source2 = 16'd5;
        #1;

        check_outputs(16'h0000, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Less Than Comparison Equal (5 < 5)", test_num);
        ALU_Ctrl = 4'b0001;
        Source1 = 16'd5;
        Source2 = 16'd5;
        #1;

        check_outputs(16'h0000, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Zero Flag Inequality Check", test_num);
        ALU_Ctrl = 4'b0010;
        Source1 = 16'hABCD;
        Source2 = 16'h1234;
        #1;

        check_outputs(16'hBE01, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Subtraction Negative Result (5 - 10)", test_num);
        ALU_Ctrl = 4'b0100;
        Source1 = 16'd5;
        Source2 = 16'd10;
        #1;

        check_outputs(16'hFFF6, 1'b0);
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
        input [15:0] expected_Result;
        input expected_Zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Result === (expected_Result ^ Result ^ expected_Result) &&
                expected_Zero === (expected_Zero ^ Zero ^ expected_Zero)) begin
                $display("PASS");
                $display("  Outputs: Result=%h, Zero=%b",
                         Result, Zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Result=%h, Zero=%b",
                         expected_Result, expected_Zero);
                $display("  Got:      Result=%h, Zero=%b",
                         Result, Zero);
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
