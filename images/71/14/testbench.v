`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] ball_x;
    reg [9:0] ball_y;
    reg clk;
    reg [9:0] screenx;
    reg [9:0] screeny;
    wire ball_scan;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ball_x(ball_x),
        .ball_y(ball_y),
        .clk(clk),
        .screenx(screenx),
        .screeny(screeny),
        .ball_scan(ball_scan)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        ball_x = 10'd0;
        ball_y = 10'd0;
        screenx = 10'd0;
        screeny = 10'd0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Perfect Match at (100, 150)", test_num);
        reset_dut();
        ball_x = 10'd100;
        ball_y = 10'd150;
        screenx = 10'd100;
        screeny = 10'd150;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mismatch on X", test_num);
        reset_dut();
        ball_x = 10'd100;
        ball_y = 10'd150;
        screenx = 10'd101;
        screeny = 10'd150;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mismatch on Y", test_num);
        reset_dut();
        ball_x = 10'd100;
        ball_y = 10'd150;
        screenx = 10'd100;
        screeny = 10'd149;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mismatch on both X and Y", test_num);
        reset_dut();
        ball_x = 10'd200;
        ball_y = 10'd200;
        screenx = 10'd300;
        screeny = 10'd300;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Match at Origin (0,0)", test_num);
        reset_dut();
        ball_x = 10'd0;
        ball_y = 10'd0;
        screenx = 10'd0;
        screeny = 10'd0;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Match at Max Coordinates (1023, 1023)", test_num);
        reset_dut();
        ball_x = 10'd1023;
        ball_y = 10'd1023;
        screenx = 10'd1023;
        screeny = 10'd1023;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
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
        input expected_ball_scan;
        begin
            if (expected_ball_scan === (expected_ball_scan ^ ball_scan ^ expected_ball_scan)) begin
                $display("PASS");
                $display("  Outputs: ball_scan=%b",
                         ball_scan);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ball_scan=%b",
                         expected_ball_scan);
                $display("  Got:      ball_scan=%b",
                         ball_scan);
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
        $dumpvars(0,ball_x, ball_y, clk, screenx, screeny, ball_scan);
    end

endmodule
