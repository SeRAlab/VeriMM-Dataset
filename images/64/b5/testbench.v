`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] binary_in;
    reg clk;
    reg reset;
    wire [2:0] ones_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_in(binary_in),
        .clk(clk),
        .reset(reset),
        .ones_count(ones_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        binary_in = 4'b0000;
        @(posedge clk);
        #1 reset = 0;
    end
        endtask
    task testcase001;

    begin
        $display("Test Case 001: input 4'b0000");
        reset_dut();
        binary_in = 4'b0000;
        @(posedge clk);
        #1 #1;
 check_outputs(3'd0);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: input 4'b0001");
        reset_dut();
        binary_in = 4'b0001;
        @(posedge clk);
        #1 #1;
 check_outputs(3'd1);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: input 4'b1000");
        reset_dut();
        binary_in = 4'b1000;
        @(posedge clk);
        #1 #1;
 check_outputs(3'd1);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: input 4'b0011");
        reset_dut();
        binary_in = 4'b0011;
        @(posedge clk);
        #1 #1;
 check_outputs(3'd2);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: input 4'b1010");
        reset_dut();
        binary_in = 4'b1010;
        @(posedge clk);
        #1 #1;
 check_outputs(3'd2);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: input 4'b0111");
        reset_dut();
        binary_in = 4'b0111;
        @(posedge clk);
        #1 #1;
 check_outputs(3'd3);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: input 4'b1011");
        reset_dut();
        binary_in = 4'b1011;
        @(posedge clk);
        #1 #1;
 check_outputs(3'd3);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: input 4'b1111");
        reset_dut();
        binary_in = 4'b1111;
        @(posedge clk);
        #1 #1;
 check_outputs(3'd4);
    end
        endtask

    task testcase009;

    begin
        $display("Test Case 009: Check reset during operation");
        reset_dut();
        binary_in = 4'b1111;
        @(posedge clk);
        #1;
        reset = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(3'd0);
    end
        endtask

    task testcase010;

    begin
        $display("Test Case 010: Back-to-back inputs");
        reset_dut();

        binary_in = 4'b0101;
        @(posedge clk);
        #1;

        binary_in = 4'b1110;
        @(posedge clk);
        #1 #1;
 check_outputs(3'd3);
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
        testcase009();
        testcase010();
        
        
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
        input [2:0] expected_ones_count;
        begin
            if (expected_ones_count === (expected_ones_count ^ ones_count ^ expected_ones_count)) begin
                $display("PASS");
                $display("  Outputs: ones_count=%h",
                         ones_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ones_count=%h",
                         expected_ones_count);
                $display("  Got:      ones_count=%h",
                         ones_count);
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
        $dumpvars(0,binary_in, clk, reset, ones_count);
    end

endmodule
