`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg plus;
    wire [3:0] high_score0;
    wire [3:0] high_score1;
    wire [3:0] high_score2;
    wire [3:0] high_score3;
    wire [3:0] score0;
    wire [3:0] score1;
    wire [3:0] score2;
    wire [3:0] score3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .plus(plus),
        .high_score0(high_score0),
        .high_score1(high_score1),
        .high_score2(high_score2),
        .high_score3(high_score3),
        .score0(score0),
        .score1(score1),
        .score2(score2),
        .score3(score3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        clr = 1;
        plus = 0;
        repeat(10) @(posedge clk);
        clr = 0;
        repeat(5) @(posedge clk);
    end
        endtask
    task send_pulses;

        input integer n;
        integer i;
        begin
            for (i = 0; i < n; i = i + 1) begin
                plus = 1;
                repeat(5) @(posedge clk);
                plus = 0;
                repeat(5) @(posedge clk);
            end
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Initial Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Single Increment (Score 10)", test_num);
        reset_dut();
        send_pulses(1);

        #1;


        check_outputs(4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Multiple Increments (Score 120)", test_num);
        reset_dut();
        send_pulses(12);

        #1;


        check_outputs(4'd0, 4'd2, 4'd1, 4'd0, 4'd0, 4'd2, 4'd1, 4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Increment to 100", test_num);
        reset_dut();
        send_pulses(10);

        #1;


        check_outputs(4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: High Score Persistence", test_num);
        reset_dut();
        send_pulses(15);


        clr = 1;
        repeat(10) @(posedge clk);
        clr = 0;
        repeat(5) @(posedge clk);

        send_pulses(5);


        #1;



        check_outputs(4'd0, 4'd5, 4'd1, 4'd0, 4'd0, 4'd5, 4'd0, 4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Large Score (1000)", test_num);
        reset_dut();
        send_pulses(100);

        #1;


        check_outputs(4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: High Score Update Verification", test_num);
        reset_dut();
        send_pulses(5);
        send_pulses(10);

        #1;


        check_outputs(4'd0, 4'd5, 4'd1, 4'd0, 4'd0, 4'd5, 4'd1, 4'd0);
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
        input [3:0] expected_high_score0;
        input [3:0] expected_high_score1;
        input [3:0] expected_high_score2;
        input [3:0] expected_high_score3;
        input [3:0] expected_score0;
        input [3:0] expected_score1;
        input [3:0] expected_score2;
        input [3:0] expected_score3;
        begin
            if (expected_high_score0 === (expected_high_score0 ^ high_score0 ^ expected_high_score0) &&
                expected_high_score1 === (expected_high_score1 ^ high_score1 ^ expected_high_score1) &&
                expected_high_score2 === (expected_high_score2 ^ high_score2 ^ expected_high_score2) &&
                expected_high_score3 === (expected_high_score3 ^ high_score3 ^ expected_high_score3) &&
                expected_score0 === (expected_score0 ^ score0 ^ expected_score0) &&
                expected_score1 === (expected_score1 ^ score1 ^ expected_score1) &&
                expected_score2 === (expected_score2 ^ score2 ^ expected_score2) &&
                expected_score3 === (expected_score3 ^ score3 ^ expected_score3)) begin
                $display("PASS");
                $display("  Outputs: high_score0=%h, high_score1=%h, high_score2=%h, high_score3=%h, score0=%h, score1=%h, score2=%h, score3=%h",
                         high_score0, high_score1, high_score2, high_score3, score0, score1, score2, score3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: high_score0=%h, high_score1=%h, high_score2=%h, high_score3=%h, score0=%h, score1=%h, score2=%h, score3=%h",
                         expected_high_score0, expected_high_score1, expected_high_score2, expected_high_score3, expected_score0, expected_score1, expected_score2, expected_score3);
                $display("  Got:      high_score0=%h, high_score1=%h, high_score2=%h, high_score3=%h, score0=%h, score1=%h, score2=%h, score3=%h",
                         high_score0, high_score1, high_score2, high_score3, score0, score1, score2, score3);
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
        $dumpvars(0,clk, clr, plus, high_score0, high_score1, high_score2, high_score3, score0, score1, score2, score3);
    end

endmodule
