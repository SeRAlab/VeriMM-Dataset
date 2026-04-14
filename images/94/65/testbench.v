`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg enable;
    reg [7:0] input_num;
    reg reset;
    wire [15:0] output_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .enable(enable),
        .input_num(input_num),
        .reset(reset),
        .output_num(output_num)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            input_num = 0;
            @(posedge CLK);
            #1;
            reset = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Check");
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Multiply (5 * 2)");
            reset_dut();
            input_num = 8'd5;
            enable = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(16'd10);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Max Input Multiply (255 * 2)");
            reset_dut();
            input_num = 8'hFF;
            enable = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(16'd510);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Enable Low Check");
            reset_dut();
            input_num = 8'd50;
            enable = 0;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Multiply Zero (0 * 2)");
            reset_dut();
            input_num = 8'h00;
            enable = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Bit Pattern Check (0xAA * 2)");
            reset_dut();
            input_num = 8'hAA;
            enable = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(16'h0154);
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
        input [15:0] expected_output_num;
        begin
            if (expected_output_num === (expected_output_num ^ output_num ^ expected_output_num)) begin
                $display("PASS");
                $display("  Outputs: output_num=%h",
                         output_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_num=%h",
                         expected_output_num);
                $display("  Got:      output_num=%h",
                         output_num);
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
        $dumpvars(0,CLK, enable, input_num, reset, output_num);
    end

endmodule
