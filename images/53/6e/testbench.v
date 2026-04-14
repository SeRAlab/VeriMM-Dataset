`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] Colors;
    reg DisplayColors;
    reg clk;
    reg reset;
    wire [1:0] ColorOut;
    wire SetColors;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Colors(Colors),
        .DisplayColors(DisplayColors),
        .clk(clk),
        .reset(reset),
        .ColorOut(ColorOut),
        .SetColors(SetColors)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            Colors = 32'h0;
            DisplayColors = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Initial color output check");
            reset_dut();
            Colors = 32'h00000003;
            DisplayColors = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Check second chunk (bits 3:2)");
            reset_dut();
            Colors = 32'h00000004;
            DisplayColors = 1;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(2'b01, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Check middle chunk (bits 17:16)");
            reset_dut();
            Colors = 32'h00030000;
            DisplayColors = 1;
            repeat(9) @(posedge clk);
            #2;
            #1;

            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Wrap around from end to start");
            reset_dut();
            Colors = 32'h00000002;
            DisplayColors = 1;

            repeat(17) @(posedge clk);
            #2;
            #1;

            check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: DisplayColors low check");
            reset_dut();
            Colors = 32'hFFFFFFFF;
            DisplayColors = 0;
            repeat(5) @(posedge clk);
            #2;

            #1;


            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Alternating pattern check");
            reset_dut();
            Colors = 32'hAAAAAAAA;
            DisplayColors = 1;
            repeat(12) @(posedge clk);
            #2;
            #1;

            check_outputs(2'b10, 1'b1);
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
        input [1:0] expected_ColorOut;
        input expected_SetColors;
        begin
            if (expected_ColorOut === (expected_ColorOut ^ ColorOut ^ expected_ColorOut) &&
                expected_SetColors === (expected_SetColors ^ SetColors ^ expected_SetColors)) begin
                $display("PASS");
                $display("  Outputs: ColorOut=%h, SetColors=%b",
                         ColorOut, SetColors);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ColorOut=%h, SetColors=%b",
                         expected_ColorOut, expected_SetColors);
                $display("  Got:      ColorOut=%h, SetColors=%b",
                         ColorOut, SetColors);
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
        $dumpvars(0,Colors, DisplayColors, clk, reset, ColorOut, SetColors);
    end

endmodule
