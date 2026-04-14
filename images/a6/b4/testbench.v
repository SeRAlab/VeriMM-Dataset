`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg reset;
    reg [15:0] x;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .reset(reset),
        .x(x),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 1;
        x = 0;
        @(posedge clock);
        #1;
        reset = 0;
        @(posedge clock);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All Zeros", test_num);
        reset_dut();
        x = 16'sh0000;
        repeat(5) @(posedge clock);
        #1 #1;
 check_outputs(16'sh0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Constant Positive", test_num);
        reset_dut();
        x = 16'sd1024;
        repeat(4) @(posedge clock);
        #1 #1;
 check_outputs(16'sd1024);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Constant Negative", test_num);
        reset_dut();
        x = -16'sd2048;
        repeat(4) @(posedge clock);
        #1 #1;
 check_outputs(-16'sd2048);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Impulse and Clear", test_num);
        reset_dut();
        x = 16'sd4000;
        @(posedge clock);
        x = 16'sd0;
        repeat(4) @(posedge clock);
        #1 #1;
 check_outputs(16'sd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Max Positive", test_num);
        reset_dut();
        x = 16'sh7FFF;
        repeat(4) @(posedge clock);
        #1 #1;
 check_outputs(16'sh7FFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Max Negative", test_num);
        reset_dut();
        x = 16'sh8000;
        repeat(4) @(posedge clock);
        #1 #1;
 check_outputs(16'sh8000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Mixed Sum", test_num);
        reset_dut();
        x = 16'sd100; @(posedge clock);
        x = 16'sd200; @(posedge clock);
        x = 16'sd300; @(posedge clock);
        x = 16'sd400; @(posedge clock);
        #1 #1;
 check_outputs(16'sd250);
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
        input [15:0] expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
        $dumpvars(0,clock, reset, x, y);
    end

endmodule
