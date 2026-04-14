`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    reg rst;
    wire carry_out;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst(rst),
        .carry_out(carry_out),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            a = 0;
            b = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            a = 4'sd2; b = 4'sd1;
            @(posedge clk);
            #1;
            $display("Testcase 001: 2 + 1 (Expected Sum=3, C=0)");
            #1;

            check_outputs(1'b0, 4'sd3);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            a = 4'sd-1; b = 4'sd-1;
            @(posedge clk);
            #1;
            $display("Testcase 002: -1 + -1 (Expected Sum=-2, C=1)");
            #1;

            check_outputs(1'b1, 4'sd-2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            a = 4'sd-1; b = 4'sd1;
            @(posedge clk);
            #1;
            $display("Testcase 003: -1 + 1 (Expected Sum=0, C=1)");
            #1;

            check_outputs(1'b1, 4'sd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            a = 4'sd7; b = 4'sd7;
            @(posedge clk);
            #1;
            $display("Testcase 004: 7 + 7 (Expected Sum=-2, C=0)");
            #1;

            check_outputs(1'b0, 4'sd-2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            a = 4'sd-8; b = 4'sd-8;
            @(posedge clk);
            #1;
            $display("Testcase 005: -8 + -8 (Expected Sum=0, C=1)");
            #1;

            check_outputs(1'b1, 4'sd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            a = 4'sd-1; b = 4'sd1;
            @(posedge clk);
            #1;

            a = 4'sd2; b = 4'sd2;
            @(posedge clk);
            #1;
            $display("Testcase 006: Carry Propagation (2 + 2 + prev_C(1) = 5)");
            #1;

            check_outputs(1'b0, 4'sd5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            a = 4'sd-1; b = 4'sd-1;
            @(posedge clk);
            #1;
            a = 4'sd-1; b = 4'sd-1;
            @(posedge clk);
            #1;
            $display("Testcase 007: Multi-cycle carry (-1 + -1 + prev_C(1) = -1)");
            #1;

            check_outputs(1'b1, 4'sd-1);
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
        input expected_carry_out;
        input [3:0] expected_sum;
        begin
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, sum=%h",
                         carry_out, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, sum=%h",
                         expected_carry_out, expected_sum);
                $display("  Got:      carry_out=%b, sum=%h",
                         carry_out, sum);
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
        $dumpvars(0,a, b, clk, rst, carry_out, sum);
    end

endmodule
