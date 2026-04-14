`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ExtOp;
    reg [15:0] imm16;
    wire [31:0] imm32;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ExtOp(ExtOp),
        .imm16(imm16),
        .imm32(imm32)
    );
    task testcase001;

    begin
        test_num = 1;
        ExtOp = 2'b00;
        imm16 = 16'h1234;
        $display("Test Case 001: Sign Extension - Positive Value");
        #1;

        check_outputs(32'h00001234);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        ExtOp = 2'b00;
        imm16 = 16'h8001;
        $display("Test Case 002: Sign Extension - Negative Value");
        #1;

        check_outputs(32'hFFFF8001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        ExtOp = 2'b00;
        imm16 = 16'hFFFF;
        $display("Test Case 003: Sign Extension - All Ones");
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        ExtOp = 2'b01;
        imm16 = 16'h1234;
        $display("Test Case 004: Zero Extension Prepend - Positive Value");
        #1;

        check_outputs(32'h00001234);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        ExtOp = 2'b01;
        imm16 = 16'hABCD;
        $display("Test Case 005: Zero Extension Prepend - MSB is 1");
        #1;

        check_outputs(32'h0000ABCD);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        ExtOp = 2'b10;
        imm16 = 16'h1234;
        $display("Test Case 006: Zero Extension Append (Shift Left 16)");
        #1;

        check_outputs(32'h12340000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        ExtOp = 2'b10;
        imm16 = 16'hF00F;
        $display("Test Case 007: Zero Extension Append - Negative Input MSB");
        #1;

        check_outputs(32'hF00F0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        ExtOp = 2'b00;
        imm16 = 16'h0000;
        $display("Test Case 008: Sign Extension - All Zeros");
        #1;

        check_outputs(32'h00000000);
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
        input [31:0] expected_imm32;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_imm32 === (expected_imm32 ^ imm32 ^ expected_imm32)) begin
                $display("PASS");
                $display("  Outputs: imm32=%h",
                         imm32);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: imm32=%h",
                         expected_imm32);
                $display("  Got:      imm32=%h",
                         imm32);
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
