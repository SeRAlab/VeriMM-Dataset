`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] imm;
    reg [31:0] in1;
    reg [31:0] instr;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .imm(imm),
        .in1(in1),
        .instr(instr),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ADDI (Positive Addition)", test_num);
            instr = 32'b0000000_00000_00000_000_00000_0010011;
            in1 = 32'd100;
            imm = 32'd250;
            #1;

            check_outputs(32'd350);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ADDI (Negative Addition)", test_num);
            instr = 32'b0000000_00000_00000_000_00000_0010011;
            in1 = 32'sd10;
            imm = -32'sd50;
            #1;

            check_outputs(-32'sd40);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SLTI (Signed Less Than - True)", test_num);
            instr = 32'b0000000_00000_00000_010_00000_0010011;
            in1 = -32'sd100;
            imm = 32'sd50;
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SLTI (Signed Less Than - False)", test_num);
            instr = 32'b0000000_00000_00000_010_00000_0010011;
            in1 = 32'sd100;
            imm = -32'sd50;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SLTIU (Unsigned Less Than)", test_num);
            instr = 32'b0000000_00000_00000_011_00000_0010011;

            in1 = -32'sd1;
            imm = 32'd5;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: XORI", test_num);
            instr = 32'b0000000_00000_00000_100_00000_0010011;
            in1 = 32'hAAAAAAAA;
            imm = 32'h55555555;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ORI", test_num);
            instr = 32'b0000000_00000_00000_110_00000_0010011;
            in1 = 32'hF0F0F0F0;
            imm = 32'h0F0F0F0F;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ANDI", test_num);
            instr = 32'b0000000_00000_00000_111_00000_0010011;
            in1 = 32'hFFFF0000;
            imm = 32'hF0F0F0F0;
            #1;

            check_outputs(32'hF0F00000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SLLI (Shift Left Logical)", test_num);
            instr = 32'b0000000_00000_00000_001_00000_0010011;
            in1 = 32'h00000001;
            imm = 32'd8;
            #1;

            check_outputs(32'h00000100);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SRLI (Shift Right Logical)", test_num);
            instr = 32'b0000000_00000_00000_101_00000_0010011;
            in1 = 32'h80000000;
            imm = 32'd4;
            #1;

            check_outputs(32'h08000000);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SRAI (Shift Right Arithmetic)", test_num);
            instr = 32'b0100000_00000_00000_101_00000_0010011;
            in1 = 32'h80000000;
            imm = 32'd4;
            #1;

            check_outputs(32'hF8000000);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ADDI (Zero case)", test_num);
            instr = 32'b0000000_00000_00000_000_00000_0010011;
            in1 = 32'h12345678;
            imm = 32'd0;
            #1;

            check_outputs(32'h12345678);
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
