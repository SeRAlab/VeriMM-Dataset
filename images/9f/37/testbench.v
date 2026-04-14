`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] aluout_exmem;
    reg clk;
    reg [15:0] extended_exmem;
    reg jal_exmem;
    reg mem2reg_exmem;
    reg nop_lw_exmem;
    reg [15:0] pc_added_exmem;
    reg [3:0] rf_waddr_exmem;
    reg rf_wen_exmem;
    reg s7_exmem;
    wire [15:0] aluout_memwb;
    wire [15:0] extended_memwb;
    wire jal_memwb;
    wire mem2reg_memwb;
    wire nop_lw_memwb;
    wire [15:0] pc_added_memwb;
    wire [3:0] rf_waddr_memwb;
    wire rf_wen_memwb;
    wire s7_memwb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aluout_exmem(aluout_exmem),
        .clk(clk),
        .extended_exmem(extended_exmem),
        .jal_exmem(jal_exmem),
        .mem2reg_exmem(mem2reg_exmem),
        .nop_lw_exmem(nop_lw_exmem),
        .pc_added_exmem(pc_added_exmem),
        .rf_waddr_exmem(rf_waddr_exmem),
        .rf_wen_exmem(rf_wen_exmem),
        .s7_exmem(s7_exmem),
        .aluout_memwb(aluout_memwb),
        .extended_memwb(extended_memwb),
        .jal_memwb(jal_memwb),
        .mem2reg_memwb(mem2reg_memwb),
        .nop_lw_memwb(nop_lw_memwb),
        .pc_added_memwb(pc_added_memwb),
        .rf_waddr_memwb(rf_waddr_memwb),
        .rf_wen_memwb(rf_wen_memwb),
        .s7_memwb(s7_memwb)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            s7_exmem = 0;
            rf_wen_exmem = 0;
            mem2reg_exmem = 0;
            rf_waddr_exmem = 0;
            aluout_exmem = 0;
            extended_exmem = 0;
            nop_lw_exmem = 0;
            pc_added_exmem = 0;
            jal_exmem = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;


            aluout_exmem   = 16'h1234;
            extended_exmem = 16'h0000;
            jal_exmem      = 0;
            mem2reg_exmem  = 0;
            nop_lw_exmem   = 0;
            pc_added_exmem = 16'h0004;
            rf_waddr_exmem = 4'h5;
            rf_wen_exmem   = 1;
            s7_exmem       = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h1234, 16'h0000, 0, 0, 0, 16'h0004, 4'h5, 1, 1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;


            aluout_exmem   = 16'hA000;
            extended_exmem = 16'h0008;
            jal_exmem      = 0;
            mem2reg_exmem  = 1;
            nop_lw_exmem   = 0;
            pc_added_exmem = 16'h0008;
            rf_waddr_exmem = 4'hA;
            rf_wen_exmem   = 1;
            s7_exmem       = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'hA000, 16'h0008, 0, 1, 0, 16'h0008, 4'hA, 1, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;


            aluout_exmem   = 16'h0000;
            extended_exmem = 16'h0040;
            jal_exmem      = 1;
            mem2reg_exmem  = 0;
            nop_lw_exmem   = 0;
            pc_added_exmem = 16'h1000;
            rf_waddr_exmem = 4'hF;
            rf_wen_exmem   = 1;
            s7_exmem       = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h0000, 16'h0040, 1, 0, 0, 16'h1000, 4'hF, 1, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;


            aluout_exmem   = 16'hFFFF;
            extended_exmem = 16'hFFFF;
            jal_exmem      = 0;
            mem2reg_exmem  = 0;
            nop_lw_exmem   = 1;
            pc_added_exmem = 16'h0000;
            rf_waddr_exmem = 4'h0;
            rf_wen_exmem   = 0;
            s7_exmem       = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'hFFFF, 16'hFFFF, 0, 0, 1, 16'h0000, 4'h0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            aluout_exmem   = 16'hFFFF;
            extended_exmem = 16'hFFFF;
            jal_exmem      = 1;
            mem2reg_exmem  = 1;
            nop_lw_exmem   = 1;
            pc_added_exmem = 16'hFFFF;
            rf_waddr_exmem = 4'hF;
            rf_wen_exmem   = 1;
            s7_exmem       = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'hFFFF, 16'hFFFF, 1, 1, 1, 16'hFFFF, 4'hF, 1, 1);
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
        input [15:0] expected_aluout_memwb;
        input [15:0] expected_extended_memwb;
        input expected_jal_memwb;
        input expected_mem2reg_memwb;
        input expected_nop_lw_memwb;
        input [15:0] expected_pc_added_memwb;
        input [3:0] expected_rf_waddr_memwb;
        input expected_rf_wen_memwb;
        input expected_s7_memwb;
        begin
            if (expected_aluout_memwb === (expected_aluout_memwb ^ aluout_memwb ^ expected_aluout_memwb) &&
                expected_extended_memwb === (expected_extended_memwb ^ extended_memwb ^ expected_extended_memwb) &&
                expected_jal_memwb === (expected_jal_memwb ^ jal_memwb ^ expected_jal_memwb) &&
                expected_mem2reg_memwb === (expected_mem2reg_memwb ^ mem2reg_memwb ^ expected_mem2reg_memwb) &&
                expected_nop_lw_memwb === (expected_nop_lw_memwb ^ nop_lw_memwb ^ expected_nop_lw_memwb) &&
                expected_pc_added_memwb === (expected_pc_added_memwb ^ pc_added_memwb ^ expected_pc_added_memwb) &&
                expected_rf_waddr_memwb === (expected_rf_waddr_memwb ^ rf_waddr_memwb ^ expected_rf_waddr_memwb) &&
                expected_rf_wen_memwb === (expected_rf_wen_memwb ^ rf_wen_memwb ^ expected_rf_wen_memwb) &&
                expected_s7_memwb === (expected_s7_memwb ^ s7_memwb ^ expected_s7_memwb)) begin
                $display("PASS");
                $display("  Outputs: aluout_memwb=%h, extended_memwb=%h, jal_memwb=%b, mem2reg_memwb=%b, nop_lw_memwb=%b, pc_added_memwb=%h, rf_waddr_memwb=%h, rf_wen_memwb=%b, s7_memwb=%b",
                         aluout_memwb, extended_memwb, jal_memwb, mem2reg_memwb, nop_lw_memwb, pc_added_memwb, rf_waddr_memwb, rf_wen_memwb, s7_memwb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluout_memwb=%h, extended_memwb=%h, jal_memwb=%b, mem2reg_memwb=%b, nop_lw_memwb=%b, pc_added_memwb=%h, rf_waddr_memwb=%h, rf_wen_memwb=%b, s7_memwb=%b",
                         expected_aluout_memwb, expected_extended_memwb, expected_jal_memwb, expected_mem2reg_memwb, expected_nop_lw_memwb, expected_pc_added_memwb, expected_rf_waddr_memwb, expected_rf_wen_memwb, expected_s7_memwb);
                $display("  Got:      aluout_memwb=%h, extended_memwb=%h, jal_memwb=%b, mem2reg_memwb=%b, nop_lw_memwb=%b, pc_added_memwb=%h, rf_waddr_memwb=%h, rf_wen_memwb=%b, s7_memwb=%b",
                         aluout_memwb, extended_memwb, jal_memwb, mem2reg_memwb, nop_lw_memwb, pc_added_memwb, rf_waddr_memwb, rf_wen_memwb, s7_memwb);
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
        $dumpvars(0,aluout_exmem, clk, extended_exmem, jal_exmem, mem2reg_exmem, nop_lw_exmem, pc_added_exmem, rf_waddr_exmem, rf_wen_exmem, s7_exmem, aluout_memwb, extended_memwb, jal_memwb, mem2reg_memwb, nop_lw_memwb, pc_added_memwb, rf_waddr_memwb, rf_wen_memwb, s7_memwb);
    end

endmodule
