`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg cken_in;
    reg clk;
    reg [2:0] decimrate;
    reg [11:0] din;
    reg reset;
    wire cken_out;
    wire [19:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cken_in(cken_in),
        .clk(clk),
        .decimrate(decimrate),
        .din(din),
        .reset(reset),
        .cken_out(cken_out),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        cken_in = 0;
        din = 0;
        decimrate = 0;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Running Testcase001: decimrate=0 (M=2)...");
        decimrate = 3'd0;
        @(posedge clk);

        din = 12'd100; cken_in = 1; @(posedge clk);
        din = 12'd200; cken_in = 1; @(posedge clk);
        cken_in = 0;

        while (cken_out !== 1'b1) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 20'd300);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Running Testcase002: decimrate=1 (M=4)...");
        decimrate = 3'd1;
        @(posedge clk);

        din = 12'd10; cken_in = 1; @(posedge clk);
        din = 12'd20; cken_in = 1; @(posedge clk);
        din = 12'd30; cken_in = 1; @(posedge clk);
        din = 12'd40; cken_in = 1; @(posedge clk);
        cken_in = 0;
        while (cken_out !== 1'b1) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 20'd100);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Running Testcase003: decimrate=2 (M=8)...");
        decimrate = 3'd2;
        @(posedge clk);

        repeat(8) begin
            din = 12'd1; cken_in = 1; @(posedge clk);
        end
        cken_in = 0;
        while (cken_out !== 1'b1) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 20'd8);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Running Testcase004: cken_in Gating Test (M=2)...");
        decimrate = 3'd0;
        @(posedge clk);

        din = 12'd500; cken_in = 1; @(posedge clk);

        cken_in = 0;
        din = 12'd999; repeat(3) @(posedge clk);

        din = 12'd500; cken_in = 1; @(posedge clk);
        cken_in = 0;
        while (cken_out !== 1'b1) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 20'd1000);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Running Testcase005: decimrate=3 (M=16) Max Values...");
        decimrate = 3'd3;
        @(posedge clk);
        repeat(16) begin
            din = 12'hFFF;
            cken_in = 1; @(posedge clk);
        end
        cken_in = 0;
        while (cken_out !== 1'b1) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 20'd65520);
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
        input expected_cken_out;
        input [19:0] expected_dout;
        begin
            if (expected_cken_out === (expected_cken_out ^ cken_out ^ expected_cken_out) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: cken_out=%b, dout=%h",
                         cken_out, dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cken_out=%b, dout=%h",
                         expected_cken_out, expected_dout);
                $display("  Got:      cken_out=%b, dout=%h",
                         cken_out, dout);
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
        $dumpvars(0,cken_in, clk, decimrate, din, reset, cken_out, dout);
    end

endmodule
