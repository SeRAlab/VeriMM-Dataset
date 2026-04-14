`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk_i;
    reg Enable_i;
    reg [31:0] PresetVal_i;
    reg Preset_i;
    reg Reset_n_i;
    wire Zero_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk_i(Clk_i),
        .Enable_i(Enable_i),
        .PresetVal_i(PresetVal_i),
        .Preset_i(Preset_i),
        .Reset_n_i(Reset_n_i),
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
            Enable_i = 0;
            Preset_i = 0;
            PresetVal_i = 32'h0;
            @(posedge Clk_i);
            #1;
            Reset_n_i = 1;
            @(posedge Clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Preset and No Enable", test_num);
            reset_dut();
            PresetVal_i = 32'h0000_000A;
            Preset_i = 1;
            @(posedge Clk_i);
            #1;
            Preset_i = 0;
            Enable_i = 0;
            repeat(5) @(posedge Clk_i);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Countdown to Zero", test_num);
            reset_dut();
            PresetVal_i = 32'h0000_0003;
            Preset_i = 1;
            @(posedge Clk_i);
            #1;
            Preset_i = 0;
            Enable_i = 1;

            repeat(3) @(posedge Clk_i);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Enable Gating", test_num);
            reset_dut();
            PresetVal_i = 32'h0000_0002;
            Preset_i = 1;
            @(posedge Clk_i);
            #1;
            Preset_i = 0;
            Enable_i = 1;
            @(posedge Clk_i);
            #1;
            Enable_i = 0;
            repeat(3) @(posedge Clk_i);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Counter remains at Zero", test_num);
            reset_dut();
            PresetVal_i = 32'd1;
            Preset_i = 1;
            @(posedge Clk_i);
            #1;
            Preset_i = 0;
            Enable_i = 1;
            repeat(5) @(posedge Clk_i);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Mid-count Preset Override", test_num);
            reset_dut();
            PresetVal_i = 32'd10;
            Preset_i = 1;
            @(posedge Clk_i);
            #1;
            Preset_i = 0;
            Enable_i = 1;
            repeat(5) @(posedge Clk_i);
            #1;
            PresetVal_i = 32'd2;
            Preset_i = 1;
            @(posedge Clk_i);
            #1;
            Preset_i = 0;
            repeat(2) @(posedge Clk_i);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %03d: Preset with Zero Value", test_num);
            reset_dut();
            PresetVal_i = 32'hFFFF_FFFF;
            Preset_i = 1;
            @(posedge Clk_i);
            #1;
            PresetVal_i = 32'h0;
            Preset_i = 1;
            @(posedge Clk_i);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %03d: Maximum Value Load", test_num);
            reset_dut();
            PresetVal_i = 32'hFFFF_FFFF;
            Preset_i = 1;
            @(posedge Clk_i);
            #1;
            Preset_i = 0;
            Enable_i = 1;
            @(posedge Clk_i);
            #1;

            #1;


            check_outputs(1'b0);
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
        input expected_Zero_o;
        begin
            if (expected_Zero_o === (expected_Zero_o ^ Zero_o ^ expected_Zero_o)) begin
                $display("PASS");
                $display("  Outputs: Zero_o=%b",
                         Zero_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Zero_o=%b",
                         expected_Zero_o);
                $display("  Got:      Zero_o=%b",
                         Zero_o);
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
        $dumpvars(0,Clk_i, Enable_i, PresetVal_i, Preset_i, Reset_n_i, Zero_o);
    end

endmodule
