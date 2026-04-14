`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] EXTOp;
    reg [15:0] Imm16;
    wire [31:0] Imm32;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EXTOp(EXTOp),
        .Imm16(Imm16),
        .Imm32(Imm32)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero extension (EXTOp=0) with MSB=1", test_num);
        Imm16 = 16'hFFFF;
        EXTOp = 2'b00;
        #1;

        check_outputs(32'h0000FFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero extension (EXTOp=0) with MSB=0", test_num);
        Imm16 = 16'h0001;
        EXTOp = 2'b00;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sign extension (EXTOp=1) with negative value", test_num);
        Imm16 = 16'h8000;
        EXTOp = 2'b01;
        #1;

        check_outputs(32'hFFFF8000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sign extension (EXTOp=1) with positive value", test_num);
        Imm16 = 16'h7FFF;
        EXTOp = 2'b01;
        #1;

        check_outputs(32'h00007FFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero extension (EXTOp=2) with MSB=1", test_num);
        Imm16 = 16'hAAAA;
        EXTOp = 2'b10;
        #1;

        check_outputs(32'h0000AAAA);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sign extension (EXTOp=1) with 0xFFFF", test_num);
        Imm16 = 16'hFFFF;
        EXTOp = 2'b01;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero extension with 0x0000", test_num);
        Imm16 = 16'h0000;
        EXTOp = 2'b00;
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
        input [31:0] expected_Imm32;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Imm32 === (expected_Imm32 ^ Imm32 ^ expected_Imm32)) begin
                $display("PASS");
                $display("  Outputs: Imm32=%h",
                         Imm32);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Imm32=%h",
                         expected_Imm32);
                $display("  Got:      Imm32=%h",
                         Imm32);
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
