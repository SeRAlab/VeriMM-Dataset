`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in;
    reg reset;
    wire [1:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Zero Input");
            reset_dut();
            repeat(10) begin
                in = 4'sd0;
                @(posedge clk);
            end
            #1;

            check_outputs(2'sb00);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Positive Impulse");
            reset_dut();
            in = 4'sd1;
            @(posedge clk);
            in = 4'sd0;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(2'sb01);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Negative Impulse");
            reset_dut();
            in = -4'sd1;
            @(posedge clk);
            in = 4'sd0;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(2'sb11);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: DC Step Response");
            reset_dut();
            in = 4'sd2;
            repeat(8) @(posedge clk);

            #1;


            check_outputs(2'sb01);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Mid-operation Reset");
            reset_dut();
            in = 4'sd7;
            repeat(3) @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            in = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'sb00);
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
        input [1:0] expected_out;
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
        $dumpvars(0,clk, in, reset, out);
    end

endmodule
