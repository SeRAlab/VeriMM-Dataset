`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable_clk;
    reg reset;
    wire falling_edge;
    wire middle_of_high_level;
    wire middle_of_low_level;
    wire new_clk;
    wire rising_edge;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable_clk(enable_clk),
        .reset(reset),
        .falling_edge(falling_edge),
        .middle_of_high_level(middle_of_high_level),
        .middle_of_low_level(middle_of_low_level),
        .new_clk(new_clk),
        .rising_edge(rising_edge)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable_clk = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            enable_clk = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 0, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            enable_clk = 1;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 1, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            enable_clk = 1;
            repeat(6) @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            enable_clk = 1;
            repeat(8) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            enable_clk = 1;
            repeat(11) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 0, 1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            enable_clk = 1;
            repeat(2) @(posedge clk);
            enable_clk = 0;
            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(0, 0, 0, 0, 0);
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
        input expected_falling_edge;
        input expected_middle_of_high_level;
        input expected_middle_of_low_level;
        input expected_new_clk;
        input expected_rising_edge;
        begin
            if (expected_falling_edge === (expected_falling_edge ^ falling_edge ^ expected_falling_edge) &&
                expected_middle_of_high_level === (expected_middle_of_high_level ^ middle_of_high_level ^ expected_middle_of_high_level) &&
                expected_middle_of_low_level === (expected_middle_of_low_level ^ middle_of_low_level ^ expected_middle_of_low_level) &&
                expected_new_clk === (expected_new_clk ^ new_clk ^ expected_new_clk) &&
                expected_rising_edge === (expected_rising_edge ^ rising_edge ^ expected_rising_edge)) begin
                $display("PASS");
                $display("  Outputs: falling_edge=%b, middle_of_high_level=%b, middle_of_low_level=%b, new_clk=%b, rising_edge=%b",
                         falling_edge, middle_of_high_level, middle_of_low_level, new_clk, rising_edge);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: falling_edge=%b, middle_of_high_level=%b, middle_of_low_level=%b, new_clk=%b, rising_edge=%b",
                         expected_falling_edge, expected_middle_of_high_level, expected_middle_of_low_level, expected_new_clk, expected_rising_edge);
                $display("  Got:      falling_edge=%b, middle_of_high_level=%b, middle_of_low_level=%b, new_clk=%b, rising_edge=%b",
                         falling_edge, middle_of_high_level, middle_of_low_level, new_clk, rising_edge);
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
        $dumpvars(0,clk, enable_clk, reset, falling_edge, middle_of_high_level, middle_of_low_level, new_clk, rising_edge);
    end

endmodule
