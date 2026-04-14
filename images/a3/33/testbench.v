`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [4:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Initial Reset State");
            reset_dut();
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: One cycle shift");
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b10000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Three cycles shift");
            reset_dut();
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(5'b11100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Five cycles shift (Full 1s)");
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Six cycles shift (First 0 shifts in)");
            reset_dut();
            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(5'b01111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Eight cycles shift");
            reset_dut();
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00011);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Full loop back to zero (10 cycles)");
            reset_dut();
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Overflow wrap-around (13 cycles)");
            reset_dut();
            repeat(13) @(posedge clk);
            #1;
            #1;

            check_outputs(5'b11100);
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
        input [4:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, reset, count);
    end

endmodule
