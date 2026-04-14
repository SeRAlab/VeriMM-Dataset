`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] n_lines;
    reg rst;
    reg start;
    wire [7:0] level;
    wire [15:0] score;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .n_lines(n_lines),
        .rst(rst),
        .start(start),
        .level(level),
        .score(score)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            n_lines = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(8'd0, 16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Line Clear", test_num);
            reset_dut();
            n_lines = 3'd1;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'd0, 16'd40);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Double Line Clear", test_num);
            reset_dut();
            n_lines = 3'd2;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'd0, 16'd100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Triple Line Clear", test_num);
            reset_dut();
            n_lines = 3'd3;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'd0, 16'd300);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Four Line Clear (Tetris)", test_num);
            reset_dut();
            n_lines = 3'd4;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'd0, 16'd1200);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Score Accumulation", test_num);
            reset_dut();

            n_lines = 3'd1; start = 1; @(posedge clk); start = 0; @(posedge clk);

            n_lines = 3'd2; start = 1; @(posedge clk); start = 0; @(posedge clk);

            n_lines = 3'd4; start = 1; @(posedge clk); start = 0; @(posedge clk);
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'd0, 16'd1340);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Level Up (10 lines total)", test_num);
            reset_dut();

            repeat(2) begin
                n_lines = 3'd4; start = 1; @(posedge clk); start = 0; @(posedge clk);
            end

            n_lines = 3'd2; start = 1; @(posedge clk); start = 0; @(posedge clk);

            repeat(2) @(posedge clk);


            #1;



            check_outputs(8'd1, 16'd2500);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Scoring at Level 1", test_num);
            reset_dut();

            repeat(10) begin
                n_lines = 3'd1; start = 1; @(posedge clk); start = 0; @(posedge clk);
            end


            n_lines = 3'd4; start = 1; @(posedge clk); start = 0; @(posedge clk);

            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'd1, 16'd2800);
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
        testcase008();
        
        
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
        input [7:0] expected_level;
        input [15:0] expected_score;
        begin
            if (expected_level === (expected_level ^ level ^ expected_level) &&
                expected_score === (expected_score ^ score ^ expected_score)) begin
                $display("PASS");
                $display("  Outputs: level=%h, score=%h",
                         level, score);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: level=%h, score=%h",
                         expected_level, expected_score);
                $display("  Got:      level=%h, score=%h",
                         level, score);
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
        $dumpvars(0,clk, n_lines, rst, start, level, score);
    end

endmodule
