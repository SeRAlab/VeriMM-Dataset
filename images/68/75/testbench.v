`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg rst;
    wire [8:0] sum;

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
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic addition (10 + 20)");
            reset_dut();
            a = 8'd10;
            b = 8'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'd30);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Carry-out check (255 + 1)");
            reset_dut();
            a = 8'd255;
            b = 8'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'd256);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Maximum values (255 + 255)");
            reset_dut();
            a = 8'd255;
            b = 8'd255;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'd510);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Zero addition (0 + 0)");
            reset_dut();
            a = 8'd0;
            b = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Mid-range addition (128 + 64)");
            reset_dut();
            a = 8'd128;
            b = 8'd64;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'd192);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Reset priority check");
            reset_dut();
            a = 8'hFF;
            b = 8'hFF;
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'd0);
            rst = 0;
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Sequential logic check (127 + 1)");
            reset_dut();
            a = 8'd127;
            b = 8'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'd128);
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
        input [8:0] expected_sum;
        begin
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
        $dumpvars(0,a, b, clk, rst, sum);
    end

endmodule
