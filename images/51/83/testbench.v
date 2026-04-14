`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] binary_num;
    reg clk;
    reg reset;
    wire [2:0] count_ones;
    wire is_lte4;
    wire is_prime;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_num(binary_num),
        .clk(clk),
        .reset(reset),
        .count_ones(count_ones),
        .is_lte4(is_lte4),
        .is_prime(is_prime)
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
            reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary_num = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary_num = 4'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary_num = 4'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary_num = 4'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd2, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary_num = 4'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd1, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary_num = 4'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd2, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary_num = 4'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd3, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary_num = 4'd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd1, 1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary_num = 4'd11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd3, 1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary_num = 4'd13;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd3, 1'b0, 1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary_num = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd4, 1'b0, 1'b0);
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
        testcase011();
        
        
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
        input [2:0] expected_count_ones;
        input expected_is_lte4;
        input expected_is_prime;
        begin
            if (expected_count_ones === (expected_count_ones ^ count_ones ^ expected_count_ones) &&
                expected_is_lte4 === (expected_is_lte4 ^ is_lte4 ^ expected_is_lte4) &&
                expected_is_prime === (expected_is_prime ^ is_prime ^ expected_is_prime)) begin
                $display("PASS");
                $display("  Outputs: count_ones=%h, is_lte4=%b, is_prime=%b",
                         count_ones, is_lte4, is_prime);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_ones=%h, is_lte4=%b, is_prime=%b",
                         expected_count_ones, expected_is_lte4, expected_is_prime);
                $display("  Got:      count_ones=%h, is_lte4=%b, is_prime=%b",
                         count_ones, is_lte4, is_prime);
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
        $dumpvars(0,binary_num, clk, reset, count_ones, is_lte4, is_prime);
    end

endmodule
