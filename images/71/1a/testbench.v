`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] ALU_Src1;
    reg [15:0] data_IN;
    reg [15:0] data_SP;
    reg [15:0] data_T;
    reg [15:0] data_pc;
    reg [15:0] data_rx;
    reg [15:0] imm3;
    reg [15:0] imm8;
    wire [15:0] Src1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_Src1(ALU_Src1),
        .data_IN(data_IN),
        .data_SP(data_SP),
        .data_T(data_T),
        .data_pc(data_pc),
        .data_rx(data_rx),
        .imm3(imm3),
        .imm8(imm8),
        .Src1(Src1)
    );
    task initialize_inputs;

        begin
            data_rx = 16'hA001;
            imm3    = 16'hB002;
            imm8    = 16'hC003;
            data_IN  = 16'hD004;
            data_SP  = 16'hE005;
            data_T   = 16'hF006;
            data_pc  = 16'h1007;
            ALU_Src1 = 8'hFF;
        end
        endtask

    task testcase001;

        begin
            initialize_inputs();
            ALU_Src1 = 8'd0;
            $display("Testcase 001: Selecting data_rx...");
            #1;

            check_outputs(16'hA001);
        end
        endtask

    task testcase002;

        begin
            initialize_inputs();
            ALU_Src1 = 8'd1;
            $display("Testcase 002: Selecting imm3...");
            #1;

            check_outputs(16'hB002);
        end
        endtask

    task testcase003;

        begin
            initialize_inputs();
            ALU_Src1 = 8'd2;
            $display("Testcase 003: Selecting imm8...");
            #1;

            check_outputs(16'hC003);
        end
        endtask

    task testcase004;

        begin
            initialize_inputs();
            ALU_Src1 = 8'd3;
            $display("Testcase 004: Selecting data_IN...");
            #1;

            check_outputs(16'hD004);
        end
        endtask

    task testcase005;

        begin
            initialize_inputs();
            ALU_Src1 = 8'd4;
            $display("Testcase 005: Selecting data_SP...");
            #1;

            check_outputs(16'hE005);
        end
        endtask

    task testcase006;

        begin
            initialize_inputs();
            ALU_Src1 = 8'd5;
            $display("Testcase 006: Selecting data_T...");
            #1;

            check_outputs(16'hF006);
        end
        endtask

    task testcase007;

        begin
            initialize_inputs();
            ALU_Src1 = 8'd6;
            $display("Testcase 007: Selecting data_pc...");
            #1;

            check_outputs(16'h1007);
        end
        endtask

    task testcase008;

        begin
            initialize_inputs();
            ALU_Src1 = 8'hAA;
            $display("Testcase 008: Testing Default (Zero) output...");
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_Src1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Src1 === (expected_Src1 ^ Src1 ^ expected_Src1)) begin
                $display("PASS");
                $display("  Outputs: Src1=%h",
                         Src1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Src1=%h",
                         expected_Src1);
                $display("  Got:      Src1=%h",
                         Src1);
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
