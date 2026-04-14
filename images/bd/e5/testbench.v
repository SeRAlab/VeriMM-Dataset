`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [29:0] in;
    reg rst_n;
    wire [29:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .rst_n(rst_n),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        in = 30'h0;
        @(posedge clk);
        #1;
        rst_n = 1;
    end
        endtask
    task testcase001;

    begin
        $display("Running Testcase 001: Synchronous Reset Verification");
        reset_dut();

        #1;


        check_outputs(30'h00000000);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: Load standard address");
        reset_dut();
        in = 30'h12345678;
        @(posedge clk);
        #1;
        #1;

        check_outputs(30'h12345678);
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: Load maximum 30-bit value");
        reset_dut();
        in = 30'h3FFFFFFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(30'h3FFFFFFF);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: Successive address loads");
        reset_dut();
        in = 30'h00000004; @(posedge clk);
        in = 30'h00000008; @(posedge clk);
        in = 30'h0000000C; @(posedge clk);
        #1;
        #1;

        check_outputs(30'h0000000C);
    end
        endtask

    task testcase005;

    begin
        $display("Running Testcase 005: Reset priority over input");
        reset_dut();
        in = 30'h2AAAAAAA;
        @(posedge clk);
        #1;
        in = 30'h35555555;
        rst_n = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(30'h00000000);
    end
        endtask

    task testcase006;

    begin
        $display("Running Testcase 006: Data capture timing");
        reset_dut();
        in = 30'h1F1F1F1F;
        @(posedge clk);
        #1;
        in = 30'h0;
        #1;
        #1;

        check_outputs(30'h1F1F1F1F);
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
        input [29:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in, rst_n, out);
    end

endmodule
