`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [3:0] ALUctl;
    reg [31:0] B;
    wire [31:0] ALUOut;
    wire Zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .ALUctl(ALUctl),
        .B(B),
        .ALUOut(ALUOut),
        .Zero(Zero)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise AND", test_num);
        ALUctl = 4'b0000; A = 32'hF0F0AAAA; B = 32'h0F0F5555;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise OR", test_num);
        ALUctl = 4'b0001; A = 32'hF0F0AAAA; B = 32'h0F0F5555;
        #1;

        check_outputs(32'hFFFFFFFF, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (Positive)", test_num);
        ALUctl = 4'b0010; A = 32'd150; B = 32'd50;
        #1;

        check_outputs(32'd200, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication", test_num);
        ALUctl = 4'b0011; A = 32'd12; B = 32'd5;
        #1;

        check_outputs(32'd60, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (Result Zero)", test_num);
        ALUctl = 4'b0110; A = 32'd1000; B = 32'd1000;
        #1;

        check_outputs(32'd0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (Negative Result)", test_num);
        ALUctl = 4'b0110; A = 32'd50; B = 32'd150;
        #1;

        check_outputs(-32'd100, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SLT (True: Negative < Positive)", test_num);
        ALUctl = 4'b0111; A = -32'd1; B = 32'd1;
        #1;

        check_outputs(32'd1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SLT (False: Positive > Negative)", test_num);
        ALUctl = 4'b0111; A = 32'd5; B = -32'd10;
        #1;

        check_outputs(32'd0, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise NOR", test_num);
        ALUctl = 4'b1100; A = 32'h0000FFFF; B = 32'h00000000;
        #1;

        check_outputs(32'hFFFF0000, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Default Case (ALUOut = 0)", test_num);
        ALUctl = 4'b1111; A = 32'hFFFFFFFF; B = 32'hFFFFFFFF;
        #1;

        check_outputs(32'd0, 1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (Max Positive + 1)", test_num);
        ALUctl = 4'b0010; A = 32'h7FFFFFFF; B = 32'h00000001;
        #1;

        check_outputs(32'h80000000, 1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication by Zero", test_num);
        ALUctl = 4'b0011; A = 32'hABCD1234; B = 32'd0;
        #1;

        check_outputs(32'd0, 1'b1);
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
        testcase012();
        
        
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
        input [31:0] expected_ALUOut;
        input expected_Zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUOut === (expected_ALUOut ^ ALUOut ^ expected_ALUOut) &&
                expected_Zero === (expected_Zero ^ Zero ^ expected_Zero)) begin
                $display("PASS");
                $display("  Outputs: ALUOut=%h, Zero=%b",
                         ALUOut, Zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUOut=%h, Zero=%b",
                         expected_ALUOut, expected_Zero);
                $display("  Got:      ALUOut=%h, Zero=%b",
                         ALUOut, Zero);
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
