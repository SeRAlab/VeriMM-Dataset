`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg branch_en_i;
    reg [31:0] branch_target_addr_i;
    reg clk;
    reg rst;
    reg [5:0] stall;
    wire ce;
    wire [31:0] pc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .branch_en_i(branch_en_i),
        .branch_target_addr_i(branch_target_addr_i),
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .ce(ce),
        .pc(pc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            stall = 6'b0;
            branch_en_i = 1'b0;
            branch_target_addr_i = 32'h0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Reset State");
            reset_dut();

            #1;


            check_outputs(1'b0, 32'h80000000);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Active Enable Check");
            reset_dut();
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 32'h80000000);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Basic Increment");
            reset_dut();
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 32'h80000004);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Multi-cycle Increment");
            reset_dut();
            @(posedge clk);
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 32'h80000010);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Stall Handling");
            reset_dut();
            @(posedge clk);
            stall = 6'b000001;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 32'h80000000);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Branching");
            reset_dut();
            @(posedge clk);
            branch_en_i = 1'b1;
            branch_target_addr_i = 32'h12345678;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 32'h12345678);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Stall Priority over Branch");
            reset_dut();
            @(posedge clk);
            stall = 6'b111111;
            branch_en_i = 1'b1;
            branch_target_addr_i = 32'hFFFF0000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 32'h80000000);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Stall Recovery");
            reset_dut();
            @(posedge clk);
            stall = 6'b000100;
            @(posedge clk);
            stall = 6'b000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 32'h80000004);
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
        testcase008();
        
        
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
        input expected_ce;
        input [31:0] expected_pc;
        begin
            if (expected_ce === (expected_ce ^ ce ^ expected_ce) &&
                expected_pc === (expected_pc ^ pc ^ expected_pc)) begin
                $display("PASS");
                $display("  Outputs: ce=%b, pc=%h",
                         ce, pc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ce=%b, pc=%h",
                         expected_ce, expected_pc);
                $display("  Got:      ce=%b, pc=%h",
                         ce, pc);
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
        $dumpvars(0,branch_en_i, branch_target_addr_i, clk, rst, stall, ce, pc);
    end

endmodule
