`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [3:0] count;
    wire out_range;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .count(count),
        .out_range(out_range)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Reset State");
            #1;

            check_outputs(4'b0000, 1'b0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            reset_dut();
            $display("Testcase 002: Count to 5");
            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(4'd5, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            reset_dut();
            $display("Testcase 003: Reach Threshold 10");
            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(4'd10, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            reset_dut();
            $display("Testcase 004: Reach Max 15");
            for (i = 0; i < 15; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(4'd15, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();
            $display("Testcase 005: Wrap around to 0");
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            reset_dut();
            $display("Testcase 006: Threshold after first wrap (16+10)");
            for (i = 0; i < 26; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(4'd10, 1'b1);
        end
        endtask

    task testcase007;

        integer i;
        begin
            reset_dut();
            $display("Testcase 007: Mid-count reset at value 12");
            for (i = 0; i < 12; i = i + 1) begin
                @(posedge clk);
            end

            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
            #1;

            check_outputs(4'd0, 1'b0);
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
        input [3:0] expected_count;
        input expected_out_range;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_out_range === (expected_out_range ^ out_range ^ expected_out_range)) begin
                $display("PASS");
                $display("  Outputs: count=%h, out_range=%b",
                         count, out_range);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, out_range=%b",
                         expected_count, expected_out_range);
                $display("  Got:      count=%h, out_range=%b",
                         count, out_range);
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
        $dumpvars(0,clk, rst, count, out_range);
    end

endmodule
