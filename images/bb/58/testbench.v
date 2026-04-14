`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] binary_num;
    reg clk;
    reg reset;
    wire [3:0] digit_sum;
    wire is_even;
    wire is_perfect_square;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_num(binary_num),
        .clk(clk),
        .reset(reset),
        .digit_sum(digit_sum),
        .is_even(is_even),
        .is_perfect_square(is_perfect_square)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            binary_num = 4'b0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Reset functionality", test_num);
            binary_num = 4'b1111;
            reset = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'd0, 1'b0, 1'b0);
            reset = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Input 0 (Even, Perfect Square)", test_num);
            reset_dut();
            binary_num = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Input 1 (Odd, Perfect Square)", test_num);
            reset_dut();
            binary_num = 4'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Input 2 (Even, Not Square)", test_num);
            reset_dut();
            binary_num = 4'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Input 4 (Even, Perfect Square)", test_num);
            reset_dut();
            binary_num = 4'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %03d: Input 7 (Odd, Not Square)", test_num);
            reset_dut();
            binary_num = 4'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %03d: Input 9 (Odd, Perfect Square)", test_num);
            reset_dut();
            binary_num = 4'd9;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %03d: Input 10 (Even, Not Square)", test_num);
            reset_dut();
            binary_num = 4'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2, 1'b1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %03d: Input 14 (Even, Not Square)", test_num);
            reset_dut();
            binary_num = 4'd14;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, 1'b1, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %03d: Input 15 (Odd, Not Square)", test_num);
            reset_dut();
            binary_num = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd4, 1'b0, 1'b0);
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
        input [3:0] expected_digit_sum;
        input expected_is_even;
        input expected_is_perfect_square;
        begin
            if (expected_digit_sum === (expected_digit_sum ^ digit_sum ^ expected_digit_sum) &&
                expected_is_even === (expected_is_even ^ is_even ^ expected_is_even) &&
                expected_is_perfect_square === (expected_is_perfect_square ^ is_perfect_square ^ expected_is_perfect_square)) begin
                $display("PASS");
                $display("  Outputs: digit_sum=%h, is_even=%b, is_perfect_square=%b",
                         digit_sum, is_even, is_perfect_square);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digit_sum=%h, is_even=%b, is_perfect_square=%b",
                         expected_digit_sum, expected_is_even, expected_is_perfect_square);
                $display("  Got:      digit_sum=%h, is_even=%b, is_perfect_square=%b",
                         digit_sum, is_even, is_perfect_square);
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
        $dumpvars(0,binary_num, clk, reset, digit_sum, is_even, is_perfect_square);
    end

endmodule
