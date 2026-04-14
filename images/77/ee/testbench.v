`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ALUSrcB;
    reg [31:0] B_out;
    reg [31:0] Sign_Ext_Imm;
    wire [31:0] MUX_SrcB_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUSrcB(ALUSrcB),
        .B_out(B_out),
        .Sign_Ext_Imm(Sign_Ext_Imm),
        .MUX_SrcB_out(MUX_SrcB_out)
    );
    task testcase001;

    begin
        test_num = 1;
        ALUSrcB = 2'b00;
        B_out = 32'h12345678;
        Sign_Ext_Imm = 32'hABCDEF00;
        $display("Testcase %0d: ALUSrcB = 00 (Select B_out)", test_num);
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        ALUSrcB = 2'b01;
        B_out = 32'h12345678;
        Sign_Ext_Imm = 32'hABCDEF00;
        $display("Testcase %0d: ALUSrcB = 01 (Select Constant 1)", test_num);
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        ALUSrcB = 2'b10;
        B_out = 32'h12345678;
        Sign_Ext_Imm = 32'hABCDEF00;
        $display("Testcase %0d: ALUSrcB = 10 (Select Sign_Ext_Imm)", test_num);
        #1;

        check_outputs(32'hABCDEF00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        ALUSrcB = 2'b00;
        B_out = 32'hFFFFFFFF;
        Sign_Ext_Imm = 32'h00000000;
        $display("Testcase %0d: ALUSrcB = 00 with All Ones", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        ALUSrcB = 2'b10;
        B_out = 32'h00000000;
        Sign_Ext_Imm = 32'hFFFFFFFF;
        $display("Testcase %0d: ALUSrcB = 10 with All Ones", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        ALUSrcB = 2'b01;
        B_out = 32'h0;
        Sign_Ext_Imm = 32'h0;
        $display("Testcase %0d: ALUSrcB = 01 with Zero Inputs", test_num);
        #1;

        check_outputs(32'h00000001);
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
        input [31:0] expected_MUX_SrcB_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_MUX_SrcB_out === (expected_MUX_SrcB_out ^ MUX_SrcB_out ^ expected_MUX_SrcB_out)) begin
                $display("PASS");
                $display("  Outputs: MUX_SrcB_out=%h",
                         MUX_SrcB_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MUX_SrcB_out=%h",
                         expected_MUX_SrcB_out);
                $display("  Got:      MUX_SrcB_out=%h",
                         MUX_SrcB_out);
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
