`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ALU_input;
    reg [2:0] M2_input;
    reg [31:0] RdData2_in;
    reg [1:0] WB2_input;
    reg clk;
    reg [4:0] instruction_mux_in;
    reg reset;
    wire [31:0] ALU_output;
    wire [2:0] M2_output;
    wire [31:0] RdData2_out;
    wire [1:0] WB2_output;
    wire [4:0] instruction_mux_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_input(ALU_input),
        .M2_input(M2_input),
        .RdData2_in(RdData2_in),
        .WB2_input(WB2_input),
        .clk(clk),
        .instruction_mux_in(instruction_mux_in),
        .reset(reset),
        .ALU_output(ALU_output),
        .M2_output(M2_output),
        .RdData2_out(RdData2_out),
        .WB2_output(WB2_output),
        .instruction_mux_out(instruction_mux_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        ALU_input = 0;
        M2_input = 0;
        RdData2_in = 0;
        WB2_input = 0;
        instruction_mux_in = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Reset Verification");
        reset_dut();

        #1;


        check_outputs(32'h0, 3'h0, 32'h0, 2'h0, 5'h0);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Basic Data Propagation");
        reset_dut();


        WB2_input = 2'b11;
        M2_input = 3'b101;
        ALU_input = 32'hAAAA_BBBB;
        instruction_mux_in = 5'h1F;
        RdData2_in = 32'h1234_5678;

        @(posedge clk);
        #1;

        #1;


        check_outputs(32'hAAAA_BBBB, 3'b101, 32'h1234_5678, 2'b11, 5'h1F);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Sequential Data Update");
        reset_dut();


        WB2_input = 2'b01;
        M2_input = 3'b010;
        ALU_input = 32'h0000_1111;
        instruction_mux_in = 5'h05;
        RdData2_in = 32'hFFFF_0000;
        @(posedge clk);
        #1;


        WB2_input = 2'b10;
        M2_input = 3'b111;
        ALU_input = 32'h8888_9999;
        instruction_mux_in = 5'h10;
        RdData2_in = 32'h0000_FFFF;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h8888_9999, 3'b111, 32'h0000_FFFF, 2'b10, 5'h10);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Maximum Values Check");
        reset_dut();

        WB2_input = 2'b11;
        M2_input = 3'b111;
        ALU_input = 32'hFFFF_FFFF;
        instruction_mux_in = 5'b11111;
        RdData2_in = 32'hFFFF_FFFF;

        @(posedge clk);
        #1;

        #1;


        check_outputs(32'hFFFF_FFFF, 3'b111, 32'hFFFF_FFFF, 2'b11, 5'b11111);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Reset during operation");
        reset_dut();


        WB2_input = 2'b11;
        M2_input = 3'b111;
        ALU_input = 32'h1212_3434;
        instruction_mux_in = 5'h0A;
        RdData2_in = 32'h5656_7878;
        @(posedge clk);
        #1;


        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;


        #1;



        check_outputs(32'h0, 3'h0, 32'h0, 2'h0, 5'h0);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Alternating bit patterns");
        reset_dut();

        WB2_input = 2'b10;
        M2_input = 3'b101;
        ALU_input = 32'h5555_5555;
        instruction_mux_in = 5'b10101;
        RdData2_in = 32'hAAAA_AAAA;

        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h5555_5555, 3'b101, 32'hAAAA_AAAA, 2'b10, 5'b10101);
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
        input [31:0] expected_ALU_output;
        input [2:0] expected_M2_output;
        input [31:0] expected_RdData2_out;
        input [1:0] expected_WB2_output;
        input [4:0] expected_instruction_mux_out;
        begin
            if (expected_ALU_output === (expected_ALU_output ^ ALU_output ^ expected_ALU_output) &&
                expected_M2_output === (expected_M2_output ^ M2_output ^ expected_M2_output) &&
                expected_RdData2_out === (expected_RdData2_out ^ RdData2_out ^ expected_RdData2_out) &&
                expected_WB2_output === (expected_WB2_output ^ WB2_output ^ expected_WB2_output) &&
                expected_instruction_mux_out === (expected_instruction_mux_out ^ instruction_mux_out ^ expected_instruction_mux_out)) begin
                $display("PASS");
                $display("  Outputs: ALU_output=%h, M2_output=%h, RdData2_out=%h, WB2_output=%h, instruction_mux_out=%h",
                         ALU_output, M2_output, RdData2_out, WB2_output, instruction_mux_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_output=%h, M2_output=%h, RdData2_out=%h, WB2_output=%h, instruction_mux_out=%h",
                         expected_ALU_output, expected_M2_output, expected_RdData2_out, expected_WB2_output, expected_instruction_mux_out);
                $display("  Got:      ALU_output=%h, M2_output=%h, RdData2_out=%h, WB2_output=%h, instruction_mux_out=%h",
                         ALU_output, M2_output, RdData2_out, WB2_output, instruction_mux_out);
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
        $dumpvars(0,ALU_input, M2_input, RdData2_in, WB2_input, clk, instruction_mux_in, reset, ALU_output, M2_output, RdData2_out, WB2_output, instruction_mux_out);
    end

endmodule
