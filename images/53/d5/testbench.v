`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk_i;
    reg Direction_i;
    reg Enable_i;
    reg [15:0] PresetVal_i;
    reg Preset_i;
    reg Reset_n_i;
    wire [15:0] Count_o;
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
        .PresetVal_i(PresetVal_i),
        .Preset_i(Preset_i),
        .Reset_n_i(Reset_n_i),
        .Count_o(Count_o),
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
        Preset_i = 0;
        Enable_i = 0;
        Direction_i = 0;
        PresetVal_i = 16'h0000;
        #15;
        Reset_n_i = 1;
        #5;
    end
        endtask
    task testcase001;

    begin
        $display("\nRunning testcase001: Async Reset Verification");
        reset_dut();

        #1;


        check_outputs(16'h0000, 1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning testcase002: Up Counting");
        reset_dut();
        @(negedge Clk_i);
        Enable_i = 1;
        Direction_i = 1;
        repeat(10) @(negedge Clk_i);
        #1;

        check_outputs(16'd10, 1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning testcase003: Down Counting");
        reset_dut();

        @(negedge Clk_i);
        PresetVal_i = 16'h0020;
        Preset_i = 1;
        @(negedge Clk_i);
        Preset_i = 0;

        Enable_i = 1;
        Direction_i = 0;
        repeat(5) @(negedge Clk_i);
        #1;

        check_outputs(16'h001B, 1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning testcase004: Preset Load");
        reset_dut();
        @(negedge Clk_i);
        PresetVal_i = 16'hABCD;
        Preset_i = 1;
        @(negedge Clk_i);
        Preset_i = 0;
        #1;

        check_outputs(16'hABCD, 1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning testcase005: Enable Inhibition");
        reset_dut();
        @(negedge Clk_i);
        Enable_i = 0;
        Direction_i = 1;
        repeat(5) @(negedge Clk_i);
        #1;

        check_outputs(16'h0000, 1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("\nRunning testcase006: Rollover Up (0xFFFF to 0x0000)");
        reset_dut();
        @(negedge Clk_i);
        PresetVal_i = 16'hFFFF;
        Preset_i = 1;
        @(negedge Clk_i);
        Preset_i = 0;
        Enable_i = 1;
        Direction_i = 1;
        @(negedge Clk_i);
        #1;

        check_outputs(16'h0000, 1'b1);
    end
        endtask

    task testcase007;

    begin
        $display("\nRunning testcase007: Roll-under Down (0x0000 to 0xFFFF)");
        reset_dut();
        @(negedge Clk_i);
        Enable_i = 1;
        Direction_i = 0;
        @(negedge Clk_i);
        #1;

        check_outputs(16'hFFFF, 1'b0);
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
        input [15:0] expected_Count_o;
        input expected_Zero_o;
        begin
            if (expected_Count_o === (expected_Count_o ^ Count_o ^ expected_Count_o) &&
                expected_Zero_o === (expected_Zero_o ^ Zero_o ^ expected_Zero_o)) begin
                $display("PASS");
                $display("  Outputs: Count_o=%h, Zero_o=%b",
                         Count_o, Zero_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Count_o=%h, Zero_o=%b",
                         expected_Count_o, expected_Zero_o);
                $display("  Got:      Count_o=%h, Zero_o=%b",
                         Count_o, Zero_o);
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
        $dumpvars(0,Clk_i, Direction_i, Enable_i, PresetVal_i, Preset_i, Reset_n_i, Count_o, Zero_o);
    end

endmodule
