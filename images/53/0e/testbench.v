`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] instr;
    reg l_sw;
    reg src1sel;
    wire en;
    wire [15:0] imm_src1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .instr(instr),
        .l_sw(l_sw),
        .src1sel(src1sel),
        .en(en),
        .imm_src1(imm_src1)
    );
    task testcase001;

        begin
            $display("Testcase 001: Neither control signal active");
            instr = 8'hFF;
            src1sel = 0;
            l_sw = 0;
            #1;

            check_outputs(1'b0, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: src1sel active, positive 8-bit value (0x5A)");
            instr = 8'h5A;
            src1sel = 1;
            l_sw = 0;

            #1;


            check_outputs(1'b1, 16'h005A);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: src1sel active, negative 8-bit value (0xA5)");
            instr = 8'hA5;
            src1sel = 1;
            l_sw = 0;

            #1;


            check_outputs(1'b1, 16'hFFA5);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: l_sw active, positive 4-bit value (0x07)");
            instr = 8'hF7;
            src1sel = 0;
            l_sw = 1;

            #1;


            check_outputs(1'b1, 16'h0007);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: l_sw active, negative 4-bit value (0x0F)");
            instr = 8'hF8;
            src1sel = 0;
            l_sw = 1;

            #1;


            check_outputs(1'b1, 16'hFFF8);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Both signals active (Priority test: src1sel)");
            instr = 8'h82;
            src1sel = 1;
            l_sw = 1;

            #1;


            check_outputs(1'b1, 16'hFF82);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: src1sel negative boundary (0x80)");
            instr = 8'h80;
            src1sel = 1;
            l_sw = 0;
            #1;

            check_outputs(1'b1, 16'hFF80);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: l_sw negative boundary (bit 3 is 1)");
            instr = 8'h08;
            src1sel = 0;
            l_sw = 1;
            #1;

            check_outputs(1'b1, 16'hFFF8);
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
        input expected_en;
        input [15:0] expected_imm_src1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_en === (expected_en ^ en ^ expected_en) &&
                expected_imm_src1 === (expected_imm_src1 ^ imm_src1 ^ expected_imm_src1)) begin
                $display("PASS");
                $display("  Outputs: en=%b, imm_src1=%h",
                         en, imm_src1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: en=%b, imm_src1=%h",
                         expected_en, expected_imm_src1);
                $display("  Got:      en=%b, imm_src1=%h",
                         en, imm_src1);
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
