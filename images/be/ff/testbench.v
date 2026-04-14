`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] binary_num;
    reg clk;
    reg reset;
    wire [2:0] count_zeros;
    wire is_lt16;
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
        .is_lt16(is_lt16),
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
            binary_num = 5'b0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary_num = 5'b00000;
            @(posedge clk);
            #1;
            $display("Test Case %0d: binary_num = 5'b00000", test_num);
            #1;

            check_outputs(3'd5, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary_num = 5'b11111;
            @(posedge clk);
            #1;
            $display("Test Case %0d: binary_num = 5'b11111", test_num);
            #1;

            check_outputs(3'd0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary_num = 5'b10101;
            @(posedge clk);
            #1;
            $display("Test Case %0d: binary_num = 5'b10101", test_num);
            #1;

            check_outputs(3'd2, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary_num = 5'b01010;
            @(posedge clk);
            #1;
            $display("Test Case %0d: binary_num = 5'b01010", test_num);
            #1;

            check_outputs(3'd3, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary_num = 5'b10000;
            @(posedge clk);
            #1;
            $display("Test Case %0d: binary_num = 5'b10000", test_num);
            #1;

            check_outputs(3'd4, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary_num = 5'b01111;
            @(posedge clk);
            #1;
            $display("Test Case %0d: binary_num = 5'b01111", test_num);
            #1;

            check_outputs(3'd1, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary_num = 5'b11010;
            @(posedge clk);
            #1;
            $display("Test Case %0d: binary_num = 5'b11010", test_num);
            #1;

            check_outputs(3'd2, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary_num = 5'b00110;
            @(posedge clk);
            #1;
            $display("Test Case %0d: binary_num = 5'b00110", test_num);
            #1;

            check_outputs(3'd3, 1'b1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Synchronous Reset State Check", test_num);
            binary_num = 5'b11111;
            reset = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd0, 1'b0, 1'b0);
            reset = 0;
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary_num = 5'b10001;
            @(posedge clk);
            #1;
            $display("Test Case %0d: binary_num = 5'b10001", test_num);
            #1;

            check_outputs(3'd3, 1'b0, 1'b1);
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
        testcase009();
        testcase010();
        
        
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
        input [2:0] expected_count_zeros;
        input expected_is_lt16;
        input expected_is_palindrome;
        begin
            if (expected_count_zeros === (expected_count_zeros ^ count_zeros ^ expected_count_zeros) &&
                expected_is_lt16 === (expected_is_lt16 ^ is_lt16 ^ expected_is_lt16) &&
                expected_is_palindrome === (expected_is_palindrome ^ is_palindrome ^ expected_is_palindrome)) begin
                $display("PASS");
                $display("  Outputs: count_zeros=%h, is_lt16=%b, is_palindrome=%b",
                         count_zeros, is_lt16, is_palindrome);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_zeros=%h, is_lt16=%b, is_palindrome=%b",
                         expected_count_zeros, expected_is_lt16, expected_is_palindrome);
                $display("  Got:      count_zeros=%h, is_lt16=%b, is_palindrome=%b",
                         count_zeros, is_lt16, is_palindrome);
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
        $dumpvars(0,binary_num, clk, reset, count_zeros, is_lt16, is_palindrome);
    end

endmodule
