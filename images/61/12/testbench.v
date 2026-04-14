`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ExtendI;
    reg [15:0] Imm16;
    wire [31:0] Imm32;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ExtendI(ExtendI),
        .Imm16(Imm16),
        .Imm32(Imm32)
    );
    task testcase001;

        begin
            $display("Testcase 001: Zero Padding (ExtendI=00) - Positive Value");
            Imm16 = 16'h1234;
            ExtendI = 2'b00;
            #1;

            check_outputs(32'h00001234);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Zero Padding (ExtendI=00) - MSB=1 Value");
            Imm16 = 16'h8001;
            ExtendI = 2'b00;
            #1;

            check_outputs(32'h00008001);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Sign Extension (ExtendI=01) - Positive Value");
            Imm16 = 16'h1234;
            ExtendI = 2'b01;
            #1;

            check_outputs(32'h00001234);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Sign Extension (ExtendI=01) - Negative Value");
            Imm16 = 16'h8001;
            ExtendI = 2'b01;
            #1;

            check_outputs(32'hFFFF8001);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Zero Padding (ExtendI=10) - Alternative Code");
            Imm16 = 16'hABCD;
            ExtendI = 2'b10;
            #1;

            check_outputs(32'h0000ABCD);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Sign Extend & Shift (ExtendI=11) - Positive Value");
            Imm16 = 16'h0002;
            ExtendI = 2'b11;

            #1;


            check_outputs(32'h00000008);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Sign Extend & Shift (ExtendI=11) - Negative Value");
            Imm16 = 16'h8001;
            ExtendI = 2'b11;

            #1;


            check_outputs(32'hFFFE0004);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Corner Case - All Zeros");
            Imm16 = 16'h0000;
            ExtendI = 2'b01;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Corner Case - All Ones (Sign Extend)");
            Imm16 = 16'hFFFF;
            ExtendI = 2'b01;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Corner Case - All Ones (Sign Extend & Shift)");
            Imm16 = 16'hFFFF;
            ExtendI = 2'b11;

            #1;


            check_outputs(32'hFFFFFFFC);
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
