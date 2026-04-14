`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [31:0] npc;
    reg reset;
    wire [31:0] pc;
    wire [31:0] pcplus;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .npc(npc),
        .reset(reset),
        .pc(pc),
        .pcplus(pcplus)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            npc = 32'h0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Reset Verification");
            reset_dut();

            #1;


            check_outputs(32'h00003000, 32'h00003004);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Basic PC Update");
            reset_dut();

            enable = 1;
            npc = 32'h00004000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00004000, 32'h00004004);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Enable Signal Logic (Hold)");
            reset_dut();

            enable = 0;
            npc = 32'h00005000;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h00003000, 32'h00003004);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Successive Updates");
            reset_dut();

            enable = 1;

            npc = 32'h00001000;
            @(posedge clk);
            #1;

            npc = 32'h00001004;
            @(posedge clk);
            #1;

            npc = 32'h00001008;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00001008, 32'h0000100C);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Boundary and Wrap-around");
            reset_dut();

            enable = 1;
            npc = 32'hFFFFFFFC;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hFFFFFFFC, 32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Intermittent Enable");
            reset_dut();


            enable = 1;
            npc = 32'h00002000;
            @(posedge clk);
            #1;


            enable = 0;
            npc = 32'h00002004;
            @(posedge clk);
            #1;


            enable = 1;
            npc = 32'h00002008;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00002008, 32'h0000200C);
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
        input [31:0] expected_pc;
        input [31:0] expected_pcplus;
        begin
            if (expected_pc === (expected_pc ^ pc ^ expected_pc) &&
                expected_pcplus === (expected_pcplus ^ pcplus ^ expected_pcplus)) begin
                $display("PASS");
                $display("  Outputs: pc=%h, pcplus=%h",
                         pc, pcplus);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc=%h, pcplus=%h",
                         expected_pc, expected_pcplus);
                $display("  Got:      pc=%h, pcplus=%h",
                         pc, pcplus);
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
        $dumpvars(0,clk, enable, npc, reset, pc, pcplus);
    end

endmodule
