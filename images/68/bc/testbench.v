`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] IR;
    reg [31:0] Rm;
    reg [31:0] Rs;
    reg SR29_IN;
    wire [31:0] Out;
    wire SR29_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IR(IR),
        .Rm(Rm),
        .Rs(Rs),
        .SR29_IN(SR29_IN),
        .Out(Out),
        .SR29_OUT(SR29_OUT)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: LSL Immediate (Shift 0x1 by 4 bits)", test_num);
            Rm = 32'h00000001;
            Rs = 32'h0;
            SR29_IN = 0;
            IR = calc_ir(5'd4, 2'b00, 1'b0);
            #1;

            check_outputs(32'h00000010, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: LSR Immediate (Shift 0xF0 by 4 bits)", test_num);
            Rm = 32'h000000F0;
            Rs = 32'h0;
            SR29_IN = 0;
            IR = calc_ir(5'd4, 2'b01, 1'b0);
            #1;

            check_outputs(32'h0000000F, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: ASR Immediate Positive (Shift 0x70000000 by 4 bits)", test_num);
            Rm = 32'h70000000;
            Rs = 32'h0;
            SR29_IN = 0;
            IR = calc_ir(5'd4, 2'b10, 1'b0);
            #1;

            check_outputs(32'h07000000, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: ASR Immediate Negative (Shift 0x80000000 by 8 bits)", test_num);
            Rm = 32'h80000000;
            Rs = 32'h0;
            SR29_IN = 0;
            IR = calc_ir(5'd8, 2'b10, 1'b0);
            #1;

            check_outputs(32'hFF800000, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: ROR Immediate (Rotate 0x0000000F by 4 bits)", test_num);
            Rm = 32'h0000000F;
            Rs = 32'h0;
            SR29_IN = 0;
            IR = calc_ir(5'd4, 2'b11, 1'b0);
            #1;

            check_outputs(32'hF0000000, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: LSL Register (Shift 0x1 by Rs=8 bits)", test_num);
            Rm = 32'h00000001;
            Rs = 32'h00000008;
            SR29_IN = 0;
            IR = calc_ir(5'd0, 2'b00, 1'b1);
            #1;

            check_outputs(32'h00000100, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: RRX Special Case (ROR Imm 0, SR29_IN=1)", test_num);
            Rm = 32'h00000001;
            Rs = 32'h0;
            SR29_IN = 1;
            IR = calc_ir(5'd0, 2'b11, 1'b0);

            #1;


            check_outputs(32'h80000000, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Zero Shift LSL", test_num);
            Rm = 32'hDEADBEEF;
            Rs = 32'h0;
            SR29_IN = 0;
            IR = calc_ir(5'd0, 2'b00, 1'b0);
            #1;

            check_outputs(32'hDEADBEEF, 0);
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
        input [31:0] expected_Out;
        input expected_SR29_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out === (expected_Out ^ Out ^ expected_Out) &&
                expected_SR29_OUT === (expected_SR29_OUT ^ SR29_OUT ^ expected_SR29_OUT)) begin
                $display("PASS");
                $display("  Outputs: Out=%h, SR29_OUT=%b",
                         Out, SR29_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%h, SR29_OUT=%b",
                         expected_Out, expected_SR29_OUT);
                $display("  Got:      Out=%h, SR29_OUT=%b",
                         Out, SR29_OUT);
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
