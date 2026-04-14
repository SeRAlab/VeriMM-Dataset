`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] Instruction_in;
    reg [31:0] PC_in;
    reg clk;
    reg flush;
    reg freeze;
    reg reset;
    wire [31:0] Instruction;
    wire [31:0] PC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Instruction_in(Instruction_in),
        .PC_in(PC_in),
        .clk(clk),
        .flush(flush),
        .freeze(freeze),
        .reset(reset),
        .Instruction(Instruction),
        .PC(PC)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        freeze = 0;
        flush = 0;
        PC_in = 32'h0;
        Instruction_in = 32'h0;
        @(posedge clk);
        #1 reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        PC_in = 32'hA5A5A5A5;
        Instruction_in = 32'h12345678;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h12345678, 32'hA5A5A5A5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        PC_in = 32'h11111111;
        Instruction_in = 32'hEEEEEEEE;
        @(posedge clk);
        #1;

        freeze = 1;
        PC_in = 32'hFFFFFFFF;
        Instruction_in = 32'hBBBBBBBB;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'hEEEEEEEE, 32'h11111111);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        PC_in = 32'h22222222;
        Instruction_in = 32'hCCCCCCCC;
        @(posedge clk);
        #1;

        flush = 1;
        PC_in = 32'hFFFFFFFF;
        Instruction_in = 32'hDDDDDDDD;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h00000000, 32'h22222222);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        PC_in = 32'h33333333;
        Instruction_in = 32'h99999999;
        @(posedge clk);
        #1;

        freeze = 1;
        flush = 1;
        PC_in = 32'h0;
        Instruction_in = 32'h0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h99999999, 32'h33333333);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();

        PC_in = 32'h44444444;
        Instruction_in = 32'h77777777;
        @(posedge clk);
        #1;

        reset = 1;
        freeze = 1;
        flush = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0, 32'h0);
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
        input [31:0] expected_Instruction;
        input [31:0] expected_PC;
        begin
            if (expected_Instruction === (expected_Instruction ^ Instruction ^ expected_Instruction) &&
                expected_PC === (expected_PC ^ PC ^ expected_PC)) begin
                $display("PASS");
                $display("  Outputs: Instruction=%h, PC=%h",
                         Instruction, PC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Instruction=%h, PC=%h",
                         expected_Instruction, expected_PC);
                $display("  Got:      Instruction=%h, PC=%h",
                         Instruction, PC);
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
        $dumpvars(0,Instruction_in, PC_in, clk, flush, freeze, reset, Instruction, PC);
    end

endmodule
