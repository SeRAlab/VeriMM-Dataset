`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            clear = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Reset...");
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Clear to All Ones...");
            reset_dut();
            clear = 1;
            @(posedge clk);
            #1 clear = 0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Running testcase003: Shifting 8 bits of 1s...");
            reset_dut();
            data_in = 8'h01;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
            end
            #1 #1;
 check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] pattern;
        begin
            $display("Running testcase004: Pattern Shifting (0xA5)...");
            reset_dut();
            pattern = 8'hA5;

            for (i = 7; i >= 0; i = i - 1) begin
                data_in = {7'b0, pattern[i]};
                @(posedge clk);
            end
            #1 #1;
 check_outputs(8'hA5);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset Priority over Clear...");
            reset_dut();
            reset = 1;
            clear = 1;
            data_in = 8'hFF;
            @(posedge clk);
            #1 reset = 0;
            clear = 0;

            #1;


            check_outputs(8'h00);
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,clear, clk, data_in, reset, data_out);
    end

endmodule
