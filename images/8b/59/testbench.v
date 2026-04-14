`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] PC_in;
    reg clk;
    reg rst;
    wire [31:0] PC_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PC_in(PC_in),
        .clk(clk),
        .rst(rst),
        .PC_out(PC_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            PC_in = 32'h0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Verifying reset...");
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Loading 0x12345678...");
            reset_dut();
            PC_in = 32'h12345678;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Loading 0xFFFFFFFF...");
            reset_dut();
            PC_in = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Verifying multi-cycle sequential update...");
            reset_dut();

            PC_in = 32'hA;
            @(posedge clk);
            #1;

            PC_in = 32'hB;
            @(posedge clk);
            #1;

            PC_in = 32'hC;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0000000C);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Verifying reset priority during input...");
            reset_dut();

            PC_in = 32'h5555AAAA;
            @(posedge clk);
            #1;


            rst = 1;
            PC_in = 32'hEEEEEEEE;
            @(posedge clk);
            #1;
            rst = 0;

            #1;


            check_outputs(32'h00000000);
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
        input [31:0] expected_PC_out;
        begin
            if (expected_PC_out === (expected_PC_out ^ PC_out ^ expected_PC_out)) begin
                $display("PASS");
                $display("  Outputs: PC_out=%h",
                         PC_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PC_out=%h",
                         expected_PC_out);
                $display("  Got:      PC_out=%h",
                         PC_out);
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
        $dumpvars(0,PC_in, clk, rst, PC_out);
    end

endmodule
