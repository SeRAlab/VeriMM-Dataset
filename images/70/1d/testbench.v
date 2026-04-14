`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [99:0] data0;
    reg [99:0] data1;
    reg [99:0] data2;
    reg [99:0] data3;
    reg [99:0] data4;
    reg [99:0] data5;
    reg [1:0] ena;
    reg load;
    reg [2:0] sel;
    wire [99:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .data5(data5),
        .ena(ena),
        .load(load),
        .sel(sel),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 0;
            ena = 0;
            sel = 0;
            data0 = 100'h0;
            data1 = 100'h0;
            data2 = 100'h0;
            data3 = 100'h0;
            data4 = 100'h0;
            data5 = 100'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            data0 = 100'hAAAAAAAAAAAAAAAAAAAAAAAAA;
            sel = 3'd0;
            load = 1;
            @(posedge clk);
            #1;
            $display("Test Case 001: Load data0");
            #1;

            check_outputs(100'h0);
        end
        endtask

    task testcase002;

        reg [99:0] d1;
        begin
            test_num = test_num + 1;
            reset_dut();
            d1 = 100'hF0F0F0F0F0F0F0F0F0F0F0F0F;
            data1 = d1;
            sel = 3'd1;
            load = 1;
            @(posedge clk);
            load = 0;
            ena = 2'b01;
            @(posedge clk);
            #1;
            $display("Test Case 002: Shift Right");
            #1;

            check_outputs((d1 >> 1) ^ d1);
        end
        endtask

    task testcase003;

        reg [99:0] d2;
        begin
            test_num = test_num + 1;
            reset_dut();
            d2 = 100'h00000000000000000000000FF;
            data2 = d2;
            sel = 3'd2;
            load = 1;
            @(posedge clk);
            load = 0;
            ena = 2'b10;
            @(posedge clk);
            #1;
            $display("Test Case 003: Shift Left");
            #1;

            check_outputs((d2 << 1) ^ d2);
        end
        endtask

    task testcase004;

        reg [99:0] d3, d4;
        begin
            test_num = test_num + 1;
            reset_dut();
            d3 = 100'h123456789ABCDEF0123456789;
            d4 = 100'hFFFFFFFFFFFFFFFFFFFFFFFFF;
            data3 = d3;
            data4 = d4;
            sel = 3'd3;
            load = 1;
            @(posedge clk);
            load = 0;
            sel = 3'd4;
            @(posedge clk);
            #1;
            $display("Test Case 004: Select Input Change");
            #1;

            check_outputs(d3 ^ d4);
        end
        endtask

    task testcase005;

        reg [99:0] d5;
        begin
            test_num = test_num + 1;
            reset_dut();
            d5 = 100'h5555555555555555555555555;
            data5 = d5;
            sel = 3'd5;
            load = 1;
            @(posedge clk);
            load = 0;
            ena = 2'b01;
            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Test Case 005: Double Shift Right");
            #1;

            check_outputs((d5 >> 2) ^ d5);
        end
        endtask

    task testcase006;

        reg [99:0] d0, d1;
        begin
            test_num = test_num + 1;
            reset_dut();
            d0 = 100'hAAAAAAAAAAAAAAAAAAAAAAAAA;
            d1 = 100'hBBBBBBBBBBBBBBBBBBBBBBBBB;
            data0 = d0;
            data1 = d1;
            sel = 3'd0;
            load = 1;
            @(posedge clk);

            load = 1;
            sel = 3'd1;
            ena = 2'b01;
            @(posedge clk);
            #1;
            $display("Test Case 006: Priority Load vs Ena");
            #1;

            check_outputs(d1 ^ d1);
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
        input [99:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data0, data1, data2, data3, data4, data5, ena, load, sel, q);
    end

endmodule
