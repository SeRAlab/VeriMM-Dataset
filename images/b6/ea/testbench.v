`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] Instruction;
    wire [3:0] ALUopsel;
    wire [14:0] Immediate;
    wire MUXsel1;
    wire [5:0] RD;
    wire [5:0] RS;
    wire [5:0] RT;
    wire RegWrite;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Instruction(Instruction),
        .ALUopsel(ALUopsel),
        .Immediate(Immediate),
        .MUXsel1(MUXsel1),
        .RD(RD),
        .RS(RS),
        .RT(RT),
        .RegWrite(RegWrite)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Zero Instruction (No-op)", test_num);
            Instruction = 32'h00000000;

            #1;


            check_outputs(4'h0, 15'h0000, 1'b0, 6'h00, 6'h00, 6'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Standard Instruction Pattern", test_num);
            Instruction = 32'h10848400;

            #1;


            check_outputs(4'h1, 15'h0400, 1'b0, 6'h21, 6'h02, 6'h04, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: MUX Selection and Immediate Value", test_num);
            Instruction = 32'h41041200;

            #1;


            check_outputs(4'h4, 15'h1200, 1'b1, 6'h04, 6'h04, 6'h04, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: All Bits Set", test_num);
            Instruction = 32'hFFFFFFFF;

            #1;


            check_outputs(4'hF, 15'h7FFF, 1'b1, 6'h3F, 6'h3F, 6'h3F, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Minimal Non-zero Instruction", test_num);
            Instruction = 32'h00000001;

            #1;


            check_outputs(4'h0, 15'h0001, 1'b0, 6'h00, 6'h00, 6'h00, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Field Extraction Logic", test_num);
            Instruction = 32'h2B555600;
            #1;

            check_outputs(4'h2, 15'h5600, 1'b1, 6'h15, 6'h2D, 6'h15, 1'b1);
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
        input [3:0] expected_ALUopsel;
        input [14:0] expected_Immediate;
        input expected_MUXsel1;
        input [5:0] expected_RD;
        input [5:0] expected_RS;
        input [5:0] expected_RT;
        input expected_RegWrite;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUopsel === (expected_ALUopsel ^ ALUopsel ^ expected_ALUopsel) &&
                expected_Immediate === (expected_Immediate ^ Immediate ^ expected_Immediate) &&
                expected_MUXsel1 === (expected_MUXsel1 ^ MUXsel1 ^ expected_MUXsel1) &&
                expected_RD === (expected_RD ^ RD ^ expected_RD) &&
                expected_RS === (expected_RS ^ RS ^ expected_RS) &&
                expected_RT === (expected_RT ^ RT ^ expected_RT) &&
                expected_RegWrite === (expected_RegWrite ^ RegWrite ^ expected_RegWrite)) begin
                $display("PASS");
                $display("  Outputs: ALUopsel=%h, Immediate=%h, MUXsel1=%b, RD=%h, RS=%h, RT=%h, RegWrite=%b",
                         ALUopsel, Immediate, MUXsel1, RD, RS, RT, RegWrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUopsel=%h, Immediate=%h, MUXsel1=%b, RD=%h, RS=%h, RT=%h, RegWrite=%b",
                         expected_ALUopsel, expected_Immediate, expected_MUXsel1, expected_RD, expected_RS, expected_RT, expected_RegWrite);
                $display("  Got:      ALUopsel=%h, Immediate=%h, MUXsel1=%b, RD=%h, RS=%h, RT=%h, RegWrite=%b",
                         ALUopsel, Immediate, MUXsel1, RD, RS, RT, RegWrite);
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
