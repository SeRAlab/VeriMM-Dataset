`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] bcd_digit;
    reg clk;
    reg mode;
    wire [7:0] excess_3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bcd_digit(bcd_digit),
        .clk(clk),
        .mode(mode),
        .excess_3(excess_3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            bcd_digit = 4'b0;
            mode = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task feed_digits;

        input [3:0] d1, d2, d3, d4, d5;
        input m;
        begin
            mode = m;
            @(posedge clk) bcd_digit = d1;
            @(posedge clk) bcd_digit = d2;
            @(posedge clk) bcd_digit = d3;
            @(posedge clk) bcd_digit = d4;
            @(posedge clk) bcd_digit = d5;

            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            $display("Running Testcase 001: Mode 0, Input 1-2-3-4-5");
            reset_dut();
            test_num = test_num + 1;
            feed_digits(4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 1'b0);
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Mode 0, Input 0-0-0-0-9");
            reset_dut();
            test_num = test_num + 1;
            feed_digits(4'd0, 4'd0, 4'd0, 4'd0, 4'd9, 1'b0);
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Mode 1, Input 1-1-1-1-0");
            reset_dut();
            test_num = test_num + 1;
            feed_digits(4'd1, 4'd1, 4'd1, 4'd1, 4'd0, 1'b1);
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Mode 1, Input 2-4-6-8-9");
            reset_dut();
            test_num = test_num + 1;
            feed_digits(4'd2, 4'd4, 4'd6, 4'd8, 4'd9, 1'b1);
            #1;

            check_outputs(8'h14);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Mode 0, Input 0-0-0-0-0");
            reset_dut();
            test_num = test_num + 1;
            feed_digits(4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 1'b0);
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Mode 1, Input 5-5-5-5-5");
            reset_dut();
            test_num = test_num + 1;
            feed_digits(4'd5, 4'd5, 4'd5, 4'd5, 4'd5, 1'b1);
            #1;

            check_outputs(8'h10);
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
        input [7:0] expected_excess_3;
        begin
            if (expected_excess_3 === (expected_excess_3 ^ excess_3 ^ expected_excess_3)) begin
                $display("PASS");
                $display("  Outputs: excess_3=%h",
                         excess_3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: excess_3=%h",
                         expected_excess_3);
                $display("  Got:      excess_3=%h",
                         excess_3);
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
        $dumpvars(0,bcd_digit, clk, mode, excess_3);
    end

endmodule
