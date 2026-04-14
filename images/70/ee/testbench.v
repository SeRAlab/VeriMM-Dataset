`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ALU_Control;
    reg [31:0] ALU_in0;
    reg [31:0] ALU_in1;
    wire [31:0] ALU_result;
    wire Zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_Control(ALU_Control),
        .ALU_in0(ALU_in0),
        .ALU_in1(ALU_in1),
        .ALU_result(ALU_result),
        .Zero(Zero)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Bitwise AND", test_num);
        ALU_Control = 4'b0000;
        ALU_in0 = 32'hAAAA5555;
        ALU_in1 = 32'hF0F0F0F0;

        #1;


        check_outputs(32'hA0A05050, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Bitwise OR", test_num);
        ALU_Control = 4'b0001;
        ALU_in0 = 32'hAAAA5555;
        ALU_in1 = 32'hF0F0F0F0;

        #1;


        check_outputs(32'hFAFAF5F5, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Addition (Positive)", test_num);
        ALU_Control = 4'b0010;
        ALU_in0 = 32'd1000;
        ALU_in1 = 32'd2500;

        #1;


        check_outputs(32'd3500, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Addition (Zero Result)", test_num);
        ALU_Control = 4'b0010;
        ALU_in0 = 32'hFFFFFFFF;
        ALU_in1 = 32'h00000001;

        #1;


        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Subtraction (Positive Result)", test_num);
        ALU_Control = 4'b0110;
        ALU_in0 = 32'd5000;
        ALU_in1 = 32'd2000;

        #1;


        check_outputs(32'd3000, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Subtraction (Result 0)", test_num);
        ALU_Control = 4'b0110;
        ALU_in0 = 32'h7FFFFFFF;
        ALU_in1 = 32'h7FFFFFFF;

        #1;


        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: SLT (True, 5 < 10)", test_num);
        ALU_Control = 4'b0111;
        ALU_in0 = 32'd5;
        ALU_in1 = 32'd10;

        #1;


        check_outputs(32'h00000001, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: SLT (False, 10 < 5)", test_num);
        ALU_Control = 4'b0111;
        ALU_in0 = 32'd10;
        ALU_in1 = 32'd5;

        #1;


        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTestcase %0d: SLT (Signed Negative)", test_num);
        ALU_Control = 4'b0111;
        ALU_in0 = 32'hFFFFFFFB;
        ALU_in1 = 32'h00000002;

        #1;


        check_outputs(32'h00000001, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTestcase %0d: Bitwise NOR", test_num);
        ALU_Control = 4'b1100;
        ALU_in0 = 32'h0000FFFF;
        ALU_in1 = 32'h00000000;

        #1;


        check_outputs(32'hFFFF0000, 1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("\nTestcase %0d: Bitwise NOR (Zero Result)", test_num);
        ALU_Control = 4'b1100;
        ALU_in0 = 32'hFFFFFFFF;
        ALU_in1 = 32'hFFFFFFFF;

        #1;


        check_outputs(32'h00000000, 1'b1);
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
        testcase010();
        testcase011();
        
        
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
        input [31:0] expected_ALU_result;
        input expected_Zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_result === (expected_ALU_result ^ ALU_result ^ expected_ALU_result) &&
                expected_Zero === (expected_Zero ^ Zero ^ expected_Zero)) begin
                $display("PASS");
                $display("  Outputs: ALU_result=%h, Zero=%b",
                         ALU_result, Zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_result=%h, Zero=%b",
                         expected_ALU_result, expected_Zero);
                $display("  Got:      ALU_result=%h, Zero=%b",
                         ALU_result, Zero);
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
