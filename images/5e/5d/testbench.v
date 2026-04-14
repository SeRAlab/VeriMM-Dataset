`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] instruction;
    reg [2:0] reg1_addr;
    reg [15:0] reg1_data;
    reg [2:0] reg2_addr;
    reg [15:0] reg2_data;
    reg [2:0] reg3_addr;
    reg [15:0] reg3_data;
    reg reset;
    wire [15:0] reg1_out;
    wire [15:0] reg2_out;
    wire [15:0] reg3_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .instruction(instruction),
        .reg1_addr(reg1_addr),
        .reg1_data(reg1_data),
        .reg2_addr(reg2_addr),
        .reg2_data(reg2_data),
        .reg3_addr(reg3_addr),
        .reg3_data(reg3_data),
        .reset(reset),
        .reg1_out(reg1_out),
        .reg2_out(reg2_out),
        .reg3_out(reg3_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            instruction = 8'h00;
            reg1_addr = 3'b000; reg2_addr = 3'b000; reg3_addr = 3'b000;
            reg1_data = 16'h0000; reg2_data = 16'h0000; reg3_data = 16'h0000;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Reset/IDLE Check", test_num);
            reset_dut();
            repeat (5) @(posedge clk);
            #1;

            check_outputs(16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: ADD Operation", test_num);
            reset_dut();
            instruction = 8'h01;
            reg1_addr = 3'd1; reg2_addr = 3'd2; reg3_addr = 3'd3;
            reg2_data = 16'h1111; reg3_data = 16'h2222;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(16'h3333, 16'h1111, 16'h2222);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: AND Operation", test_num);
            reset_dut();
            instruction = 8'h02;
            reg1_addr = 3'd4; reg2_addr = 3'd5; reg3_addr = 3'd6;
            reg2_data = 16'hAAAA; reg3_data = 16'hF0F0;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(16'hA0A0, 16'hAAAA, 16'hF0F0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: OR Operation", test_num);
            reset_dut();
            instruction = 8'h03;
            reg1_addr = 3'd1; reg2_addr = 3'd2; reg3_addr = 3'd3;
            reg2_data = 16'h5555; reg3_data = 16'h0F0F;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(16'h5F5F, 16'h5555, 16'h0F0F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %03d: XOR Operation", test_num);
            reset_dut();
            instruction = 8'h04;
            reg1_addr = 3'd1; reg2_addr = 3'd2; reg3_addr = 3'd3;
            reg2_data = 16'h1234; reg3_data = 16'h4321;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(16'h5115, 16'h1234, 16'h4321);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase %03d: NOT Operation", test_num);
            reset_dut();
            instruction = 8'h05;
            reg1_addr = 3'd1; reg2_addr = 3'd2;
            reg2_data = 16'h00FF;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(16'hFF00, 16'h00FF, 16'h0000);
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
        input [15:0] expected_reg1_out;
        input [15:0] expected_reg2_out;
        input [15:0] expected_reg3_out;
        begin
            if (expected_reg1_out === (expected_reg1_out ^ reg1_out ^ expected_reg1_out) &&
                expected_reg2_out === (expected_reg2_out ^ reg2_out ^ expected_reg2_out) &&
                expected_reg3_out === (expected_reg3_out ^ reg3_out ^ expected_reg3_out)) begin
                $display("PASS");
                $display("  Outputs: reg1_out=%h, reg2_out=%h, reg3_out=%h",
                         reg1_out, reg2_out, reg3_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg1_out=%h, reg2_out=%h, reg3_out=%h",
                         expected_reg1_out, expected_reg2_out, expected_reg3_out);
                $display("  Got:      reg1_out=%h, reg2_out=%h, reg3_out=%h",
                         reg1_out, reg2_out, reg3_out);
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
        $dumpvars(0,clk, instruction, reg1_addr, reg1_data, reg2_addr, reg2_data, reg3_addr, reg3_data, reset, reg1_out, reg2_out, reg3_out);
    end

endmodule
