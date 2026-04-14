`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [169:0] din;
    reg rst;
    reg start;
    wire clk_sr;
    wire [169:0] din_sr;
    wire load_sr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .rst(rst),
        .start(start),
        .clk_sr(clk_sr),
        .din_sr(din_sr),
        .load_sr(load_sr)
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
            din = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case 001: Reset State Check");

            #1;


            check_outputs(0, 170'h0, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case 002: Load Signal Assertion");
            @(negedge clk);
            start = 1;
            din = 170'hA5A5;
            #1;

            #1;


            check_outputs(0, 170'h0, 1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case 003: Data Load Operation");
            @(negedge clk);
            din = 170'hFEDCBA9876543210;
            start = 1;
            @(negedge clk);
            @(negedge clk);

            #1;


            check_outputs(0, 170'hFEDCBA9876543210, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case 004: Single Shift Operation");
            @(negedge clk);
            din = 170'h1;
            start = 1;
            @(negedge clk);
            @(negedge clk);
            @(negedge clk);

            #1;


            check_outputs(0, 170'h2, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case 005: Multiple Shift Operation (4 shifts)");
            @(negedge clk);
            din = 170'hF;
            start = 1;
            @(negedge clk);
            @(negedge clk);
            @(negedge clk);
            @(negedge clk);
            @(negedge clk);
            @(negedge clk);
            #1;

            check_outputs(0, 170'hF0, 0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case 006: Stop Shifting when Start is de-asserted");
            @(negedge clk);
            din = 170'hFF;
            start = 1;
            @(negedge clk);
            @(negedge clk);
            @(negedge clk);
            start = 0;
            @(negedge clk);
            #1;

            check_outputs(0, 170'h1FE, 0);
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
        input expected_clk_sr;
        input [169:0] expected_din_sr;
        input expected_load_sr;
        begin
            if (expected_clk_sr === (expected_clk_sr ^ clk_sr ^ expected_clk_sr) &&
                expected_din_sr === (expected_din_sr ^ din_sr ^ expected_din_sr) &&
                expected_load_sr === (expected_load_sr ^ load_sr ^ expected_load_sr)) begin
                $display("PASS");
                $display("  Outputs: clk_sr=%b, din_sr=%h, load_sr=%b",
                         clk_sr, din_sr, load_sr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_sr=%b, din_sr=%h, load_sr=%b",
                         expected_clk_sr, expected_din_sr, expected_load_sr);
                $display("  Got:      clk_sr=%b, din_sr=%h, load_sr=%b",
                         clk_sr, din_sr, load_sr);
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
        $dumpvars(0,clk, din, rst, start, clk_sr, din_sr, load_sr);
    end

endmodule
