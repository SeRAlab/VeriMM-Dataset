`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg reset;
    reg rst;
    reg start;
    reg stop;
    reg [31:0] value;
    wire interrupt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .reset(reset),
        .rst(rst),
        .start(start),
        .stop(stop),
        .value(value),
        .interrupt(interrupt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        reset = 0;
        load = 0;
        start = 0;
        stop = 0;
        value = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
        #1 reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Basic Countdown from 5", test_num);
        reset_dut();

        value = 32'd5;
        load = 1;
        @(posedge clk);
        #1 load = 0;

        start = 1;
        @(posedge clk);
        #1 start = 0;


        repeat(7) @(posedge clk);

        #1 #1;
 check_outputs(1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Stop and Resume Operation", test_num);
        reset_dut();

        value = 32'd10;
        load = 1;
        @(posedge clk);
        #1 load = 0;

        start = 1;
        @(posedge clk);
        #1 start = 0;

        repeat(4) @(posedge clk);

        stop = 1;
        @(posedge clk);
        #1 stop = 0;


        repeat(5) @(posedge clk);

        start = 1;
        @(posedge clk);
        #1 start = 0;


        repeat(8) @(posedge clk);

        #1 #1;
 check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Timer Reset mid-run", test_num);
        reset_dut();

        value = 32'd10;
        load = 1;
        @(posedge clk);
        #1 load = 0;

        start = 1;
        @(posedge clk);
        #1 start = 0;

        repeat(5) @(posedge clk);

        reset = 1;
        @(posedge clk);
        #1 reset = 0;


        repeat(10) @(posedge clk);

        #1 #1;
 check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Timer Reset from STOPPED state", test_num);
        reset_dut();

        value = 32'd5;
        load = 1;
        @(posedge clk);
        #1 load = 0;

        start = 1;
        @(posedge clk);
        #1 start = 0;

        repeat(2) @(posedge clk);

        stop = 1;
        @(posedge clk);
        #1 stop = 0;

        reset = 1;
        @(posedge clk);
        #1 reset = 0;

        repeat(10) @(posedge clk);

        #1 #1;
 check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Load without Start", test_num);
        reset_dut();

        value = 32'd5;
        load = 1;
        @(posedge clk);
        #1 load = 0;

        repeat(20) @(posedge clk);

        #1 #1;
 check_outputs(0);
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
        input expected_interrupt;
        begin
            if (expected_interrupt === (expected_interrupt ^ interrupt ^ expected_interrupt)) begin
                $display("PASS");
                $display("  Outputs: interrupt=%b",
                         interrupt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: interrupt=%b",
                         expected_interrupt);
                $display("  Got:      interrupt=%b",
                         interrupt);
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
        $dumpvars(0,clk, load, reset, rst, start, stop, value, interrupt);
    end

endmodule
