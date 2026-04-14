`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] nums;
    reg rst;
    wire [3:0] digit;
    wire [6:0] display;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .nums(nums),
        .rst(rst),
        .digit(digit),
        .display(display)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            nums = 16'h0000;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task wait_for_digit;

        input [3:0] target_digit;
        integer timeout;
        begin
            timeout = 0;
            while (digit !== target_digit && timeout < 2000) begin
                @(posedge clk);
                timeout = timeout + 1;
            end
        end
        endtask

    task testcase001;

        begin
            $display("Running testcase001: Initial state check...");
            reset_dut();

            wait_for_digit(4'b0001);
            #1;

            check_outputs(4'b0001, 7'h3F);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Digit 0 check with value 4...");
            reset_dut();
            nums = 16'h1234;
            wait_for_digit(4'b0001);
            #1;

            check_outputs(4'b0001, 7'h66);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Digit 1 check with value 3...");
            reset_dut();
            nums = 16'h1234;
            wait_for_digit(4'b0010);
            #1;

            check_outputs(4'b0010, 7'h4F);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Digit 2 check with value 7...");
            reset_dut();
            nums = 16'h5678;
            wait_for_digit(4'b0100);
            #1;

            check_outputs(4'b0100, 7'h07);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Digit 3 check with hex value A...");
            reset_dut();
            nums = 16'hABCD;
            wait_for_digit(4'b1000);
            #1;

            check_outputs(4'b1000, 7'h77);
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
        input [3:0] expected_digit;
        input [6:0] expected_display;
        begin
            if (expected_digit === (expected_digit ^ digit ^ expected_digit) &&
                expected_display === (expected_display ^ display ^ expected_display)) begin
                $display("PASS");
                $display("  Outputs: digit=%h, display=%h",
                         digit, display);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digit=%h, display=%h",
                         expected_digit, expected_display);
                $display("  Got:      digit=%h, display=%h",
                         digit, display);
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
        $dumpvars(0,clk, nums, rst, digit, display);
    end

endmodule
