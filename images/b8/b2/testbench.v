`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg chg;
    reg clk;
    reg rst;
    wire [3:0] theme;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .chg(chg),
        .clk(clk),
        .rst(rst),
        .theme(theme)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            chg = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset", test_num);
            reset_dut();
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Increment (0 to 1)", test_num);
            reset_dut();
            chg = 1;
            @(posedge clk);
            #1 chg = 0;
            @(posedge clk);
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Two Increments (0 to 2)", test_num);
            reset_dut();
            chg = 1;
            @(posedge clk);
            @(posedge clk);
            #1 chg = 0;
            @(posedge clk);
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Wrap Around (0-1-2-0)", test_num);
            reset_dut();
            chg = 1;
            repeat(3) @(posedge clk);
            #1 chg = 0;
            @(posedge clk);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Stability without chg signal", test_num);
            reset_dut();
            chg = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Multiple Wrap Arounds (5 increments: 0-1-2-0-1-2)", test_num);
            reset_dut();
            chg = 1;
            repeat(5) @(posedge clk);
            #1 chg = 0;
            @(posedge clk);
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Reset mid-sequence", test_num);
            reset_dut();
            chg = 1;
            repeat(2) @(posedge clk);
            #1 rst = 1;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;

            check_outputs(4'd0);
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
        input [3:0] expected_theme;
        begin
            if (expected_theme === (expected_theme ^ theme ^ expected_theme)) begin
                $display("PASS");
                $display("  Outputs: theme=%h",
                         theme);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: theme=%h",
                         expected_theme);
                $display("  Got:      theme=%h",
                         theme);
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
        $dumpvars(0,chg, clk, rst, theme);
    end

endmodule
