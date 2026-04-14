`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] binary_num;
    reg clk;
    reg reset;
    wire is_multiple_of_4;
    wire is_palindrome;
    wire [3:0] sum_bits;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_num(binary_num),
        .clk(clk),
        .reset(reset),
        .is_multiple_of_4(is_multiple_of_4),
        .is_palindrome(is_palindrome),
        .sum_bits(sum_bits)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            binary_num = 8'b0;
            @(negedge clk);
            reset = 0;

            @(posedge clk);
            #1;
            if (is_multiple_of_4 === 0 && is_palindrome === 0 && sum_bits === 0)
                $display("Reset successful: Outputs cleared.");
            else
                $display("Reset failed: Outputs not cleared.");
        end
        endtask
    task testcase001;

        begin
            $display("\nTest Case 001: binary_num = 8'b00000000 (Value: 0)");
            test_num = 1;
            reset_dut();
            binary_num = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1, 4'd0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTest Case 002: binary_num = 8'b00000100 (Value: 4)");
            test_num = 2;
            reset_dut();
            binary_num = 8'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 4'd1);
        end
        endtask

    task testcase003;

        begin
            $display("\nTest Case 003: binary_num = 8'b11111111 (Value: 255)");
            test_num = 3;
            reset_dut();
            binary_num = 8'd255;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 4'd8);
        end
        endtask

    task testcase004;

        begin
            $display("\nTest Case 004: binary_num = 8'b10000001 (Value: 129)");
            test_num = 4;
            reset_dut();
            binary_num = 8'b1000_0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 4'd2);
        end
        endtask

    task testcase005;

        begin
            $display("\nTest Case 005: binary_num = 8'b00001100 (Value: 12)");
            test_num = 5;
            reset_dut();
            binary_num = 8'd12;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 4'd2);
        end
        endtask

    task testcase006;

        begin
            $display("\nTest Case 006: binary_num = 8'b10101010 (Value: 170)");
            test_num = 6;
            reset_dut();
            binary_num = 8'd170;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 4'd4);
        end
        endtask

    task testcase007;

        begin
            $display("\nTest Case 007: binary_num = 8'b10011001 (Value: 153)");
            test_num = 7;
            reset_dut();
            binary_num = 8'd153;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 4'd4);
        end
        endtask

    task testcase008;

        begin
            $display("\nTest Case 008: binary_num = 8'b00010000 (Value: 16)");
            test_num = 8;
            reset_dut();
            binary_num = 8'd16;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 4'd1);
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
        input expected_is_multiple_of_4;
        input expected_is_palindrome;
        input [3:0] expected_sum_bits;
        begin
            if (expected_is_multiple_of_4 === (expected_is_multiple_of_4 ^ is_multiple_of_4 ^ expected_is_multiple_of_4) &&
                expected_is_palindrome === (expected_is_palindrome ^ is_palindrome ^ expected_is_palindrome) &&
                expected_sum_bits === (expected_sum_bits ^ sum_bits ^ expected_sum_bits)) begin
                $display("PASS");
                $display("  Outputs: is_multiple_of_4=%b, is_palindrome=%b, sum_bits=%h",
                         is_multiple_of_4, is_palindrome, sum_bits);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_multiple_of_4=%b, is_palindrome=%b, sum_bits=%h",
                         expected_is_multiple_of_4, expected_is_palindrome, expected_sum_bits);
                $display("  Got:      is_multiple_of_4=%b, is_palindrome=%b, sum_bits=%h",
                         is_multiple_of_4, is_palindrome, sum_bits);
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
        $dumpvars(0,binary_num, clk, reset, is_multiple_of_4, is_palindrome, sum_bits);
    end

endmodule
