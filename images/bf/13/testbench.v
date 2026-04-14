`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clock;
    reg debugEnable;
    reg debugReset;
    reg [31:0] instruction;
    reg notEnable;
    reg [7:0] pcNext;
    reg reset;
    wire [31:0] instructionOut;
    wire [7:0] pcNextOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clock(clock),
        .debugEnable(debugEnable),
        .debugReset(debugReset),
        .instruction(instruction),
        .notEnable(notEnable),
        .pcNext(pcNext),
        .reset(reset),
        .instructionOut(instructionOut),
        .pcNextOut(pcNextOut)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            debugReset = 0;
            debugEnable = 0;
            notEnable = 0;
            clear = 0;
            instruction = 32'h0;
            pcNext = 8'h0;
            @(negedge clock);
            reset = 0;
            @(negedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Global Reset", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 8'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Normal Capture", test_num);
            reset_dut();
            debugEnable = 1;
            notEnable = 0;
            instruction = 32'hA5A5A5A5;
            pcNext = 8'h10;
            @(negedge clock);
            #1;
            #1;

            check_outputs(32'hA5A5A5A5, 8'h10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Write Inhibition (notEnable=1)", test_num);
            reset_dut();


            debugEnable = 1;
            notEnable = 0;
            instruction = 32'h11111111;
            pcNext = 8'h01;
            @(negedge clock);


            notEnable = 1;
            instruction = 32'hEEEEEEEE;
            pcNext = 8'hFF;
            @(negedge clock);
            #1;

            #1;


            check_outputs(32'h11111111, 8'h01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Write Inhibition (debugEnable=0)", test_num);
            reset_dut();


            debugEnable = 1;
            notEnable = 0;
            instruction = 32'h22222222;
            pcNext = 8'h02;
            @(negedge clock);


            debugEnable = 0;
            instruction = 32'hDDDDDDDD;
            pcNext = 8'hEE;
            @(negedge clock);
            #1;

            #1;


            check_outputs(32'h22222222, 8'h02);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Clear Instruction while enabled", test_num);
            reset_dut();

            debugEnable = 1;
            notEnable = 0;
            clear = 1;
            instruction = 32'h12345678;
            pcNext = 8'h40;
            @(negedge clock);
            #1;

            #1;


            check_outputs(32'h0, 8'h40);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: debugReset check", test_num);
            reset_dut();


            debugEnable = 1;
            notEnable = 0;
            instruction = 32'hFFFFFFFF;
            pcNext = 8'hAA;
            @(negedge clock);


            debugReset = 1;
            @(negedge clock);
            #1;

            #1;


            check_outputs(32'h0, 8'h0);
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
        input [31:0] expected_instructionOut;
        input [7:0] expected_pcNextOut;
        begin
            if (expected_instructionOut === (expected_instructionOut ^ instructionOut ^ expected_instructionOut) &&
                expected_pcNextOut === (expected_pcNextOut ^ pcNextOut ^ expected_pcNextOut)) begin
                $display("PASS");
                $display("  Outputs: instructionOut=%h, pcNextOut=%h",
                         instructionOut, pcNextOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instructionOut=%h, pcNextOut=%h",
                         expected_instructionOut, expected_pcNextOut);
                $display("  Got:      instructionOut=%h, pcNextOut=%h",
                         instructionOut, pcNextOut);
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
        $dumpvars(0,clear, clock, debugEnable, debugReset, instruction, notEnable, pcNext, reset, instructionOut, pcNextOut);
    end

endmodule
