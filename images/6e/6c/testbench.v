`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in;
    reg reset;
    wire [2:0] ena;
    wire [1:0] pos;
    wire [15:0] q;
    wire zero_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .ena(ena),
        .pos(pos),
        .q(q),
        .zero_flag(zero_flag)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            in = 4'b0000;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset and Initial Priority check (in=0001)...");
            @(posedge clk);
            reset = 1;
            in = 4'b0001;
            @(posedge clk);
            #1;
            reset = 0;



            #1;




            check_outputs(3'b000, 2'd0, 16'h0009, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Priority Encoder with in=1010...");
            @(posedge clk);
            reset = 1;
            in = 4'b1010;
            @(posedge clk);
            #1;
            reset = 0;

            #1;


            check_outputs(3'b000, 2'd3, 16'h0009, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Full countdown to zero...");
            reset_dut();


            repeat(9) @(posedge clk);
            #1;

            #1;


            check_outputs(3'b000, 2'd0, 16'h0000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Mid-point countdown check...");
            reset_dut();
            repeat(4) @(posedge clk);
            #1;


            #1;



            check_outputs(3'b000, 2'd0, 16'h0005, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Halting at zero...");
            reset_dut();
            repeat(15) @(posedge clk);
            #1;

            #1;


            check_outputs(3'b000, 2'd0, 16'h0000, 1'b1);
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
        input [2:0] expected_ena;
        input [1:0] expected_pos;
        input [15:0] expected_q;
        input expected_zero_flag;
        begin
            if (expected_ena === (expected_ena ^ ena ^ expected_ena) &&
                expected_pos === (expected_pos ^ pos ^ expected_pos) &&
                expected_q === (expected_q ^ q ^ expected_q) &&
                expected_zero_flag === (expected_zero_flag ^ zero_flag ^ expected_zero_flag)) begin
                $display("PASS");
                $display("  Outputs: ena=%h, pos=%h, q=%h, zero_flag=%b",
                         ena, pos, q, zero_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ena=%h, pos=%h, q=%h, zero_flag=%b",
                         expected_ena, expected_pos, expected_q, expected_zero_flag);
                $display("  Got:      ena=%h, pos=%h, q=%h, zero_flag=%b",
                         ena, pos, q, zero_flag);
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
        $dumpvars(0,clk, in, reset, ena, pos, q, zero_flag);
    end

endmodule
