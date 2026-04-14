`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg if_id_write;
    reg [31:0] instruction;
    reg [31:0] pc;
    reg [31:0] pc_4;
    reg reset;
    wire [31:0] instr_out;
    wire [31:0] pc_4_out;
    wire [31:0] pc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .if_id_write(if_id_write),
        .instruction(instruction),
        .pc(pc),
        .pc_4(pc_4),
        .reset(reset),
        .instr_out(instr_out),
        .pc_4_out(pc_4_out),
        .pc_out(pc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            if_id_write = 0;
            instruction = 0;
            pc = 0;
            pc_4 = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Reset Check");
            reset_dut();

            #1;


            check_outputs(32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write Enabled Check");
            reset_dut();
            pc = 32'h0000_1000;
            pc_4 = 32'h0000_1004;
            instruction = 32'h0123_4567;
            if_id_write = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0123_4567, 32'h0000_1004, 32'h0000_1000);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write Disabled Check (Outputs should be zero)");
            reset_dut();

            pc = 32'h0000_2000;
            pc_4 = 32'h0000_2004;
            instruction = 32'hFFFF_FFFF;
            if_id_write = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Transition from Enabled to Disabled");
            reset_dut();

            pc = 32'h0000_3000;
            pc_4 = 32'h0000_3004;
            instruction = 32'hAAAA_BBBB;
            if_id_write = 1;
            @(posedge clk);
            #1;

            if_id_write = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Reset Priority Check");
            reset_dut();
            pc = 32'h0000_4000;
            pc_4 = 32'h0000_4004;
            instruction = 32'h1111_2222;
            if_id_write = 1;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Consecutive Writes Check");
            reset_dut();

            pc = 32'hA000; pc_4 = 32'hA004; instruction = 32'h1;
            if_id_write = 1;
            @(posedge clk);
            #1;

            pc = 32'hB000; pc_4 = 32'hB004; instruction = 32'h2;
            if_id_write = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h2, 32'hB004, 32'hB000);
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
        input [31:0] expected_instr_out;
        input [31:0] expected_pc_4_out;
        input [31:0] expected_pc_out;
        begin
            if (expected_instr_out === (expected_instr_out ^ instr_out ^ expected_instr_out) &&
                expected_pc_4_out === (expected_pc_4_out ^ pc_4_out ^ expected_pc_4_out) &&
                expected_pc_out === (expected_pc_out ^ pc_out ^ expected_pc_out)) begin
                $display("PASS");
                $display("  Outputs: instr_out=%h, pc_4_out=%h, pc_out=%h",
                         instr_out, pc_4_out, pc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instr_out=%h, pc_4_out=%h, pc_out=%h",
                         expected_instr_out, expected_pc_4_out, expected_pc_out);
                $display("  Got:      instr_out=%h, pc_4_out=%h, pc_out=%h",
                         instr_out, pc_4_out, pc_out);
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
        $dumpvars(0,clk, if_id_write, instruction, pc, pc_4, reset, instr_out, pc_4_out, pc_out);
    end

endmodule
