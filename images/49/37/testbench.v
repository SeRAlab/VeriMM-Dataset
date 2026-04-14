`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] hundreds;
    reg reset_n;
    reg [3:0] tens;
    reg [3:0] thousands;
    reg [3:0] units;
    wire [3:0] data;
    wire decimal_point;
    wire [2:0] digit_select;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .hundreds(hundreds),
        .reset_n(reset_n),
        .tens(tens),
        .thousands(thousands),
        .units(units),
        .data(data),
        .decimal_point(decimal_point),
        .digit_select(digit_select)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 1'b0;
            units = 4'h0;
            tens = 4'h0;
            hundreds = 4'h0;
            thousands = 4'h0;
            @(posedge clk);
            #2;
            reset_n = 1'b1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Checking Units Digit (S0) after reset", test_num);
            reset_dut();
            units = 4'h1; tens = 4'h2; hundreds = 4'h3; thousands = 4'h4;

            #1;


            check_outputs(4'h1, 1'b1, 3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Checking Tens Digit (S1)", test_num);
            reset_dut();
            units = 4'hA; tens = 4'hB; hundreds = 4'hC; thousands = 4'hD;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hB, 1'b1, 3'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Checking Hundreds Digit (S2)", test_num);
            reset_dut();
            units = 4'h5; tens = 4'h6; hundreds = 4'h7; thousands = 4'h8;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h7, 1'b1, 3'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Checking Thousands Digit (S3) - DP should be LOW", test_num);
            reset_dut();
            units = 4'h1; tens = 4'h2; hundreds = 4'h3; thousands = 4'h9;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h9, 1'b0, 3'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Checking Wrap-around (S3 to S0)", test_num);
            reset_dut();
            units = 4'hE; tens = 4'hF; hundreds = 4'h0; thousands = 4'h1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(4'hE, 1'b1, 3'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Checking Data Sensitivity in S2", test_num);
            reset_dut();
            units = 4'h0; tens = 4'h0; hundreds = 4'hA; thousands = 4'h0;
            repeat(2) @(posedge clk);
            #2;
            hundreds = 4'hF;
            #1;
            #1;

            check_outputs(4'hF, 1'b1, 3'd2);
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
        input [3:0] expected_data;
        input expected_decimal_point;
        input [2:0] expected_digit_select;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_decimal_point === (expected_decimal_point ^ decimal_point ^ expected_decimal_point) &&
                expected_digit_select === (expected_digit_select ^ digit_select ^ expected_digit_select)) begin
                $display("PASS");
                $display("  Outputs: data=%h, decimal_point=%b, digit_select=%h",
                         data, decimal_point, digit_select);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, decimal_point=%b, digit_select=%h",
                         expected_data, expected_decimal_point, expected_digit_select);
                $display("  Got:      data=%h, decimal_point=%b, digit_select=%h",
                         data, decimal_point, digit_select);
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
        $dumpvars(0,clk, hundreds, reset_n, tens, thousands, units, data, decimal_point, digit_select);
    end

endmodule
