`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] AO;
    reg Clk;
    reg [31:0] IR;
    reg [31:0] PC4;
    reg [31:0] RT;
    reg Reset;
    reg [31:0] SH;
    wire [31:0] AO_M;
    wire [31:0] IR_M;
    wire [31:0] PC4_M;
    wire [31:0] RT_M;
    wire [31:0] SH_M;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AO(AO),
        .Clk(Clk),
        .IR(IR),
        .PC4(PC4),
        .RT(RT),
        .Reset(Reset),
        .SH(SH),
        .AO_M(AO_M),
        .IR_M(IR_M),
        .PC4_M(PC4_M),
        .RT_M(RT_M),
        .SH_M(SH_M)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Reset = 1;
            AO = 0; IR = 0; PC4 = 0; RT = 0; SH = 0;
            @(posedge Clk);
            #1 Reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Verifying Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 32'h0, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic Load Operation", test_num);
            reset_dut();
            IR  = 32'h12345678;
            PC4 = 32'h00000400;
            AO  = 32'hAABBCCDD;
            RT  = 32'hDEADBEEF;
            SH  = 32'h00000010;
            @(posedge Clk);
            #2;
            #1;

            check_outputs(32'hAABBCCDD, 32'h12345678, 32'h00000400, 32'hDEADBEEF, 32'h00000010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Data Retention Check", test_num);
            reset_dut();

            IR = 32'hAAAA_AAAA; PC4 = 32'hBBBB_BBBB; AO = 32'hCCCC_CCCC; RT = 32'hDDDD_DDDD; SH = 32'hEEEE_EEEE;
            @(posedge Clk);
            #2;

            IR = 32'h0; PC4 = 32'h0; AO = 32'h0; RT = 32'h0; SH = 32'h0;
            #5;

            #1;


            check_outputs(32'hCCCC_CCCC, 32'hAAAA_AAAA, 32'hBBBB_BBBB, 32'hDDDD_DDDD, 32'hEEEE_EEEE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Sequential Update Check", test_num);
            reset_dut();

            IR = 32'h1; PC4 = 32'h2; AO = 32'h3; RT = 32'h4; SH = 32'h5;
            @(posedge Clk);
            #2;

            IR = 32'hFFFFFFFF; PC4 = 32'hFFFFFFFF; AO = 32'hFFFFFFFF; RT = 32'hFFFFFFFF; SH = 32'hFFFFFFFF;
            @(posedge Clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Mid-operation Reset", test_num);
            reset_dut();

            IR = 32'hCAFE_BABE; PC4 = 32'h100; AO = 32'h200; RT = 32'h300; SH = 32'h5;

            Reset = 1;
            @(posedge Clk);
            #2;
            Reset = 0;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 32'h0, 32'h0);
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
        input [31:0] expected_AO_M;
        input [31:0] expected_IR_M;
        input [31:0] expected_PC4_M;
        input [31:0] expected_RT_M;
        input [31:0] expected_SH_M;
        begin
            if (expected_AO_M === (expected_AO_M ^ AO_M ^ expected_AO_M) &&
                expected_IR_M === (expected_IR_M ^ IR_M ^ expected_IR_M) &&
                expected_PC4_M === (expected_PC4_M ^ PC4_M ^ expected_PC4_M) &&
                expected_RT_M === (expected_RT_M ^ RT_M ^ expected_RT_M) &&
                expected_SH_M === (expected_SH_M ^ SH_M ^ expected_SH_M)) begin
                $display("PASS");
                $display("  Outputs: AO_M=%h, IR_M=%h, PC4_M=%h, RT_M=%h, SH_M=%h",
                         AO_M, IR_M, PC4_M, RT_M, SH_M);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AO_M=%h, IR_M=%h, PC4_M=%h, RT_M=%h, SH_M=%h",
                         expected_AO_M, expected_IR_M, expected_PC4_M, expected_RT_M, expected_SH_M);
                $display("  Got:      AO_M=%h, IR_M=%h, PC4_M=%h, RT_M=%h, SH_M=%h",
                         AO_M, IR_M, PC4_M, RT_M, SH_M);
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
        $dumpvars(0,AO, Clk, IR, PC4, RT, Reset, SH, AO_M, IR_M, PC4_M, RT_M, SH_M);
    end

endmodule
