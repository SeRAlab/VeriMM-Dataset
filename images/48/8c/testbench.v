`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [39:0] a;
    reg [39:0] b;
    reg bp_a;
    reg [39:0] bp_ar;
    reg bp_b;
    reg [39:0] bp_br;
    reg clk;
    reg ena;
    reg sel_acc;
    wire [5:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .bp_a(bp_a),
        .bp_ar(bp_ar),
        .bp_b(bp_b),
        .bp_br(bp_br),
        .clk(clk),
        .ena(ena),
        .sel_acc(sel_acc),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0; b = 0;
            bp_a = 0; bp_ar = 0;
            bp_b = 0; bp_br = 0;
            ena = 1;
            sel_acc = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(6'h1e);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            a = 40'd10;
            b = 40'd20;
            sel_acc = 0;
            ena = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(6'h1f);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            a = 40'd5; b = 40'd5; sel_acc = 0; ena = 1;
            @(posedge clk);

            a = 40'd5; b = 40'd5; sel_acc = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(6'h1f);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            a = 40'd100;
            bp_ar = 40'd5;
            bp_a = 1;
            b = 40'd5;
            sel_acc = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(6'h1f);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            a = 40'd10;
            b = 40'd500;
            bp_br = 40'd10;
            bp_b = 1;
            sel_acc = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(6'h1f);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            a = 25; b = 25; sel_acc = 0; ena = 1;
            @(posedge clk);

            a = 0; b = 0; ena = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(6'h1f);
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
        input [5:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,a, b, bp_a, bp_ar, bp_b, bp_br, clk, ena, sel_acc, result);
    end

endmodule
