`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg [15:0] strand_idx;
    reg [15:0] strand_length;
    reg [15:0] strand_offset;
    wire [23:0] addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst_n(rst_n),
        .strand_idx(strand_idx),
        .strand_length(strand_length),
        .strand_offset(strand_offset),
        .addr(addr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            strand_idx = 0;
            strand_length = 0;
            strand_offset = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            strand_offset = 16'h1000;
            strand_idx = 16'h0005;
            strand_length = 16'h0010;
            @(posedge clk);
            #1 #1;
 check_outputs(24'h001005);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            strand_offset = 16'h1000;
            strand_idx = 16'h0010;
            strand_length = 16'h0010;
            @(posedge clk);
            #1 #1;
 check_outputs(24'h001000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            strand_offset = 16'h2000;
            strand_idx = 16'h0015;
            strand_length = 16'h0010;
            @(posedge clk);
            #1 #1;
 check_outputs(24'h002005);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            strand_offset = 16'hFFFF;
            strand_idx = 16'h000A;
            strand_length = 16'hFFFF;
            @(posedge clk);
            #1 #1;
 check_outputs(24'h010009);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            strand_offset = 16'h0000;
            strand_idx = 16'hFFFF;
            strand_length = 16'h0001;
            @(posedge clk);
            #1 #1;
 check_outputs(24'h00FFFE);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            strand_offset = 16'h0000;
            strand_idx = 16'h0005;
            strand_length = 16'h0020;
            @(posedge clk);
            #1 #1;
 check_outputs(24'h000005);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            strand_offset = 16'h0500;
            strand_idx = 16'h000A;
            strand_length = 16'h0000;
            @(posedge clk);
            #1 #1;
 check_outputs(24'h050A);
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
        input [23:0] expected_addr;
        begin
            if (expected_addr === (expected_addr ^ addr ^ expected_addr)) begin
                $display("PASS");
                $display("  Outputs: addr=%h",
                         addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr=%h",
                         expected_addr);
                $display("  Got:      addr=%h",
                         addr);
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
        $dumpvars(0,clk, rst_n, strand_idx, strand_length, strand_offset, addr);
    end

endmodule
