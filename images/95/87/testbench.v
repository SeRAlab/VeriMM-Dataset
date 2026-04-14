`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] GPR;
    reg clk;
    reg [4:0] cp_cd;
    reg [1:0] cp_oper;
    reg [1:0] interrupt_signal;
    reg [31:0] return_addr;
    reg rst;
    wire [31:0] CPR;
    wire [31:0] jump_addr;
    wire jump_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .GPR(GPR),
        .clk(clk),
        .cp_cd(cp_cd),
        .cp_oper(cp_oper),
        .interrupt_signal(interrupt_signal),
        .return_addr(return_addr),
        .rst(rst),
        .CPR(CPR),
        .jump_addr(jump_addr),
        .jump_en(jump_en)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            interrupt_signal = 2'b00;
            cp_oper = 2'b00;
            cp_cd = 5'b00000;
            GPR = 32'h0;
            return_addr = 32'h0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset Verification");
            reset_dut();

            #1;


            check_outputs(32'h0, 32'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Write/Read State Memory");
            reset_dut();
            @(negedge clk);
            GPR = 32'hA5A5A5A5;
            cp_cd = 5'd10;
            cp_oper = 2'b10;
            @(posedge clk);
            #1;
            cp_oper = 2'b01;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hA5A5A5A5, 32'h0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Interrupt Signal Capture");
            reset_dut();
            @(negedge clk);
            interrupt_signal = 2'b01;
            return_addr = 32'hBADC0FFE;
            @(posedge clk);
            #2;



            #1;




            check_outputs(32'h0, 32'h00000004, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Context Switch Return Addr Storage");
            reset_dut();
            @(negedge clk);
            interrupt_signal = 2'b10;
            return_addr = 32'h80001234;
            @(posedge clk);
            #2;
            interrupt_signal = 2'b00;

            cp_cd = 5'd14;
            cp_oper = 2'b01;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h80001234, 32'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Interrupt State Clear");
            reset_dut();

            @(negedge clk);
            GPR = 32'hFFFFFFFF;
            cp_cd = 5'd8;
            cp_oper = 2'b10;
            @(posedge clk);
            #2;

            interrupt_signal = 2'b01;
            @(posedge clk);
            #2;
            interrupt_signal = 2'b00;
            cp_cd = 5'd8;
            cp_oper = 2'b01;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0, 32'h0, 1'b0);
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
        input [31:0] expected_CPR;
        input [31:0] expected_jump_addr;
        input expected_jump_en;
        begin
            if (expected_CPR === (expected_CPR ^ CPR ^ expected_CPR) &&
                expected_jump_addr === (expected_jump_addr ^ jump_addr ^ expected_jump_addr) &&
                expected_jump_en === (expected_jump_en ^ jump_en ^ expected_jump_en)) begin
                $display("PASS");
                $display("  Outputs: CPR=%h, jump_addr=%h, jump_en=%b",
                         CPR, jump_addr, jump_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CPR=%h, jump_addr=%h, jump_en=%b",
                         expected_CPR, expected_jump_addr, expected_jump_en);
                $display("  Got:      CPR=%h, jump_addr=%h, jump_en=%b",
                         CPR, jump_addr, jump_en);
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
        $dumpvars(0,GPR, clk, cp_cd, cp_oper, interrupt_signal, return_addr, rst, CPR, jump_addr, jump_en);
    end

endmodule
