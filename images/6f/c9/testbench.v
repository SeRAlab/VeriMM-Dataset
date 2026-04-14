`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] binary_num;
    reg clk;
    reg reset;
    wire [3:0] count_zeros;
    wire is_lte10;
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
        .count_zeros(count_zeros),
        .is_lte10(is_lte10),
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
            binary_num = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Input 0 (00000)", test_num);
            reset_dut();
            binary_num = 5'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd5, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Input 1 (00001)", test_num);
            reset_dut();
            binary_num = 5'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd4, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Input 4 (00100)", test_num);
            reset_dut();
            binary_num = 5'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd4, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Input 9 (01001)", test_num);
            reset_dut();
            binary_num = 5'd9;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Input 10 (01010)", test_num);
            reset_dut();
            binary_num = 5'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Input 11 (01011)", test_num);
            reset_dut();
            binary_num = 5'd11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Input 16 (10000)", test_num);
            reset_dut();
            binary_num = 5'd16;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd4, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Input 25 (11001)", test_num);
            reset_dut();
            binary_num = 5'd25;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2, 1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Input 31 (11111)", test_num);
            reset_dut();
            binary_num = 5'd31;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Input 7 (00111)", test_num);
            reset_dut();
            binary_num = 5'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2, 1'b1, 1'b0);
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
        input [3:0] expected_count_zeros;
        input expected_is_lte10;
        input expected_is_perfect_square;
        begin
            if (expected_count_zeros === (expected_count_zeros ^ count_zeros ^ expected_count_zeros) &&
                expected_is_lte10 === (expected_is_lte10 ^ is_lte10 ^ expected_is_lte10) &&
                expected_is_perfect_square === (expected_is_perfect_square ^ is_perfect_square ^ expected_is_perfect_square)) begin
                $display("PASS");
                $display("  Outputs: count_zeros=%h, is_lte10=%b, is_perfect_square=%b",
                         count_zeros, is_lte10, is_perfect_square);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_zeros=%h, is_lte10=%b, is_perfect_square=%b",
                         expected_count_zeros, expected_is_lte10, expected_is_perfect_square);
                $display("  Got:      count_zeros=%h, is_lte10=%b, is_perfect_square=%b",
                         count_zeros, is_lte10, is_perfect_square);
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
        $dumpvars(0,binary_num, clk, reset, count_zeros, is_lte10, is_perfect_square);
    end

endmodule
