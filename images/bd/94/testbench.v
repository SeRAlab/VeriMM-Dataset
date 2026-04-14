`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg flush;
    reg [63:0] reg_in;
    reg reset;
    wire [63:0] reg_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .flush(flush),
        .reg_in(reg_in),
        .reset(reset),
        .reg_out(reg_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            flush = 0;
            reg_in = 0;
            #10;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase 001: Basic Reset");
            reset_dut();

            #1;


            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase 002: Data Loading");
            reset_dut();
            reg_in = 64'hDEADBEEFCAFEBABE;
            flush = 0;
            reset = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'hDEADBEEFCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase 003: Synchronous Flush");
            reset_dut();

            reg_in = 64'h1111222233334444;
            @(posedge clk);
            #2;

            flush = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase 004: Reset Priority");
            reset_dut();
            reg_in = 64'hFFFFFFFFFFFFFFFF;
            @(posedge clk);
            #2;
            reset = 1;
            #1;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase 005: Flush with Input Data");
            reset_dut();
            reg_in = 64'hABCDEF0123456789;
            flush = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase 006: Continuous Data Stream");
            reset_dut();

            reg_in = 64'h1;
            @(posedge clk);
            #1;

            reg_in = 64'h2;
            @(posedge clk);
            #1;

            reg_in = 64'h3;
            @(posedge clk);
            #2;

            #1;


            check_outputs(64'h3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Running Testcase 007: Zero Load");
            reset_dut();
            reg_in = 64'hFFFFFFFFFFFFFFFF;
            @(posedge clk);
            #2;
            reg_in = 64'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h0);
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
        input [63:0] expected_reg_out;
        begin
            if (expected_reg_out === (expected_reg_out ^ reg_out ^ expected_reg_out)) begin
                $display("PASS");
                $display("  Outputs: reg_out=%h",
                         reg_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_out=%h",
                         expected_reg_out);
                $display("  Got:      reg_out=%h",
                         reg_out);
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
        $dumpvars(0,clk, flush, reg_in, reset, reg_out);
    end

endmodule
