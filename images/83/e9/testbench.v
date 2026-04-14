`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg reset_n;
    wire [6:0] segments;
    wire [2:0] sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .reset_n(reset_n),
        .segments(segments),
        .sel(sel)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            reset_n = 0;
            @(posedge clk_i);
            #2 reset_n = 1;
            @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Checking initial state after reset (Digit 1, Val 0)", test_num);
            reset_dut();
            #1;

            check_outputs(SEG_0, 3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Checking state after 1 clock cycle (Digit 2, Val 1)", test_num);
            reset_dut();
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(SEG_1, 3'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Checking state after 2 clock cycles (Digit 3, Val 2)", test_num);
            reset_dut();
            repeat(2) @(posedge clk_i);
            #1;
            #1;

            check_outputs(SEG_2, 3'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Checking state after 3 clock cycles (Digit 4, Val 3)", test_num);
            reset_dut();
            repeat(3) @(posedge clk_i);
            #1;
            #1;

            check_outputs(SEG_3, 3'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Checking wraparound after 4 clock cycles (Digit 1, Val 0)", test_num);
            reset_dut();
            repeat(4) @(posedge clk_i);
            #1;
            #1;

            check_outputs(SEG_0, 3'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Checking state after 7 clock cycles (Digit 4, Val 3)", test_num);
            reset_dut();
            repeat(7) @(posedge clk_i);
            #1;
            #1;

            check_outputs(SEG_3, 3'd3);
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
        input [6:0] expected_segments;
        input [2:0] expected_sel;
        begin
            if (expected_segments === (expected_segments ^ segments ^ expected_segments) &&
                expected_sel === (expected_sel ^ sel ^ expected_sel)) begin
                $display("PASS");
                $display("  Outputs: segments=%h, sel=%h",
                         segments, sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: segments=%h, sel=%h",
                         expected_segments, expected_sel);
                $display("  Got:      segments=%h, sel=%h",
                         segments, sel);
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
        $dumpvars(0,clk_i, reset_n, segments, sel);
    end

endmodule
