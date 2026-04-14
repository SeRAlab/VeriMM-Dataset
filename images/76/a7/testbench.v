`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] binary_num;
    reg clk;
    reg reset;
    wire [2:0] count_zeros;
    wire is_gte8;
    wire is_power_of_two;

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
        .is_gte8(is_gte8),
        .is_power_of_two(is_power_of_two)
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
            binary_num = 4'b0000;
            @(posedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary 0000", test_num);
            reset_dut();
            binary_num = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd4, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary 0001", test_num);
            reset_dut();
            binary_num = 4'b0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd3, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary 0010", test_num);
            reset_dut();
            binary_num = 4'b0010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd3, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary 0100", test_num);
            reset_dut();
            binary_num = 4'b0100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd3, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary 1000", test_num);
            reset_dut();
            binary_num = 4'b1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd3, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary 1111", test_num);
            reset_dut();
            binary_num = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary 0111", test_num);
            reset_dut();
            binary_num = 4'b0111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd1, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary 1001", test_num);
            reset_dut();
            binary_num = 4'b1001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd2, 1'b1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary 1010", test_num);
            reset_dut();
            binary_num = 4'b1010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd2, 1'b1, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary 0011", test_num);
            reset_dut();
            binary_num = 4'b0011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd2, 1'b0, 1'b0);
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
        input expected_is_gte8;
        input expected_is_power_of_two;
        begin
            if (expected_count_zeros === (expected_count_zeros ^ count_zeros ^ expected_count_zeros) &&
                expected_is_gte8 === (expected_is_gte8 ^ is_gte8 ^ expected_is_gte8) &&
                expected_is_power_of_two === (expected_is_power_of_two ^ is_power_of_two ^ expected_is_power_of_two)) begin
                $display("PASS");
                $display("  Outputs: count_zeros=%h, is_gte8=%b, is_power_of_two=%b",
                         count_zeros, is_gte8, is_power_of_two);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_zeros=%h, is_gte8=%b, is_power_of_two=%b",
                         expected_count_zeros, expected_is_gte8, expected_is_power_of_two);
                $display("  Got:      count_zeros=%h, is_gte8=%b, is_power_of_two=%b",
                         count_zeros, is_gte8, is_power_of_two);
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
        $dumpvars(0,binary_num, clk, reset, count_zeros, is_gte8, is_power_of_two);
    end

endmodule
