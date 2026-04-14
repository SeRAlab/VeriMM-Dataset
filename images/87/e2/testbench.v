`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ExtType;
    reg [15:0] imm16;
    wire [31:0] imm32;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ExtType(ExtType),
        .imm16(imm16),
        .imm32(imm32)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Zero-extension with MSB=0 (ExtType=0)", test_num);
        imm16 = 16'h5A5A;
        ExtType = 0;
        #1;

        check_outputs(32'h00005A5A);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Zero-extension with MSB=1 (ExtType=0)", test_num);
        imm16 = 16'hA5A5;
        ExtType = 0;
        #1;

        check_outputs(32'h0000A5A5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Sign-extension mode with MSB=0 (ExtType=1)", test_num);
        imm16 = 16'h7FFF;
        ExtType = 1;
        #1;

        check_outputs(32'h00007FFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Sign-extension mode with MSB=1 (ExtType=1)", test_num);
        imm16 = 16'h8001;
        ExtType = 1;
        #1;

        check_outputs(32'hFFFF8001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Zero-extension of 16'hFFFF (ExtType=0)", test_num);
        imm16 = 16'hFFFF;
        ExtType = 0;
        #1;

        check_outputs(32'h0000FFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Sign-extension of 16'hFFFF (ExtType=1)", test_num);
        imm16 = 16'hFFFF;
        ExtType = 1;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Zero value with ExtType=1", test_num);
        imm16 = 16'h0000;
        ExtType = 1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Arbitrary value with MSB=1 and ExtType=1", test_num);
        imm16 = 16'hBEEF;
        ExtType = 1;
        #1;

        check_outputs(32'hFFFFBEEF);
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
