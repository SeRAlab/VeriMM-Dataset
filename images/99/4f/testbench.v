`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ALUop;
    reg [31:0] OpA;
    reg [31:0] OpB;
    wire [31:0] ALUResult;
    wire Zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUop(ALUop),
        .OpA(OpA),
        .OpB(OpB),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition (15 + 27)", test_num);
        ALUop = 4'd0; OpA = 32'd15; OpB = 32'd27;
        #1;

        check_outputs(32'd42, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction - Non-Zero Result", test_num);
        ALUop = 4'd1; OpA = 32'd100; OpB = 32'd40;
        #1;

        check_outputs(32'd60, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction - Zero Result (Zero Flag Check)", test_num);
        ALUop = 4'd1; OpA = 32'd55; OpB = 32'd55;
        #1;

        check_outputs(32'd0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplication (12 * 11)", test_num);
        ALUop = 4'd2; OpA = 32'd12; OpB = 32'd11;
        #1;

        check_outputs(32'd132, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise AND", test_num);
        ALUop = 4'd3; OpA = 32'hAAAAAAAA; OpB = 32'hFFFF0000;
        #1;

        check_outputs(32'hAAAA0000, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise OR", test_num);
        ALUop = 4'd4; OpA = 32'h12340000; OpB = 32'h00005678;
        #1;

        check_outputs(32'h12345678, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise XOR", test_num);
        ALUop = 4'd5; OpA = 32'hFFFFFFFF; OpB = 32'h0F0F0F0F;
        #1;

        check_outputs(32'hF0F0F0F0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise NOR", test_num);
        ALUop = 4'd6; OpA = 32'h0; OpB = 32'h0;
        #1;

        check_outputs(32'hFFFFFFFF, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition Overflow Wrap", test_num);
        ALUop = 4'd0; OpA = 32'hFFFFFFFF; OpB = 32'h00000001;
        #1;

        check_outputs(32'h00000000, 1'b0);
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
        input [31:0] expected_ALUResult;
        input expected_Zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUResult === (expected_ALUResult ^ ALUResult ^ expected_ALUResult) &&
                expected_Zero === (expected_Zero ^ Zero ^ expected_Zero)) begin
                $display("PASS");
                $display("  Outputs: ALUResult=%h, Zero=%b",
                         ALUResult, Zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUResult=%h, Zero=%b",
                         expected_ALUResult, expected_Zero);
                $display("  Got:      ALUResult=%h, Zero=%b",
                         ALUResult, Zero);
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
