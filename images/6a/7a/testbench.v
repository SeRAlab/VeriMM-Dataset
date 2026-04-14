`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ExtSel;
    reg [15:0] imm16;
    wire [31:0] imm32;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ExtSel(ExtSel),
        .imm16(imm16),
        .imm32(imm32)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Extension - Positive Value (imm16=0x1234, ExtSel=0)", test_num);
        imm16 = 16'h1234;
        ExtSel = 1'b0;
        #1;

        check_outputs(32'h00001234);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Extension - MSB is 1 (imm16=0xABCD, ExtSel=0)", test_num);
        imm16 = 16'hABCD;
        ExtSel = 1'b0;
        #1;

        check_outputs(32'h0000ABCD);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sign Extension - MSB is 0 (imm16=0x7FFF, ExtSel=1)", test_num);
        imm16 = 16'h7FFF;
        ExtSel = 1'b1;
        #1;

        check_outputs(32'h00007FFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sign Extension - MSB is 1 (imm16=0x8000, ExtSel=1)", test_num);
        imm16 = 16'h8000;
        ExtSel = 1'b1;
        #1;

        check_outputs(32'hFFFF8000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary - All Zeros, ExtSel=0", test_num);
        imm16 = 16'h0000;
        ExtSel = 1'b0;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary - All Zeros, ExtSel=1", test_num);
        imm16 = 16'h0000;
        ExtSel = 1'b1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary - All Ones, ExtSel=0", test_num);
        imm16 = 16'hFFFF;
        ExtSel = 1'b0;
        #1;

        check_outputs(32'h0000FFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary - All Ones, ExtSel=1", test_num);
        imm16 = 16'hFFFF;
        ExtSel = 1'b1;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating Bits (0xAAAA), ExtSel=0", test_num);
        imm16 = 16'hAAAA;
        ExtSel = 1'b0;
        #1;

        check_outputs(32'h0000AAAA);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating Bits (0xAAAA), ExtSel=1", test_num);
        imm16 = 16'hAAAA;
        ExtSel = 1'b1;
        #1;

        check_outputs(32'hFFFFAAAA);
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
