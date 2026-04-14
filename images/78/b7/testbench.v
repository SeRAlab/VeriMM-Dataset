`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire clk_div_by14;
    wire clk_div_by15;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk_div_by14(clk_div_by14),
        .clk_div_by15(clk_div_by15)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin


            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Checking initial state logic (MSB should be 0)", test_num);
            reset_dut();
            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Checking logic just before MSB toggle (Cycle 16383)", test_num);


            repeat (16383 - 11) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Checking logic at MSB toggle (Cycle 16384)", test_num);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Checking logic before counter wrap (Cycle 32767)", test_num);
            repeat (32767 - 16384) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Checking logic after counter wrap (Cycle 32768)", test_num);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_clk_div_by14;
        input expected_clk_div_by15;
        begin
            if (expected_clk_div_by14 === (expected_clk_div_by14 ^ clk_div_by14 ^ expected_clk_div_by14) &&
                expected_clk_div_by15 === (expected_clk_div_by15 ^ clk_div_by15 ^ expected_clk_div_by15)) begin
                $display("PASS");
                $display("  Outputs: clk_div_by14=%b, clk_div_by15=%b",
                         clk_div_by14, clk_div_by15);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_div_by14=%b, clk_div_by15=%b",
                         expected_clk_div_by14, expected_clk_div_by15);
                $display("  Got:      clk_div_by14=%b, clk_div_by15=%b",
                         clk_div_by14, clk_div_by15);
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
        $dumpvars(0,clk, clk_div_by14, clk_div_by15);
    end

endmodule
