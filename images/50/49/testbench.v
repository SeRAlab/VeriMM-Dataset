`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] base;
    reg [7:0] boundary;
    reg clk;
    reg input_enable;
    wire [7:0] exponent;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .base(base),
        .boundary(boundary),
        .clk(clk),
        .input_enable(input_enable),
        .exponent(exponent),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            input_enable = 0;
            base = 9'd0;
            boundary = 8'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Base=2, Boundary=3...");
            test_num = 1;
            reset_dut();
            base = 9'd2;
            boundary = 8'd3;
            input_enable = 1;


            @(posedge ready);
            @(posedge clk); #1;
            #1;

            check_outputs(8'd3, 1'b1);
            input_enable = 0;
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Base=3, Boundary=2...");
            test_num = 2;
            reset_dut();
            base = 9'd3;
            boundary = 8'd2;
            input_enable = 1;

            @(posedge ready);
            @(posedge clk); #1;
            #1;

            check_outputs(8'd2, 1'b1);
            input_enable = 0;
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Base=1 (Identity Hit)...");
            test_num = 3;
            reset_dut();
            base = 9'd1;
            boundary = 8'd10;
            input_enable = 1;

            @(posedge ready);
            @(posedge clk); #1;
            #1;

            check_outputs(8'd2, 1'b1);
            input_enable = 0;
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Boundary=1...");
            test_num = 4;
            reset_dut();
            base = 9'd5;
            boundary = 8'd1;
            input_enable = 1;

            @(posedge ready);
            @(posedge clk); #1;
            #1;

            check_outputs(8'd1, 1'b1);
            input_enable = 0;
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Base=0...");
            test_num = 5;
            reset_dut();
            base = 9'd0;
            boundary = 8'd5;
            input_enable = 1;

            @(posedge ready);
            @(posedge clk); #1;
            #1;

            check_outputs(8'd2, 1'b1);
            input_enable = 0;
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Base=2, Boundary=8...");
            test_num = 6;
            reset_dut();
            base = 9'd2;
            boundary = 8'd8;
            input_enable = 1;

            @(posedge ready);
            @(posedge clk); #1;
            #1;

            check_outputs(8'd8, 1'b1);
            input_enable = 0;
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
        input [7:0] expected_exponent;
        input expected_ready;
        begin
            if (expected_exponent === (expected_exponent ^ exponent ^ expected_exponent) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: exponent=%h, ready=%b",
                         exponent, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: exponent=%h, ready=%b",
                         expected_exponent, expected_ready);
                $display("  Got:      exponent=%h, ready=%b",
                         exponent, ready);
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
        $dumpvars(0,base, boundary, clk, input_enable, exponent, ready);
    end

endmodule
