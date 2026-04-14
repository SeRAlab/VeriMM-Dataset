`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    reg test_input;
    wire [3:0] count_out;
    wire test_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .rst(rst),
        .test_input(test_input),
        .count_out(count_out),
        .test_output(test_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            test_input = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Reset Check");
            reset_dut();

            #1;


            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Increment to 5");
            reset_dut();
            en = 1;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(4'h5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Enable signal toggle");
            reset_dut();
            en = 1;
            repeat(3) @(posedge clk);
            en = 0;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(4'h3, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Counter Overflow (15 -> 0)");
            reset_dut();
            en = 1;
            repeat(16) @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: test_input=1 at count=15");
            reset_dut();
            en = 1;
            test_input = 1;
            repeat(15) @(posedge clk);
            #1;

            #1;


            check_outputs(4'hF, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: test_input=0 at count=15");
            reset_dut();
            en = 1;
            test_input = 0;
            repeat(15) @(posedge clk);
            #1;

            #1;


            check_outputs(4'hF, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: test_output return to 0 after overflow");
            reset_dut();
            en = 1;
            test_input = 1;
            repeat(16) @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 1'b0);
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
        input [3:0] expected_count_out;
        input expected_test_output;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out) &&
                expected_test_output === (expected_test_output ^ test_output ^ expected_test_output)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h, test_output=%b",
                         count_out, test_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h, test_output=%b",
                         expected_count_out, expected_test_output);
                $display("  Got:      count_out=%h, test_output=%b",
                         count_out, test_output);
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
        $dumpvars(0,clk, en, rst, test_input, count_out, test_output);
    end

endmodule
