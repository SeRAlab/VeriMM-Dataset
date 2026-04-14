`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg advance;
    reg [9:0] ball_y;
    reg reset;
    wire [9:0] paddle_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .advance(advance),
        .ball_y(ball_y),
        .reset(reset),
        .paddle_y(paddle_y)
    );

    // Clock generation (10ns period)
    initial begin
        advance = 0;
        forever #5 advance = ~advance;
    end

        task reset_dut;

    begin
        reset = 1;
        ball_y = 240;
        @(posedge advance);
        #1 reset = 0;
        @(posedge advance);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Resetting to center", test_num);
        reset_dut();
        #1;

        check_outputs(10'd240);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Move downward towards ball", test_num);
        reset_dut();
        ball_y = 10'd400;
        repeat(10) @(posedge advance);
        #1 #1;
 check_outputs(10'd280);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Move upward towards ball", test_num);
        reset_dut();
        ball_y = 10'd100;
        repeat(10) @(posedge advance);
        #1 #1;
 check_outputs(10'd200);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Hit bottom screen boundary", test_num);
        reset_dut();
        ball_y = 10'd500;
        repeat(100) @(posedge advance);
        #1 #1;
 check_outputs(10'd459);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Hit top screen boundary", test_num);
        reset_dut();
        ball_y = 10'd0;
        repeat(100) @(posedge advance);
        #1 #1;
 check_outputs(10'd20);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Ball aligned with paddle center", test_num);
        reset_dut();
        ball_y = 10'd240;
        repeat(5) @(posedge advance);
        #1 #1;
 check_outputs(10'd240);
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
        input [9:0] expected_paddle_y;
        begin
            if (expected_paddle_y === (expected_paddle_y ^ paddle_y ^ expected_paddle_y)) begin
                $display("PASS");
                $display("  Outputs: paddle_y=%h",
                         paddle_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: paddle_y=%h",
                         expected_paddle_y);
                $display("  Got:      paddle_y=%h",
                         paddle_y);
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
        $dumpvars(0,advance, ball_y, reset, paddle_y);
    end

endmodule
