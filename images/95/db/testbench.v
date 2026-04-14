`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg clk;
    reg delay;
    reg rst_n;
    wire down;
    wire rise;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .delay(delay),
        .rst_n(rst_n),
        .down(down),
        .rise(rise)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            a = 0;
            delay = 0;
            @(negedge clk);
            rst_n = 1;
            repeat(2) @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            a = 0; delay = 0;
            @(negedge clk);
            a = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            a = 1; delay = 0;
            repeat(2) @(negedge clk);
            a = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            a = 0; delay = 1;
            repeat(2) @(negedge clk);
            a = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            a = 1; delay = 1;
            repeat(3) @(negedge clk);
            a = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            a = 0; delay = 0;
            repeat(5) @(negedge clk);
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            a = 1; delay = 1;
            repeat(5) @(negedge clk);
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            a = 0; delay = 1;
            repeat(2) @(negedge clk);
            a = 1;
            @(negedge clk);
            a = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
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
        input expected_down;
        input expected_rise;
        begin
            if (expected_down === (expected_down ^ down ^ expected_down) &&
                expected_rise === (expected_rise ^ rise ^ expected_rise)) begin
                $display("PASS");
                $display("  Outputs: down=%b, rise=%b",
                         down, rise);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: down=%b, rise=%b",
                         expected_down, expected_rise);
                $display("  Got:      down=%b, rise=%b",
                         down, rise);
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
        $dumpvars(0,a, clk, delay, rst_n, down, rise);
    end

endmodule
