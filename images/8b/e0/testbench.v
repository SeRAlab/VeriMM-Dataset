`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] add_pc_offset;
    reg [31:0] aluresult;
    reg clk;
    reg mem2reg;
    reg memread;
    reg memwrite;
    reg [31:0] readdata2;
    reg [4:0] regdst;
    reg regwrite;
    reg zero;
    wire [31:0] add_pc_offset_O;
    wire [31:0] aluresult_O;
    wire mem2reg_O;
    wire memread_O;
    wire memwrite_O;
    wire [31:0] readdata2_O;
    wire [4:0] regdst_O;
    wire regwrite_O;
    wire zero_O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .add_pc_offset(add_pc_offset),
        .aluresult(aluresult),
        .clk(clk),
        .mem2reg(mem2reg),
        .memread(memread),
        .memwrite(memwrite),
        .readdata2(readdata2),
        .regdst(regdst),
        .regwrite(regwrite),
        .zero(zero),
        .add_pc_offset_O(add_pc_offset_O),
        .aluresult_O(aluresult_O),
        .mem2reg_O(mem2reg_O),
        .memread_O(memread_O),
        .memwrite_O(memwrite_O),
        .readdata2_O(readdata2_O),
        .regdst_O(regdst_O),
        .regwrite_O(regwrite_O),
        .zero_O(zero_O)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            add_pc_offset = 32'b0;
            aluresult     = 32'b0;
            mem2reg       = 1'b0;
            memread       = 1'b0;
            memwrite      = 1'b0;
            readdata2     = 32'b0;
            regdst        = 5'b0;
            regwrite      = 1'b0;
            zero          = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Typical Load-style Signals", test_num);
            reset_dut();


            add_pc_offset = 32'h00001004;
            aluresult     = 32'h10008000;
            mem2reg       = 1'b1;
            memread       = 1'b1;
            memwrite      = 1'b0;
            readdata2     = 32'h00000000;
            regdst        = 5'd10;
            regwrite      = 1'b1;
            zero          = 1'b0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h00001004, 32'h10008000, 1'b1, 1'b1, 1'b0, 32'h00000000, 5'd10, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Typical Store-style Signals", test_num);
            reset_dut();

            add_pc_offset = 32'h00002000;
            aluresult     = 32'h10008010;
            mem2reg       = 1'b0;
            memread       = 1'b0;
            memwrite      = 1'b1;
            readdata2     = 32'hDEADBEEF;
            regdst        = 5'd0;
            regwrite      = 1'b0;
            zero          = 1'b0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00002000, 32'h10008010, 1'b0, 1'b0, 1'b1, 32'hDEADBEEF, 5'd0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Typical Branch/ALU Signals", test_num);
            reset_dut();

            add_pc_offset = 32'h00003040;
            aluresult     = 32'h00000000;
            mem2reg       = 1'b0;
            memread       = 1'b0;
            memwrite      = 1'b0;
            readdata2     = 32'h5555AAAA;
            regdst        = 5'd31;
            regwrite      = 1'b0;
            zero          = 1'b1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00003040, 32'h00000000, 1'b0, 1'b0, 1'b0, 32'h5555AAAA, 5'd31, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Maximum Values (All 1s)", test_num);
            reset_dut();

            add_pc_offset = 32'hFFFFFFFF;
            aluresult     = 32'hFFFFFFFF;
            mem2reg       = 1'b1;
            memread       = 1'b1;
            memwrite      = 1'b1;
            readdata2     = 32'hFFFFFFFF;
            regdst        = 5'h1F;
            regwrite      = 1'b1;
            zero          = 1'b1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF, 1'b1, 1'b1, 1'b1, 32'hFFFFFFFF, 5'h1F, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verification of Clock Edge Hold", test_num);
            reset_dut();


            add_pc_offset = 32'hAAAA_AAAA;
            aluresult     = 32'hBBBB_BBBB;
            mem2reg       = 1'b1;
            memread       = 1'b0;
            memwrite      = 1'b1;
            readdata2     = 32'hCCCC_CCCC;
            regdst        = 5'h0A;
            regwrite      = 1'b1;
            zero          = 1'b0;

            @(posedge clk);
            #1;

            add_pc_offset = 32'h0;
            aluresult     = 32'h0;
            mem2reg       = 1'b0;
            readdata2     = 32'h0;


            #1;
            #1;

            check_outputs(32'hAAAA_AAAA, 32'hBBBB_BBBB, 1'b1, 1'b0, 1'b1, 32'hCCCC_CCCC, 5'h0A, 1'b1, 1'b0);
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
        input [31:0] expected_add_pc_offset_O;
        input [31:0] expected_aluresult_O;
        input expected_mem2reg_O;
        input expected_memread_O;
        input expected_memwrite_O;
        input [31:0] expected_readdata2_O;
        input [4:0] expected_regdst_O;
        input expected_regwrite_O;
        input expected_zero_O;
        begin
            if (expected_add_pc_offset_O === (expected_add_pc_offset_O ^ add_pc_offset_O ^ expected_add_pc_offset_O) &&
                expected_aluresult_O === (expected_aluresult_O ^ aluresult_O ^ expected_aluresult_O) &&
                expected_mem2reg_O === (expected_mem2reg_O ^ mem2reg_O ^ expected_mem2reg_O) &&
                expected_memread_O === (expected_memread_O ^ memread_O ^ expected_memread_O) &&
                expected_memwrite_O === (expected_memwrite_O ^ memwrite_O ^ expected_memwrite_O) &&
                expected_readdata2_O === (expected_readdata2_O ^ readdata2_O ^ expected_readdata2_O) &&
                expected_regdst_O === (expected_regdst_O ^ regdst_O ^ expected_regdst_O) &&
                expected_regwrite_O === (expected_regwrite_O ^ regwrite_O ^ expected_regwrite_O) &&
                expected_zero_O === (expected_zero_O ^ zero_O ^ expected_zero_O)) begin
                $display("PASS");
                $display("  Outputs: add_pc_offset_O=%h, aluresult_O=%h, mem2reg_O=%b, memread_O=%b, memwrite_O=%b, readdata2_O=%h, regdst_O=%h, regwrite_O=%b, zero_O=%b",
                         add_pc_offset_O, aluresult_O, mem2reg_O, memread_O, memwrite_O, readdata2_O, regdst_O, regwrite_O, zero_O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: add_pc_offset_O=%h, aluresult_O=%h, mem2reg_O=%b, memread_O=%b, memwrite_O=%b, readdata2_O=%h, regdst_O=%h, regwrite_O=%b, zero_O=%b",
                         expected_add_pc_offset_O, expected_aluresult_O, expected_mem2reg_O, expected_memread_O, expected_memwrite_O, expected_readdata2_O, expected_regdst_O, expected_regwrite_O, expected_zero_O);
                $display("  Got:      add_pc_offset_O=%h, aluresult_O=%h, mem2reg_O=%b, memread_O=%b, memwrite_O=%b, readdata2_O=%h, regdst_O=%h, regwrite_O=%b, zero_O=%b",
                         add_pc_offset_O, aluresult_O, mem2reg_O, memread_O, memwrite_O, readdata2_O, regdst_O, regwrite_O, zero_O);
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
        $dumpvars(0,add_pc_offset, aluresult, clk, mem2reg, memread, memwrite, readdata2, regdst, regwrite, zero, add_pc_offset_O, aluresult_O, mem2reg_O, memread_O, memwrite_O, readdata2_O, regdst_O, regwrite_O, zero_O);
    end

endmodule
