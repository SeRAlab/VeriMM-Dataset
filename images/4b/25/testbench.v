`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [27:0] led_total;
    reg rst_n;
    wire [6:0] num;
    wire [3:0] sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .led_total(led_total),
        .rst_n(rst_n),
        .num(num),
        .sel(sel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        led_total = 0;
        @(posedge clk);
        #2 rst_n = 1;
        @(posedge clk);
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: Digit 0 Selection (Value 0)", test_num);
        reset_dut();
        led_total = {7'd3, 7'd2, 7'd1, 7'd0};
        #1;

        #1;


        check_outputs(7'h3f, 4'b0001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Digit 1 Selection (Value 1)", test_num);
        reset_dut();
        led_total = {7'd3, 7'd2, 7'd1, 7'd0};
        @(posedge clk);
        #2;

        #1;


        check_outputs(7'h06, 4'b0010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Digit 2 Selection (Value 2)", test_num);
        reset_dut();
        led_total = {7'd3, 7'd2, 7'd1, 7'd0};
        repeat(2) @(posedge clk);
        #2;

        #1;


        check_outputs(7'h5b, 4'b0100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Digit 3 Selection (Value 3)", test_num);
        reset_dut();
        led_total = {7'd3, 7'd2, 7'd1, 7'd0};
        repeat(3) @(posedge clk);
        #2;

        #1;


        check_outputs(7'h4f, 4'b1000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Wrap Around to Digit 0", test_num);
        reset_dut();
        led_total = {7'd3, 7'd2, 7'd1, 7'd0};
        repeat(4) @(posedge clk);
        #2;

        #1;


        check_outputs(7'h3f, 4'b0001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: High Value Decoding (Value 9 on Digit 0)", test_num);
        reset_dut();
        led_total = {7'd6, 7'd7, 7'd8, 7'd9};
        #2;

        #1;


        check_outputs(7'h6f, 4'b0001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest Case %0d: Decoding Value 5 on Digit 2", test_num);
        reset_dut();
        led_total = {7'd0, 7'd5, 7'd0, 7'd0};
        repeat(2) @(posedge clk);
        #2;

        #1;


        check_outputs(7'h6d, 4'b0100);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTest Case %0d: Decoding Value 8", test_num);
        reset_dut();
        led_total = {28'h0};
        led_total[13:7] = 7'd8;
        @(posedge clk);
        #2;

        #1;


        check_outputs(7'h7f, 4'b0010);
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
        input [6:0] expected_num;
        input [3:0] expected_sel;
        begin
            if (expected_num === (expected_num ^ num ^ expected_num) &&
                expected_sel === (expected_sel ^ sel ^ expected_sel)) begin
                $display("PASS");
                $display("  Outputs: num=%h, sel=%h",
                         num, sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: num=%h, sel=%h",
                         expected_num, expected_sel);
                $display("  Got:      num=%h, sel=%h",
                         num, sel);
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
        $dumpvars(0,clk, led_total, rst_n, num, sel);
    end

endmodule
