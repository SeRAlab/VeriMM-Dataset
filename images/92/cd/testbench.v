`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] binary_num;
    reg clk;
    reg reset;
    wire [1:0] count_ones;
    wire is_even;
    wire is_gte5;

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
        .is_even(is_even),
        .is_gte5(is_gte5)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            binary_num = 3'b000;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: binary_num = 0");
            reset_dut();
            binary_num = 3'b000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: binary_num = 1");
            reset_dut();
            binary_num = 3'b001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: binary_num = 2");
            reset_dut();
            binary_num = 3'b010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: binary_num = 3");
            reset_dut();
            binary_num = 3'b011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd2, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: binary_num = 4");
            reset_dut();
            binary_num = 3'b100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: binary_num = 5");
            reset_dut();
            binary_num = 3'b101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd2, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: binary_num = 6");
            reset_dut();
            binary_num = 3'b110;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd2, 1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: binary_num = 7");
            reset_dut();
            binary_num = 3'b111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd3, 1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Testing Reset persistence");
            reset_dut();
            binary_num = 3'b111;
            @(posedge clk);
            #1;

            if (count_ones == 2'd3 && is_even == 1'b0 && is_gte5 == 1'b1) begin
                reset = 1;
                @(posedge clk);
                #1;

                #1;


                check_outputs(2'd0, 1'b0, 1'b0);
                reset = 0;
            end else begin
                $display("FAIL: Initial setup for reset test failed");
                fail_count = fail_count + 1;
            end
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
        input [1:0] expected_count_ones;
        input expected_is_even;
        input expected_is_gte5;
        begin
            if (expected_count_ones === (expected_count_ones ^ count_ones ^ expected_count_ones) &&
                expected_is_even === (expected_is_even ^ is_even ^ expected_is_even) &&
                expected_is_gte5 === (expected_is_gte5 ^ is_gte5 ^ expected_is_gte5)) begin
                $display("PASS");
                $display("  Outputs: count_ones=%h, is_even=%b, is_gte5=%b",
                         count_ones, is_even, is_gte5);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_ones=%h, is_even=%b, is_gte5=%b",
                         expected_count_ones, expected_is_even, expected_is_gte5);
                $display("  Got:      count_ones=%h, is_even=%b, is_gte5=%b",
                         count_ones, is_even, is_gte5);
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
        $dumpvars(0,binary_num, clk, reset, count_ones, is_even, is_gte5);
    end

endmodule
