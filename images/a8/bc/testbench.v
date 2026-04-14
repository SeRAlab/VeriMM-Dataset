`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A1;
    reg [31:0] A2;
    reg [3:0] ALUCtr;
    reg [31:0] Instr;
    wire [31:0] ALUResult;
    wire movz;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1(A1),
        .A2(A2),
        .ALUCtr(ALUCtr),
        .Instr(Instr),
        .ALUResult(ALUResult),
        .movz(movz)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Addition (10 + 20)", test_num);
            A1 = 32'd10;
            A2 = 32'd20;
            ALUCtr = 4'b0000;
            Instr = 32'h0;
            #1;

            check_outputs(32'd30, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Subtraction (50 - 20)", test_num);
            A1 = 32'd50;
            A2 = 32'd20;
            ALUCtr = 4'b0001;
            Instr = 32'h0;
            #1;

            check_outputs(32'd30, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Bitwise AND", test_num);
            A1 = 32'hAAAA_5555;
            A2 = 32'hFFFF_0000;
            ALUCtr = 4'b0010;
            Instr = 32'h0;
            #1;

            check_outputs(32'hAAAA_0000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Bitwise OR", test_num);
            A1 = 32'h1234_0000;
            A2 = 32'h0000_5678;
            ALUCtr = 4'b0011;
            Instr = 32'h0;
            #1;

            check_outputs(32'h1234_5678, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Bitwise XOR", test_num);
            A1 = 32'hFFFF_FFFF;
            A2 = 32'hF0F0_F0F0;
            ALUCtr = 4'b0100;
            Instr = 32'h0;
            #1;

            check_outputs(32'h0F0F_0F0F, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: SLL (1 << 5)", test_num);
            A1 = 32'h0;
            A2 = 32'h1;
            ALUCtr = 4'b0101;

            Instr = (5 << 6);
            #1;

            check_outputs(32'h0000_0020, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: SRL (0x80000000 >> 4)", test_num);
            A1 = 32'h0;
            A2 = 32'h8000_0000;
            ALUCtr = 4'b0110;

            Instr = (4 << 6);
            #1;

            check_outputs(32'h0800_0000, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: movz flag check (A2 = 0)", test_num);
            A1 = 32'hDEAD_BEEF;
            A2 = 32'h0000_0000;
            ALUCtr = 4'b0000;
            Instr = 32'h0;
            #1;

            check_outputs(32'hDEAD_BEEF, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Negative Result (5 - 10)", test_num);
            A1 = 32'd5;
            A2 = 32'd10;
            ALUCtr = 4'b0001;
            Instr = 32'h0;
            #1;

            check_outputs(32'hFFFF_FFFB, 1'b0);
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
        input expected_movz;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUResult === (expected_ALUResult ^ ALUResult ^ expected_ALUResult) &&
                expected_movz === (expected_movz ^ movz ^ expected_movz)) begin
                $display("PASS");
                $display("  Outputs: ALUResult=%h, movz=%b",
                         ALUResult, movz);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUResult=%h, movz=%b",
                         expected_ALUResult, expected_movz);
                $display("  Got:      ALUResult=%h, movz=%b",
                         ALUResult, movz);
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
