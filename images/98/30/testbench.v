`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk_i;
    reg Direction_i;
    reg Enable_i;
    reg [15:0] PresetValH_i;
    reg [15:0] PresetValL_i;
    reg Preset_i;
    reg ResetSig_i;
    reg Reset_n_i;
    wire [15:0] DH_o;
    wire [15:0] DL_o;
    wire Overflow_o;
    wire Zero_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk_i(Clk_i),
        .Direction_i(Direction_i),
        .Enable_i(Enable_i),
        .PresetValH_i(PresetValH_i),
        .PresetValL_i(PresetValL_i),
        .Preset_i(Preset_i),
        .ResetSig_i(ResetSig_i),
        .Reset_n_i(Reset_n_i),
        .DH_o(DH_o),
        .DL_o(DL_o),
        .Overflow_o(Overflow_o),
        .Zero_o(Zero_o)
    );

    // Clock generation (10ns period)
    initial begin
        Clk_i = 0;
        forever #5 Clk_i = ~Clk_i;
    end

        task reset_dut;

        begin
            Reset_n_i = 0;
            ResetSig_i = 0;
            Preset_i = 0;
            Enable_i = 0;
            Direction_i = 0;
            PresetValH_i = 16'h0;
            PresetValL_i = 16'h0;
            #15;
            Reset_n_i = 1;
            @(posedge Clk_i);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Async Reset and Initial State");
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000, 0, 1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Preset Loading");
            reset_dut();
            PresetValH_i = 16'hA5A5;
            PresetValL_i = 16'h5A5A;
            Preset_i = 1;
            @(posedge Clk_i);
            #2;
            Preset_i = 0;
            #1;

            check_outputs(16'hA5A5, 16'h5A5A, 0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Synchronous Reset (ResetSig_i)");
            reset_dut();

            PresetValH_i = 16'hFFFF;
            PresetValL_i = 16'hFFFF;
            Preset_i = 1;
            @(posedge Clk_i); #2;
            Preset_i = 0;

            ResetSig_i = 1;
            @(posedge Clk_i); #2;
            ResetSig_i = 0;
            #1;

            check_outputs(16'h0000, 16'h0000, 0, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Incrementing (Up Count)");
            reset_dut();
            Enable_i = 1;
            Direction_i = 0;
            repeat(10) @(posedge Clk_i);
            #2;
            Enable_i = 0;
            #1;

            check_outputs(16'h0000, 16'h000A, 0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Decrementing (Down Count)");
            reset_dut();

            PresetValH_i = 16'h0000;
            PresetValL_i = 16'h000A;
            Preset_i = 1;
            @(posedge Clk_i); #2;
            Preset_i = 0;

            Enable_i = 1;
            Direction_i = 1;
            repeat(5) @(posedge Clk_i);
            #2;
            Enable_i = 0;
            #1;

            check_outputs(16'h0000, 16'h0005, 0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Enable Control (Pause Counting)");
            reset_dut();
            Enable_i = 1;
            repeat(5) @(posedge Clk_i);
            Enable_i = 0;
            repeat(5) @(posedge Clk_i);
            #2;
            #1;

            check_outputs(16'h0000, 16'h0005, 0, 0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Roll-over Up (Max to Zero)");
            reset_dut();
            PresetValH_i = 16'hFFFF;
            PresetValL_i = 16'hFFFF;
            Preset_i = 1;
            @(posedge Clk_i); #2;
            Preset_i = 0;
            Enable_i = 1;
            Direction_i = 0;
            @(posedge Clk_i); #2;
            Enable_i = 0;
            #1;

            check_outputs(16'h0000, 16'h0000, 0, 1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Roll-under Down (Zero to Max)");
            reset_dut();
            Enable_i = 1;
            Direction_i = 1;
            @(posedge Clk_i); #2;
            Enable_i = 0;
            #1;

            check_outputs(16'hFFFF, 16'hFFFF, 0, 0);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Preset Priority over Enable");
            reset_dut();
            Enable_i = 1;
            Direction_i = 0;
            Preset_i = 1;
            PresetValH_i = 16'h1234;
            PresetValL_i = 16'h5678;
            @(posedge Clk_i); #2;
            Preset_i = 0;
            Enable_i = 0;

            #1;


            check_outputs(16'h1234, 16'h5678, 0, 0);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Zero Flag Transition");
            reset_dut();
            PresetValL_i = 16'h0001;
            Preset_i = 1;
            @(posedge Clk_i); #2;
            Preset_i = 0;
            Direction_i = 1;
            Enable_i = 1;
            @(posedge Clk_i); #2;
            Enable_i = 0;

            #1;


            check_outputs(16'h0000, 16'h0000, 0, 1);
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
        testcase009();
        testcase010();
        
        
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
        input [15:0] expected_DH_o;
        input [15:0] expected_DL_o;
        input expected_Overflow_o;
        input expected_Zero_o;
        begin
            if (expected_DH_o === (expected_DH_o ^ DH_o ^ expected_DH_o) &&
                expected_DL_o === (expected_DL_o ^ DL_o ^ expected_DL_o) &&
                expected_Overflow_o === (expected_Overflow_o ^ Overflow_o ^ expected_Overflow_o) &&
                expected_Zero_o === (expected_Zero_o ^ Zero_o ^ expected_Zero_o)) begin
                $display("PASS");
                $display("  Outputs: DH_o=%h, DL_o=%h, Overflow_o=%b, Zero_o=%b",
                         DH_o, DL_o, Overflow_o, Zero_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DH_o=%h, DL_o=%h, Overflow_o=%b, Zero_o=%b",
                         expected_DH_o, expected_DL_o, expected_Overflow_o, expected_Zero_o);
                $display("  Got:      DH_o=%h, DL_o=%h, Overflow_o=%b, Zero_o=%b",
                         DH_o, DL_o, Overflow_o, Zero_o);
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
        $dumpvars(0,Clk_i, Direction_i, Enable_i, PresetValH_i, PresetValL_i, Preset_i, ResetSig_i, Reset_n_i, DH_o, DL_o, Overflow_o, Zero_o);
    end

endmodule
