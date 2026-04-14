`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg PCSrc_D;
    reg Stall_D;
    reg clk;
    reg [31:0] instr_F;
    reg [31:0] npc_F;
    reg reset;
    wire [31:0] instr_D;
    wire [31:0] npc_D;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PCSrc_D(PCSrc_D),
        .Stall_D(Stall_D),
        .clk(clk),
        .instr_F(instr_F),
        .npc_F(npc_F),
        .reset(reset),
        .instr_D(instr_D),
        .npc_D(npc_D)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        Stall_D = 0;
        PCSrc_D = 0;
        instr_F = 32'h0;
        npc_F = 32'h0;
        @(posedge clk);
        #1 reset = 0;
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Reset", test_num);
        reset_dut();

        #1;


        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Normal Data Load", test_num);
        reset_dut();
        instr_F = 32'hA1A1A1A1;
        npc_F = 32'h00000004;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hA1A1A1A1, 32'h00000004);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Stall Holding Data", test_num);
        reset_dut();

        instr_F = 32'hB2B2B2B2;
        npc_F = 32'h00000008;
        @(posedge clk);
        #1;

        Stall_D = 1;
        instr_F = 32'hFFFFFFFF;
        npc_F = 32'h0000FFFF;
        @(posedge clk);
        #2;

        #1;


        check_outputs(32'hB2B2B2B2, 32'h00000008);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Stall Recovery", test_num);
        reset_dut();

        Stall_D = 1;
        instr_F = 32'hC3C3C3C3;
        npc_F = 32'h0000000C;
        @(posedge clk);
        #1;

        Stall_D = 0;
        @(posedge clk);
        #2;

        #1;


        check_outputs(32'hC3C3C3C3, 32'h0000000C);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset Priority over Stall", test_num);
        reset_dut();

        instr_F = 32'hD4D4D4D4;
        npc_F = 32'h00000010;
        @(posedge clk);
        #1;

        Stall_D = 1;
        reset = 1;
        @(posedge clk);
        #2;

        #1;


        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Continuous Flow", test_num);
        reset_dut();

        instr_F = 32'h11111111; npc_F = 32'h4;
        @(posedge clk);
        #1;
        instr_F = 32'h22222222; npc_F = 32'h8;
        @(posedge clk);
        #1;
        instr_F = 32'h33333333; npc_F = 32'hC;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h33333333, 32'h0000000C);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: PCSrc_D Transparency", test_num);
        reset_dut();
        instr_F = 32'hE5E5E5E5;
        npc_F = 32'h00000020;
        PCSrc_D = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hE5E5E5E5, 32'h00000020);
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
        input [31:0] expected_instr_D;
        input [31:0] expected_npc_D;
        begin
            if (expected_instr_D === (expected_instr_D ^ instr_D ^ expected_instr_D) &&
                expected_npc_D === (expected_npc_D ^ npc_D ^ expected_npc_D)) begin
                $display("PASS");
                $display("  Outputs: instr_D=%h, npc_D=%h",
                         instr_D, npc_D);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instr_D=%h, npc_D=%h",
                         expected_instr_D, expected_npc_D);
                $display("  Got:      instr_D=%h, npc_D=%h",
                         instr_D, npc_D);
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
        $dumpvars(0,PCSrc_D, Stall_D, clk, instr_F, npc_F, reset, instr_D, npc_D);
    end

endmodule
