`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [99:0] data;
    reg [1:0] ena;
    reg [255:0] in;
    reg load;
    reg reset;
    reg [7:0] sel;
    wire [1:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .ena(ena),
        .in(in),
        .load(load),
        .reset(reset),
        .sel(sel),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        ena = 0;
        load = 0;
        sel = 0;
        in = 0;
        data = 0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Basic Reset and Mux Selection");
        reset_dut();

        in = 256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
        sel = 8'd50;
        @(posedge clk);

        #1 #1;
 check_outputs(2'b01);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Rotator Load and Accumulation");
        reset_dut();
        in = 256'h1; sel = 8'd0;
        data = 100'h1; load = 1;
        @(posedge clk);
        load = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(2'b11);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Rotate Left");
        reset_dut();
        in = 0; sel = 0;
        data = (100'b1 << 99);
        load = 1;
        @(posedge clk);
        load = 0; ena = 2'b01;
        @(posedge clk);
        @(posedge clk);
        #1 #1;
 check_outputs(2'b01);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Rotate Right");
        reset_dut();
        in = 0; sel = 0;
        data = 100'h2;
        load = 1;
        @(posedge clk);
        load = 0; ena = 2'b10;
        @(posedge clk);
        @(posedge clk);
        #1 #1;
 check_outputs(2'b01);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Accumulator Overflow");
        reset_dut();
        in = 256'h1; sel = 0;
        data = 100'h1; load = 1;
        @(posedge clk);
        load = 0;
        @(posedge clk);
        @(posedge clk);
        #1 #1;
 check_outputs(2'b01);
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
        input [1:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data, ena, in, load, reset, sel, q);
    end

endmodule
