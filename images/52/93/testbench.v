`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg enable;
    reg [5:0] in;
    wire [5:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .enable(enable),
        .in(in),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clear = 1;
            enable = 1;
            in = 0;
            @(posedge clk);
            #1;
            clear = 0;
            enable = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Load Operation");
            reset_dut();
            in = 6'h3F;
            enable = 1;
            clear = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'h3F);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Synchronous Clear Operation");
            reset_dut();

            in = 6'h2A;
            enable = 1;
            clear = 0;
            @(posedge clk);
            #1;

            clear = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'h00);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Data Hold (Enable low)");
            reset_dut();

            in = 6'h15;
            enable = 1;
            clear = 0;
            @(posedge clk);
            #1;

            enable = 0;
            in = 6'h3F;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'h15);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Clear ignored when Enable is low");
            reset_dut();

            in = 6'h0F;
            enable = 1;
            clear = 0;
            @(posedge clk);
            #1;

            enable = 0;
            clear = 1;
            in = 6'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'h0F);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Toggling all bits");
            reset_dut();

            in = 6'h3F;
            enable = 1;
            clear = 0;
            @(posedge clk);
            #1;

            in = 6'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'h00);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Rapid change of inputs");
            reset_dut();
            enable = 1;
            clear = 0;
            in = 6'h11;
            @(posedge clk);
            #1;
            in = 6'h22;
            @(posedge clk);
            #1;
            in = 6'h33;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'h33);
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
        input [5:0] expected_out;
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
        $dumpvars(0,clear, clk, enable, in, out);
    end

endmodule
