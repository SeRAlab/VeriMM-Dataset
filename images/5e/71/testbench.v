`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg start;
    reg stop;
    wire clk_div;
    wire clkdiv;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .stop(stop),
        .clk_div(clk_div),
        .clkdiv(clkdiv)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            stop = 0;
            #20;
            rst = 0;
            start = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            repeat(1200) @(posedge clk);
            #2;

            #1;


            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            repeat(500) @(posedge clk);

            stop = 1;

            repeat(1000) @(posedge clk);
            #2;


            #1;



            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            repeat(35000) @(posedge clk);
            #2;


            #1;



            check_outputs(1, 0);
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
        input expected_clk_div;
        input expected_clkdiv;
        begin
            if (expected_clk_div === (expected_clk_div ^ clk_div ^ expected_clk_div) &&
                expected_clkdiv === (expected_clkdiv ^ clkdiv ^ expected_clkdiv)) begin
                $display("PASS");
                $display("  Outputs: clk_div=%b, clkdiv=%b",
                         clk_div, clkdiv);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_div=%b, clkdiv=%b",
                         expected_clk_div, expected_clkdiv);
                $display("  Got:      clk_div=%b, clkdiv=%b",
                         clk_div, clkdiv);
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
        $dumpvars(0,clk, rst, start, stop, clk_div, clkdiv);
    end

endmodule
