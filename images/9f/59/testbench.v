`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg [31:0] delay_cycles;
    reg rst;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .delay_cycles(delay_cycles),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        data_in = 0;
        delay_cycles = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: 1-cycle delay");
        reset_dut();
        delay_cycles = 32'd1;
        data_in = 32'hAAAA_BBBB;

        @(posedge clk);
        data_in = 32'hCCCC_DDDD;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hAAAA_BBBB);
    end
        endtask

    task testcase002;

    integer i;
    begin
        $display("Testcase 002: 4-cycle delay");
        reset_dut();
        delay_cycles = 32'd4;
        data_in = 32'h1234_5678;

        @(posedge clk);
        data_in = 32'h0;
        for (i = 0; i < 3; i = i + 1) begin
            @(posedge clk);
        end
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h1234_5678);
    end
        endtask

    task testcase003;

    integer i;
    begin
        $display("Testcase 003: Changing delay value to 2");
        reset_dut();
        delay_cycles = 32'd2;
        data_in = 32'hFACE_B00C;

        @(posedge clk);
        data_in = 32'h0;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hFACE_B00C);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Pipeline cleared after reset");
        reset_dut();
        delay_cycles = 32'd2;
        data_in = 32'hFFFF_FFFF;
        @(posedge clk);


        rst = 1;
        @(posedge clk);
        rst = 0;


        @(posedge clk);
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Continuous stream 3-cycle delay check");
        reset_dut();
        delay_cycles = 32'd3;

        data_in = 32'h1; @(posedge clk);
        data_in = 32'h2; @(posedge clk);
        data_in = 32'h3; @(posedge clk);
        data_in = 32'h4; @(posedge clk);

        #1;
        #1;

        check_outputs(32'h0000_0001);
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
        input [31:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, delay_cycles, rst, data_out);
    end

endmodule
