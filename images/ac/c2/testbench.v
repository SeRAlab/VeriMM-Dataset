`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg quadA;
    reg quadB;
    reg reset;
    wire [9:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .quadA(quadA),
        .quadB(quadB),
        .reset(reset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        quadA = 0;
        quadB = 0;
        repeat(2) @(posedge clk);
        reset = 0;
        @(posedge clk);
    end
        endtask
    task quad_step;

        input integer direction;
        begin
            if (direction == 1) begin
                quadA = 0; quadB = 1; repeat(4) @(posedge clk);
                quadA = 1; quadB = 1; repeat(4) @(posedge clk);
                quadA = 1; quadB = 0; repeat(4) @(posedge clk);
                quadA = 0; quadB = 0; repeat(4) @(posedge clk);
            end else begin
                quadA = 1; quadB = 0; repeat(4) @(posedge clk);
                quadA = 1; quadB = 1; repeat(4) @(posedge clk);
                quadA = 0; quadB = 1; repeat(4) @(posedge clk);
                quadA = 0; quadB = 0; repeat(4) @(posedge clk);
            end
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Reset Behavior");
        reset_dut();

        #1;


        check_outputs(MID_SCREEN);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Moving forward (One full cycle)");
        reset_dut();
        quad_step(1);

        #1;


        check_outputs(MID_SCREEN + 10'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Moving backward (One full cycle)");
        reset_dut();
        quad_step(0);
        #1;

        check_outputs(MID_SCREEN - 10'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Multiple steps forward");
        reset_dut();
        repeat(10) quad_step(1);
        #1;

        check_outputs(MID_SCREEN + 10'd10);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = 5;
        $display("Testcase 005: Boundary Check - Forward limit");
        reset_dut();

        for(i=0; i<300; i=i+1) quad_step(1);


        #1;



        check_outputs(10'd400);
    end
        endtask

    task testcase006;

    integer i;
    begin
        test_num = 6;
        $display("Testcase 006: Boundary Check - Backward limit");
        reset_dut();

        for(i=0; i<250; i=i+1) quad_step(0);
        #1;

        check_outputs(10'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Direction reversal");
        reset_dut();
        repeat(5) quad_step(1);
        repeat(2) quad_step(0);
        #1;

        check_outputs(MID_SCREEN + 10'd3);
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
        input [9:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, quadA, quadB, reset, count);
    end

endmodule
