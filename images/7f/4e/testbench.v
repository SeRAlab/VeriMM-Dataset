`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] binary_num;
    reg clk;
    reg reset;
    wire [3:0] count_zeros;
    wire is_even;
    wire is_lte50;

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
        .is_even(is_even),
        .is_lte50(is_lte50)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: binary_num = 0", test_num);
            binary_num = 7'd0;
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd7, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: binary_num = 50", test_num);
            binary_num = 7'd50;
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd4, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: binary_num = 51", test_num);
            binary_num = 7'd51;
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: binary_num = 127", test_num);
            binary_num = 7'd127;
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: binary_num = 64", test_num);
            binary_num = 7'd64;
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd6, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: binary_num = 13", test_num);
            binary_num = 7'd13;
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd4, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: binary_num = 85", test_num);
            binary_num = 7'd85;
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, 1'b0, 1'b0);
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
        input expected_is_even;
        input expected_is_lte50;
        begin
            if (expected_count_zeros === (expected_count_zeros ^ count_zeros ^ expected_count_zeros) &&
                expected_is_even === (expected_is_even ^ is_even ^ expected_is_even) &&
                expected_is_lte50 === (expected_is_lte50 ^ is_lte50 ^ expected_is_lte50)) begin
                $display("PASS");
                $display("  Outputs: count_zeros=%h, is_even=%b, is_lte50=%b",
                         count_zeros, is_even, is_lte50);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_zeros=%h, is_even=%b, is_lte50=%b",
                         expected_count_zeros, expected_is_even, expected_is_lte50);
                $display("  Got:      count_zeros=%h, is_even=%b, is_lte50=%b",
                         count_zeros, is_even, is_lte50);
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
        $dumpvars(0,binary_num, clk, reset, count_zeros, is_even, is_lte50);
    end

endmodule
