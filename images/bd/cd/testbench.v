`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg enable;
    reg in;
    reg reset_n;
    wire [9:0] data;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enable(enable),
        .in(in),
        .reset_n(reset_n),
        .data(data),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset_n = 0;
            enable = 0;
            in = 0;

            #7;
            reset_n = 1;
            @(negedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test Case 001: Checking Reset State");

            #1;


            check_outputs(10'h200, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test Case 002: Single Shift In=1");
            @(negedge clock);
            enable = 1;
            in = 1;
            @(negedge clock);
            enable = 0;

            #1;


            check_outputs(10'h001, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test Case 003: Single Shift In=0");
            @(negedge clock);
            enable = 1;
            in = 0;
            @(negedge clock);
            enable = 0;

            #1;


            check_outputs(10'h000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test Case 004: Enable=0 Holding State");
            @(negedge clock);
            enable = 0;
            in = 1;
            repeat(2) @(negedge clock);

            #1;


            check_outputs(10'h200, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test Case 005: Shifting Sequence 1 -> 0 -> 1");
            @(negedge clock);
            enable = 1;
            in = 1; @(negedge clock);
            in = 0; @(negedge clock);
            in = 1; @(negedge clock);
            enable = 0;
            #1;

            check_outputs(10'h005, 1'b1);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            reset_dut();
            $display("Test Case 006: Filling with 10 ones");
            @(negedge clock);
            enable = 1;
            in = 1;
            repeat(10) @(negedge clock);
            enable = 0;

            #1;


            check_outputs(10'h3FF, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Test Case 007: Interrupted shifting (toggle enable)");
            @(negedge clock);
            enable = 1; in = 1; @(negedge clock);
            enable = 0; in = 1; @(negedge clock);
            enable = 1; in = 1; @(negedge clock);
            enable = 1; in = 0; @(negedge clock);
            enable = 0;
            #1;

            check_outputs(10'h006, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            $display("Test Case 008: Clearing register with 10 zeros");
            @(negedge clock);
            enable = 1;
            in = 0;
            repeat(10) @(negedge clock);
            enable = 0;
            #1;

            check_outputs(10'h000, 1'b0);
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
        input [9:0] expected_data;
        input expected_out;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: data=%h, out=%b",
                         data, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, out=%b",
                         expected_data, expected_out);
                $display("  Got:      data=%h, out=%b",
                         data, out);
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
        $dumpvars(0,clock, enable, in, reset_n, data, out);
    end

endmodule
