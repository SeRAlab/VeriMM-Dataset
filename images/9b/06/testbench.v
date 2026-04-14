`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] addr;
    reg clk;
    reg cs;
    reg [15:0] d_in;
    reg micData;
    reg rd;
    reg reset;
    reg rst;
    reg start;
    reg wr;
    wire [15:0] d_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .cs(cs),
        .d_in(d_in),
        .micData(micData),
        .rd(rd),
        .reset(reset),
        .rst(rst),
        .start(start),
        .wr(wr),
        .d_out(d_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 0;
            reset = 0;
            start = 0;
            cs = 0;
            rd = 0;
            wr = 0;
            d_in = 0;
            addr = 0;
            micData = 0;
            repeat (2) @(posedge clk);
            rst = 1;
            reset = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            cs = 1;
            rd = 1;
            addr = 2'b00;
            @(posedge clk);
            #1;
            $display("Test Case 001: Read Address 0 after Reset");
            #1;

            check_outputs(16'h0000);
            cs = 0;
            rd = 0;
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            d_in = 16'hABCD;
            addr = 2'b00;
            start = 1;
            wr = 1;
            @(posedge clk);
            start = 0;
            wr = 0;

            cs = 1;
            rd = 1;
            @(posedge clk);
            #1;
            $display("Test Case 002: Write/Read ABCD to Address 0");
            #1;

            check_outputs(16'hABCD);
            cs = 0;
            rd = 0;
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            d_in = 16'h1234;
            addr = 2'b11;
            start = 1;
            wr = 1;
            @(posedge clk);
            start = 0;
            wr = 0;

            cs = 1;
            rd = 1;
            @(posedge clk);
            #1;
            $display("Test Case 003: Write/Read 1234 to Address 3");
            #1;

            check_outputs(16'h1234);
            cs = 0;
            rd = 0;
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            d_in = 16'h5555;
            addr = 2'b01;
            start = 1;
            wr = 1;
            @(posedge clk);
            start = 0;
            wr = 0;

            cs = 0;
            rd = 1;
            @(posedge clk);
            #1;
            $display("Test Case 004: Data out 0 when CS is low");
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            d_in = 16'hAAAA;
            addr = 2'b10;
            start = 1;
            wr = 1;
            @(posedge clk);
            start = 0;
            wr = 0;

            cs = 1;
            rd = 0;
            @(posedge clk);
            #1;
            $display("Test Case 005: Data out 0 when RD is low");
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            addr = 0; d_in = 16'h0001; start = 1; wr = 1; @(posedge clk);
            addr = 1; d_in = 16'h0002; @(posedge clk);
            addr = 2; d_in = 16'h0004; @(posedge clk);
            addr = 3; d_in = 16'h0008; @(posedge clk);
            start = 0; wr = 0;


            addr = 2'b10;
            cs = 1;
            rd = 1;
            @(posedge clk);
            #1;
            $display("Test Case 006: Multiple Register Integrity (Addr 2)");
            #1;

            check_outputs(16'h0004);
            cs = 0;
            rd = 0;
        end
        endtask

    task testcase007;

        begin
            reset_dut();

            d_in = 16'hFFFF;
            addr = 2'b00;
            start = 1; wr = 1; @(posedge clk);
            start = 0; wr = 0;


            reset = 0;
            @(posedge clk);
            reset = 1;


            cs = 1;
            rd = 1;
            addr = 2'b00;
            @(posedge clk);
            #1;
            $display("Test Case 007: Secondary Reset (active low 'reset') Verification");
            #1;

            check_outputs(16'h0000);
            cs = 0;
            rd = 0;
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
        input [15:0] expected_d_out;
        begin
            if (expected_d_out === (expected_d_out ^ d_out ^ expected_d_out)) begin
                $display("PASS");
                $display("  Outputs: d_out=%h",
                         d_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out=%h",
                         expected_d_out);
                $display("  Got:      d_out=%h",
                         d_out);
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
        $dumpvars(0,addr, clk, cs, d_in, micData, rd, reset, rst, start, wr, d_out);
    end

endmodule
