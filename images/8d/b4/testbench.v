`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg [31:0] divider;
    reg enable;
    reg go;
    reg last_clk;
    reg rst;
    wire clk_out;
    wire neg_edge;
    wire pos_edge;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .divider(divider),
        .enable(enable),
        .go(go),
        .last_clk(last_clk),
        .rst(rst),
        .clk_out(clk_out),
        .neg_edge(neg_edge),
        .pos_edge(pos_edge)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            go = 0;
            last_clk = 0;
            divider = 32'd0;
            @(posedge clk_in);
            #1 rst = 0;
            @(posedge clk_in);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Reset State");
            reset_dut();
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Divider 4 - Positive Edge Detection");
            reset_dut();
            divider = 32'd4;
            enable = 1;
            go = 1;

            repeat(2) @(posedge clk_in);
            #1;
            #1;

            check_outputs(1, 0, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Divider 4 - Negative Edge Detection");
            reset_dut();
            divider = 32'd4;
            enable = 1;
            go = 1;

            repeat(4) @(posedge clk_in);
            #1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Enable Low Inhibition");
            reset_dut();
            divider = 32'd4;
            enable = 0;
            go = 1;
            repeat(10) @(posedge clk_in);
            #1;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Divider 2 (Max Frequency)");
            reset_dut();
            divider = 32'd2;
            enable = 1;
            go = 1;
            repeat(1) @(posedge clk_in);
            #1;
            #1;

            check_outputs(1, 0, 1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Large Divider (Divider 20)");
            reset_dut();
            divider = 32'd20;
            enable = 1;
            go = 1;
            repeat(10) @(posedge clk_in);
            #1;
            #1;

            check_outputs(1, 0, 1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Clock stays idle if 'go' is low");
            reset_dut();
            divider = 32'd4;
            enable = 1;
            go = 0;
            repeat(5) @(posedge clk_in);
            #1;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Check 'last_clk' termination");
            reset_dut();
            divider = 32'd4;
            enable = 1;
            go = 1;
            repeat(4) @(posedge clk_in);
            #1;
            last_clk = 1;
            repeat(4) @(posedge clk_in);
            #1;

            #1;


            check_outputs(0, 0, 0);
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
        input expected_clk_out;
        input expected_neg_edge;
        input expected_pos_edge;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out) &&
                expected_neg_edge === (expected_neg_edge ^ neg_edge ^ expected_neg_edge) &&
                expected_pos_edge === (expected_pos_edge ^ pos_edge ^ expected_pos_edge)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b, neg_edge=%b, pos_edge=%b",
                         clk_out, neg_edge, pos_edge);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b, neg_edge=%b, pos_edge=%b",
                         expected_clk_out, expected_neg_edge, expected_pos_edge);
                $display("  Got:      clk_out=%b, neg_edge=%b, pos_edge=%b",
                         clk_out, neg_edge, pos_edge);
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
        $dumpvars(0,clk_in, divider, enable, go, last_clk, rst, clk_out, neg_edge, pos_edge);
    end

endmodule
