`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] I_alu;
    reg [2:0] I_cB;
    reg [15:0] I_imm16;
    reg [25:0] I_imm26;
    reg [31:0] I_pc;
    reg [31:0] O_rs_data;
    wire [31:0] O_output_pc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I_alu(I_alu),
        .I_cB(I_cB),
        .I_imm16(I_imm16),
        .I_imm26(I_imm26),
        .I_pc(I_pc),
        .O_rs_data(O_rs_data),
        .O_output_pc(O_output_pc)
    );
    task testcase001;

        begin
            test_num = 1;
            I_pc = 32'h0000_2000;
            I_cB = 3'd0;
            I_alu = 32'h0000_0001;
            I_imm16 = 16'h0005;
            I_imm26 = 26'h0;
            O_rs_data = 32'h0;
            $display("Testcase %0d: Branch Taken (Pos Offset)", test_num);
            #1;

            check_outputs(32'h0000_2018);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            I_pc = 32'h0000_2000;
            I_cB = 3'd1;
            I_alu = 32'h0000_0000;
            I_imm16 = 16'h0005;
            I_imm26 = 26'h0;
            O_rs_data = 32'h0;
            $display("Testcase %0d: Branch Not Taken", test_num);
            #1;

            check_outputs(32'h0000_2004);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            I_pc = 32'h0000_2000;
            I_cB = 3'd2;
            I_alu = 32'h0000_0001;
            I_imm16 = 16'hFFFE;
            I_imm26 = 26'h0;
            O_rs_data = 32'h0;
            $display("Testcase %0d: Branch Taken (Neg Offset)", test_num);
            #1;

            check_outputs(32'h0000_1FFC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            I_pc = 32'h0000_2000;
            I_cB = 3'd5;
            I_alu = 32'h0;
            I_imm16 = 16'h0;
            I_imm26 = 26'h000_0004;
            O_rs_data = 32'h0;
            $display("Testcase %0d: Jump (J-type)", test_num);
            #1;

            check_outputs(32'h0000_0010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            I_pc = 32'h0000_2000;
            I_cB = 3'd6;
            I_alu = 32'h0;
            I_imm16 = 16'h0;
            I_imm26 = 26'h0;
            O_rs_data = 32'hABCD_1234;
            $display("Testcase %0d: Jump Register (JR-type)", test_num);
            #1;

            check_outputs(32'hABCD_1234);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            I_pc = 32'h0000_2000;
            I_cB = 3'd7;
            I_alu = 32'h0;
            I_imm16 = 16'h0;
            I_imm26 = 26'h0;
            O_rs_data = 32'h0;
            $display("Testcase %0d: Default PC+4 Logic", test_num);
            #1;

            check_outputs(32'h0000_2004);
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
        input [31:0] expected_O_output_pc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O_output_pc === (expected_O_output_pc ^ O_output_pc ^ expected_O_output_pc)) begin
                $display("PASS");
                $display("  Outputs: O_output_pc=%h",
                         O_output_pc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O_output_pc=%h",
                         expected_O_output_pc);
                $display("  Got:      O_output_pc=%h",
                         O_output_pc);
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
