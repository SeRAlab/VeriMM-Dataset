`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Mem2Reg_i;
    reg RegWrite_i;
    reg clk_i;
    reg [4:0] instr_i;
    reg [31:0] rs1_i;
    reg rst_n;
    reg [31:0] rt2_i;
    wire Mem2Reg_o;
    wire RegWrite_o;
    wire [4:0] instr_o;
    wire [31:0] rs1_o;
    wire [31:0] rt2_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Mem2Reg_i(Mem2Reg_i),
        .RegWrite_i(RegWrite_i),
        .clk_i(clk_i),
        .instr_i(instr_i),
        .rs1_i(rs1_i),
        .rst_n(rst_n),
        .rt2_i(rt2_i),
        .Mem2Reg_o(Mem2Reg_o),
        .RegWrite_o(RegWrite_o),
        .instr_o(instr_o),
        .rs1_o(rs1_o),
        .rt2_o(rt2_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_n = 1'b0;
            Mem2Reg_i = 1'b0;
            RegWrite_i = 1'b0;
            instr_i = 5'b0;
            rs1_i = 32'b0;
            rt2_i = 32'b0;
            @(posedge clk_i);
            #2 rst_n = 1'b1;
            @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Verification", test_num);
            reset_dut();


            #1;



            check_outputs(1'b0, 1'b0, 5'h00, 32'h00000000, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Data Capture", test_num);
            reset_dut();

            rs1_i = 32'hDEADBEEF;
            rt2_i = 32'hCAFEBABE;
            instr_i = 5'h1A;
            Mem2Reg_i = 1'b1;
            RegWrite_i = 1'b1;

            @(posedge clk_i);
            #2;
            #1;

            check_outputs(1'b1, 1'b1, 5'h1A, 32'hDEADBEEF, 32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All-Ones Data", test_num);
            reset_dut();

            rs1_i = 32'hFFFFFFFF;
            rt2_i = 32'hFFFFFFFF;
            instr_i = 5'h1F;
            Mem2Reg_i = 1'b1;
            RegWrite_i = 1'b1;

            @(posedge clk_i);
            #2;
            #1;

            check_outputs(1'b1, 1'b1, 5'h1F, 32'hFFFFFFFF, 32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits", test_num);
            reset_dut();

            rs1_i = 32'h55555555;
            rt2_i = 32'hAAAAAAAA;
            instr_i = 5'h0F;
            Mem2Reg_i = 1'b0;
            RegWrite_i = 1'b1;

            @(posedge clk_i);
            #2;
            #1;

            check_outputs(1'b0, 1'b1, 5'h0F, 32'h55555555, 32'hAAAAAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Capture/Hold", test_num);
            reset_dut();


            rs1_i = 32'h12345678;
            rt2_i = 32'h87654321;
            instr_i = 5'h05;
            Mem2Reg_i = 1'b1;
            RegWrite_i = 1'b0;

            @(posedge clk_i);
            #1;

            rs1_i = 32'h0;
            rt2_i = 32'h0;
            instr_i = 5'h0;

            #1;
            #1;

            check_outputs(1'b1, 1'b0, 5'h05, 32'h12345678, 32'h87654321);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Updates", test_num);
            reset_dut();


            rs1_i = 32'hA1; rt2_i = 32'hB2; instr_i = 5'h01; Mem2Reg_i = 1; RegWrite_i = 0;
            @(posedge clk_i);
            #1;

            rs1_i = 32'hC3; rt2_i = 32'hD4; instr_i = 5'h02; Mem2Reg_i = 0; RegWrite_i = 1;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 5'h02, 32'hC3, 32'hD4);
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
        input expected_Mem2Reg_o;
        input expected_RegWrite_o;
        input [4:0] expected_instr_o;
        input [31:0] expected_rs1_o;
        input [31:0] expected_rt2_o;
        begin
            if (expected_Mem2Reg_o === (expected_Mem2Reg_o ^ Mem2Reg_o ^ expected_Mem2Reg_o) &&
                expected_RegWrite_o === (expected_RegWrite_o ^ RegWrite_o ^ expected_RegWrite_o) &&
                expected_instr_o === (expected_instr_o ^ instr_o ^ expected_instr_o) &&
                expected_rs1_o === (expected_rs1_o ^ rs1_o ^ expected_rs1_o) &&
                expected_rt2_o === (expected_rt2_o ^ rt2_o ^ expected_rt2_o)) begin
                $display("PASS");
                $display("  Outputs: Mem2Reg_o=%b, RegWrite_o=%b, instr_o=%h, rs1_o=%h, rt2_o=%h",
                         Mem2Reg_o, RegWrite_o, instr_o, rs1_o, rt2_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Mem2Reg_o=%b, RegWrite_o=%b, instr_o=%h, rs1_o=%h, rt2_o=%h",
                         expected_Mem2Reg_o, expected_RegWrite_o, expected_instr_o, expected_rs1_o, expected_rt2_o);
                $display("  Got:      Mem2Reg_o=%b, RegWrite_o=%b, instr_o=%h, rs1_o=%h, rt2_o=%h",
                         Mem2Reg_o, RegWrite_o, instr_o, rs1_o, rt2_o);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,Mem2Reg_i, RegWrite_i, clk_i, instr_i, rs1_i, rst_n, rt2_i, Mem2Reg_o, RegWrite_o, instr_o, rs1_o, rt2_o);
    end

endmodule
