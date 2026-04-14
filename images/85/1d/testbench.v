`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg gameStart;
    reg rst;
    wire [3:0] Q;
    wire tc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .gameStart(gameStart),
        .rst(rst),
        .Q(Q),
        .tc(tc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            gameStart = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Full cycle 0 to 9...");
            reset_dut();
            en = 1;
            gameStart = 1;

            repeat (9) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd9, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Wrap around (9 to 0)...");
            reset_dut();
            en = 1;
            gameStart = 1;
            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: en low gating...");
            reset_dut();
            en = 0;
            gameStart = 1;
            repeat (5) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: gameStart low gating...");
            reset_dut();
            en = 1;
            gameStart = 0;
            repeat (5) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Synchronous reset during operation...");
            reset_dut();
            en = 1;
            gameStart = 1;
            repeat (4) @(posedge clk);
            #1;
            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Toggling enable...");
            reset_dut();
            gameStart = 1;

            en = 1; @(posedge clk);
            en = 0; @(posedge clk);
            en = 1; @(posedge clk);
            en = 0; @(posedge clk);
            en = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, 1'b0);
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
        input [3:0] expected_Q;
        input expected_tc;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_tc === (expected_tc ^ tc ^ expected_tc)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, tc=%b",
                         Q, tc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, tc=%b",
                         expected_Q, expected_tc);
                $display("  Got:      Q=%h, tc=%b",
                         Q, tc);
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
        $dumpvars(0,clk, en, gameStart, rst, Q, tc);
    end

endmodule
