`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] din;
    reg reset;
    reg start;
    wire done_tick;
    wire [6:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .reset(reset),
        .start(start),
        .done_tick(done_tick),
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
        start = 0;
        din = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Testing din=0 (Minimum boundary)", test_num);
        reset_dut();
        din = 4'd0;
        @(posedge clk);
        #1 start = 1;
        @(posedge clk);
        #1 start = 0;


        while (!done_tick) @(posedge clk);
        #1 #1;
 check_outputs(1'b1, 7'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Testing din=1", test_num);
        reset_dut();
        din = 4'd1;
        @(posedge clk);
        #1 start = 1;
        @(posedge clk);
        #1 start = 0;

        while (!done_tick) @(posedge clk);
        #1 #1;
 check_outputs(1'b1, 7'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Testing din=8", test_num);
        reset_dut();
        din = 4'd8;
        @(posedge clk);
        #1 start = 1;
        @(posedge clk);
        #1 start = 0;

        while (!done_tick) @(posedge clk);
        #1 #1;
 check_outputs(1'b1, 7'd40);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Testing din=15 (Maximum boundary)", test_num);
        reset_dut();
        din = 4'd15;
        @(posedge clk);
        #1 start = 1;
        @(posedge clk);
        #1 start = 0;

        while (!done_tick) @(posedge clk);
        #1 #1;
 check_outputs(1'b1, 7'd75);
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
        input expected_done_tick;
        input [6:0] expected_dout;
        begin
            if (expected_done_tick === (expected_done_tick ^ done_tick ^ expected_done_tick) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: done_tick=%b, dout=%h",
                         done_tick, dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done_tick=%b, dout=%h",
                         expected_done_tick, expected_dout);
                $display("  Got:      done_tick=%b, dout=%h",
                         done_tick, dout);
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
        $dumpvars(0,clk, din, reset, start, done_tick, dout);
    end

endmodule
