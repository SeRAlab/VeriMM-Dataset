`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] clear;
    reg clk;
    reg m1;
    reg m2;
    reg [15:0] pos11;
    reg [15:0] pos12;
    reg [15:0] pos21;
    reg [15:0] pos22;
    wire [31:0] count_clk;
    wire [15:0] pos_diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .m1(m1),
        .m2(m2),
        .pos11(pos11),
        .pos12(pos12),
        .pos21(pos21),
        .pos22(pos22),
        .count_clk(count_clk),
        .pos_diff(pos_diff)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        clear = 2'b11;
        m1 = 1'b0;
        m2 = 1'b0;
        pos11 = 16'd0; pos12 = 16'd0;
        pos21 = 16'd0; pos22 = 16'd0;
        @(posedge clk);
        #1;
        clear = 2'b00;
        $display("DUT Reset Complete");
    end
        endtask
    task testcase001;

    begin
        $display("\nRunning testcase001: Basic Clock Count");
        test_num = 1;
        reset_dut();

        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(32'd10, 16'd0);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning testcase002: Position Tracking (Sequential)");
        test_num = 2;
        reset_dut();

        pos11 = 16'd100; pos12 = 16'd200; m1 = 1'b1;
        @(posedge clk);

        m1 = 1'b0;
        pos21 = 16'd50; pos22 = 16'd120; m2 = 1'b1;
        @(posedge clk);

        m2 = 1'b0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'd3, 16'd130);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning testcase003: Simultaneous Position Update");
        test_num = 3;
        reset_dut();
        pos11 = 16'd100; pos12 = 16'd100;
        pos21 = 16'd40;  pos22 = 16'd40;
        m1 = 1'b1; m2 = 1'b1;
        @(posedge clk);
        m1 = 1'b0; m2 = 1'b0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'd2, 16'd120);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning testcase004: Clear Clock Count");
        test_num = 4;
        reset_dut();
        repeat(5) @(posedge clk);
        clear = 2'b01;
        @(posedge clk);
        #1;
        clear = 2'b00;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(32'd3, 16'd0);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning testcase005: Clear Position Registers");
        test_num = 5;
        reset_dut();

        pos11 = 100; pos12 = 100; pos21 = 50; pos22 = 50;
        m1 = 1; m2 = 1;
        @(posedge clk);
        m1 = 0; m2 = 0;
        @(posedge clk);

        clear = 2'b10;
        @(posedge clk);
        @(posedge clk);
        clear = 2'b00;
        #1;
        #1;

        check_outputs(32'd5, 16'd0);
    end
        endtask

    task testcase006;

    begin
        $display("\nRunning testcase006: Wrap-around Difference");
        test_num = 6;
        reset_dut();
        pos11 = 16'd10; pos12 = 16'd10;
        pos21 = 16'd20; pos22 = 16'd20;
        m1 = 1'b1; m2 = 1'b1;
        @(posedge clk);
        m1 = 1'b0; m2 = 1'b0;
        repeat(2) @(posedge clk);
        #1;

        #1;


        check_outputs(32'd4, 16'hFFEC);
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
        input [31:0] expected_count_clk;
        input [15:0] expected_pos_diff;
        begin
            if (expected_count_clk === (expected_count_clk ^ count_clk ^ expected_count_clk) &&
                expected_pos_diff === (expected_pos_diff ^ pos_diff ^ expected_pos_diff)) begin
                $display("PASS");
                $display("  Outputs: count_clk=%h, pos_diff=%h",
                         count_clk, pos_diff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_clk=%h, pos_diff=%h",
                         expected_count_clk, expected_pos_diff);
                $display("  Got:      count_clk=%h, pos_diff=%h",
                         count_clk, pos_diff);
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
        $dumpvars(0,clear, clk, m1, m2, pos11, pos12, pos21, pos22, count_clk, pos_diff);
    end

endmodule
