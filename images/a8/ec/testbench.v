`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg equ;
    reg [15:0] pr2_IR;
    reg [15:0] pr3_IR;
    reg [15:0] pr4_IR;
    reg [15:0] pr5_IR;
    wire [2:0] pc_mux_select;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .equ(equ),
        .pr2_IR(pr2_IR),
        .pr3_IR(pr3_IR),
        .pr4_IR(pr4_IR),
        .pr5_IR(pr5_IR),
        .pc_mux_select(pc_mux_select)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            equ = 0;
            pr2_IR = 16'h0000;
            pr3_IR = 16'h0000;
            pr4_IR = 16'h0000;
            pr5_IR = 16'h0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Default State (Normal Increment)");
            reset_dut();

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Branch Taken (BEQ and equ=1)");
            reset_dut();
            pr2_IR = 16'h4000;
            equ = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Branch Not Taken (BEQ and equ=0)");
            reset_dut();
            pr2_IR = 16'h4000;
            equ = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Jump Instruction");
            reset_dut();
            pr2_IR = 16'h8000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Load-Word Hazard (Stall)");
            reset_dut();
            pr3_IR = 16'h3000;

            pr2_IR = 16'h1122;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Jump Register (JR)");
            reset_dut();
            pr2_IR = 16'h9000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Priority Test (Stall over Jump)");
            reset_dut();
            pr3_IR = 16'h3000;
            pr2_IR = 16'h8000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b100);
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
        input [2:0] expected_pc_mux_select;
        begin
            if (expected_pc_mux_select === (expected_pc_mux_select ^ pc_mux_select ^ expected_pc_mux_select)) begin
                $display("PASS");
                $display("  Outputs: pc_mux_select=%h",
                         pc_mux_select);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc_mux_select=%h",
                         expected_pc_mux_select);
                $display("  Got:      pc_mux_select=%h",
                         pc_mux_select);
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
        $dumpvars(0,clk, equ, pr2_IR, pr3_IR, pr4_IR, pr5_IR, pc_mux_select);
    end

endmodule
