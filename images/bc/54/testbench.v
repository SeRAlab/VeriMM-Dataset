`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] binary_num;
    reg clk;
    reg reset;
    wire [3:0] count_zeros;
    wire is_multiple_of_8;
    wire is_palindrome;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_num(binary_num),
        .clk(clk),
        .reset(reset),
        .count_zeros(count_zeros),
        .is_multiple_of_8(is_multiple_of_8),
        .is_palindrome(is_palindrome)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        binary_num = 0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        binary_num = 12'b0000_0000_0000;
        @(posedge clk);
        #1;
        $display("Test 001: All Zeros (12'h000)");
        #1;

        check_outputs(4'd12, 1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        binary_num = 12'b1111_1111_1111;
        @(posedge clk);
        #1;
        $display("Test 002: All Ones (12'hFFF)");
        #1;

        check_outputs(4'd0, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        binary_num = 12'b0000_0000_1000;
        @(posedge clk);
        #1;
        $display("Test 003: Value 8 (12'h008)");
        #1;

        check_outputs(4'd11, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        binary_num = 12'b0001_1001_1000;
        @(posedge clk);
        #1;
        $display("Test 004: Palindrome Multiple of 8 (12'h198)");
        #1;

        check_outputs(4'd8, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        binary_num = 12'b1111_0000_1111;
        @(posedge clk);
        #1;
        $display("Test 005: Palindrome Non-Multiple of 8 (12'hF0F)");
        #1;

        check_outputs(4'd4, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        binary_num = 12'b1111_1111_1000;
        @(posedge clk);
        #1;
        $display("Test 006: Max Multiple of 8 (12'hFF8)");
        #1;

        check_outputs(4'd3, 1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        binary_num = 12'b1010_1010_1011;
        @(posedge clk);
        #1;
        $display("Test 007: Random Value (12'hAAB)");
        #1;

        check_outputs(4'd5, 1'b0, 1'b0);
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
        input [3:0] expected_count_zeros;
        input expected_is_multiple_of_8;
        input expected_is_palindrome;
        begin
            if (expected_count_zeros === (expected_count_zeros ^ count_zeros ^ expected_count_zeros) &&
                expected_is_multiple_of_8 === (expected_is_multiple_of_8 ^ is_multiple_of_8 ^ expected_is_multiple_of_8) &&
                expected_is_palindrome === (expected_is_palindrome ^ is_palindrome ^ expected_is_palindrome)) begin
                $display("PASS");
                $display("  Outputs: count_zeros=%h, is_multiple_of_8=%b, is_palindrome=%b",
                         count_zeros, is_multiple_of_8, is_palindrome);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_zeros=%h, is_multiple_of_8=%b, is_palindrome=%b",
                         expected_count_zeros, expected_is_multiple_of_8, expected_is_palindrome);
                $display("  Got:      count_zeros=%h, is_multiple_of_8=%b, is_palindrome=%b",
                         count_zeros, is_multiple_of_8, is_palindrome);
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
        $dumpvars(0,binary_num, clk, reset, count_zeros, is_multiple_of_8, is_palindrome);
    end

endmodule
